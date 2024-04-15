classdef IES_TM30 < handle
    properties (GetAccess = public, SetAccess = private)
        IES_TM30_spectra_   % 99 reflectivity spectra
        s_                  % spectrum for which we evaluate rendition properties. Scaled to Y_10 = 100
        iCCT_               % its color temperature
        s_ref_              % reference spectrum. Scaled to Y_10 = 100
        CES_XYZ_s_          % 1964 10° XYZ tristimulus values for reflected light off the 99 samples
        CES_XYZ_s_ref_      % same for the reference spectrum
        Jab_s_              % CIECAM J', a', b' (Eqs. 48-50) for 99 reflected spectra
        Jab_s_ref_          % same for reference spectrum
        Delta_E_Jab_        % the 99 color differences, Eq. 52
        Jab_binned_s_       % J'a'b' values averaged over the 16 hue bins
        Jab_binned_s_ref_   % J'a'b' values averaged over the 16 hue bins
    end
    
    methods
        function this = IES_TM30()
            tmp = load('IES_TM30_spectra_raw.mat','IES_TM30_spectra');
            this.IES_TM30_spectra_ = tmp.IES_TM30_spectra;
        end

        function SetSpectrum(obj, s)
            arguments
                obj
                s (1,1) struct
            end

            try
                % 3.0 to 3.4 prepare
                % sanity check
                s = obj.SanityCheck(s);
    
                % Use CIE 1931 XYZ for CCT and for x/y
                % XYZ_10 tristimulus values of test and reference sources scaled such that Y_10 == 100
                % scale s to Y_10 = 100
                obj.s_ = obj.Scale_to_Y10_100(s);
    
                % compute CCT
                obj.iCCT_ = obj.myCCT(obj.s_);
    
                % get reference source
                % Reference illuminant: Planck for < 4000, CIE D for > 5000, linear proportional mix between 4000 and 5000 using spectral scaled to equal Y_10
                obj.s_ref_= obj.ReferenceSource(obj.iCCT_);
    
                % 3.6 Do 99 CES reflectance XYZ_10 for test and reference
                [obj.CES_XYZ_s_, obj.CES_XYZ_s_ref_] = obj.GetCES_XYZ(obj.s_, obj.s_ref_);
                
                % 3.7 Apply CIECAM02
                obj.Jab_s_ = obj.CIECAM02(obj.s_.XYZ1964, obj.CES_XYZ_s_);
                obj.Jab_s_ref_ = obj.CIECAM02(obj.s_ref_.XYZ1964, obj.CES_XYZ_s_ref_);
                
                % 3.8 Color difference
                %     Delta_E_Jab_i
                %         according to Eq 52
                obj.Delta_E_Jab_ = sqrt((obj.Jab_s_.J_prime - obj.Jab_s_ref_.J_prime).^2 + ...
                    (obj.Jab_s_.a_prime - obj.Jab_s_ref_.a_prime).^2 + (obj.Jab_s_.b_prime - obj.Jab_s_ref_.b_prime).^2);
                
                % 4.3 Hue angle bins: J'a'b' values averaged over the 16 hue bins
                obj.Jab_binned_s_ = obj.Jab_binned(obj.Jab_s_);
                obj.Jab_binned_s_ref_ = obj.Jab_binned(obj.Jab_s_ref_);
                
            catch ME
                obj.Clear();
                rethrow(ME);
            end
        end
        
        function [Rf, Rf_i] = FidelityIndex(obj)
            if isempty(obj.s_)
                error('IES_TM30.FidelityIndex: no data, use SetSpectrum first');
            end
            % 4.1 Fidelity index Rf from all Delta_E_Jab_i, Eq 53-54
            Rf_prime = 100 - 6.73 / 99 * sum(obj.Delta_E_Jab_);
            Rf = 10 * log(exp(Rf_prime/10) + 1);

            % 4.2 individual sample Rf,CESi from Delta_E_Jab_i, Eq 55-56
            Rf_prime_CESi = 100 - 6.73 * obj.Delta_E_Jab_;
            Rf_i = 10 * log(exp(Rf_prime_CESi/10) + 1);
        end

        function Rg = GamutIndex(obj)
            % 4.4 Gamut index Rg
            %     Rg = 100 * ratio of polygon areas for test vs ref. Polygon defined by 16 avg aprime bprime values
            test_area = polyarea(obj.Jab_binned_s_.a_prime, obj.Jab_binned_s_.b_prime);
            ref_area =  polyarea(obj.Jab_binned_s_ref_.a_prime, obj.Jab_binned_s_ref_.b_prime);
            Rg = 100 * test_area / ref_area;        % J'a'b' values averaged over the 16 hue bins
        end

        function rv = ColorVectorGraphic(obj)
            % 4.5 Color Vector Graphic
            %     scale ref avg aprime bprime radially to circle with r = 1
            %     apply delta avg aprime bprime 
            %     Plot arrow plot with color background, Fig. 8
            % rv: struct with fields
            %   x_ref, y_ref, x_test, y_test according to (58) - (61)
            %   fig: figure handle to graphic according to Fig. 8 bottom
            ref_bins = obj.Jab_binned_s_ref_.bin;
            ref_h = obj.Jab_binned_s_ref_.h;
            for i = 1:16
                h(i) = mean(ref_h(ref_bins == i)); %#ok<AGROW>
            end
            rv.x_ref = cos(h); % (58)
            rv.y_ref = sin(h); % (59)
            % conflict between standard and code:
            % TM30-18 document says (a_test_j - a_ref_j) / sqrt((a_test_j + b_ref_j)^2)
            % where the denominator is strange. 
            % First, the sqrt and the ^2 cancel to become abs(). It should be sqrt(a^2+b^2)
            % Second, scaling should be norm([a_ref_j,b_ref_j]). It makes no sense to mix
            % a_test with b_ref
            % In the Excel VBA code, they do it like they should but not how the standard is
            % written. We'll do the same.
            den = sqrt((obj.Jab_binned_s_ref_.a_prime).^2 +  (obj.Jab_binned_s_ref_.b_prime).^2);
            rv.x_test = rv.x_ref + (obj.Jab_binned_s_.a_prime ... 
                - obj.Jab_binned_s_ref_.a_prime) ./ den; % (60)
            rv.y_test = rv.y_ref + (obj.Jab_binned_s_.b_prime ...
                - obj.Jab_binned_s_ref_.b_prime) ./ den; % (61)
            fh = figure;
            clf; hold on;
            ax = gca;
            background = imread('CVG_Background.png');
            imshow(background);
            axis on;
            
        end
            % 4.6 Local Chroma shifts R_cs,hj
            %     16 relative radial delta aprime bprimes
            %     Plot as in Fig. 11
            % 4.7 Local Hue Shifts R_hs,hj
            %     16 relative tangential delta aprime bprimes
            %     Plot similar to Fig. 11
            % 4.8 Local Color Fidelity H_f,hj
            %     Similar to 4.1 and 4.2 but now with 16 avg values
            %     Eq 64-65            

        function Clear(obj)
            obj.s_ = [];                 % spectrum for which we evaluate rendition properties. Scaled to Y_10 = 100
            obj.iCCT_ = [];              % its color temperature
            obj.s_ref_ = [];             % reference spectrum. Scaled to Y_10 = 100
            obj.CES_XYZ_s_ = [];         % 1964 10° XYZ tristimulus values for reflected light off the 99 samples
            obj.CES_XYZ_s_ref_ = [];     % same for the reference spectrum
            obj.Jab_s_ = [];             % CIECAM J', a', b' (Eqs. 48-50) for 99 reflected spectra
            obj.Jab_s_ref_ = [];         % same for reference spectrum
            obj.Delta_E_Jab_ = [];       % the 99 color differences, Eq. 52
            obj.Jab_binned_s_ = [];      % J'a'b' values averaged over the 16 hue bins
            obj.Jab_binned_s_ref_ = [];  % J'a'b' values averaged over the 16 hue bins
        end

    end % methods

    methods(Access = private)
        function rv = SanityCheck(~, s)
            [ok, msg, s] = SpectrumSanityCheck(s);
            if ~ok
                error('IES_TM30.Evaluate: spectrum failed sanity test: %s',msg);
            end
            % Wavelength range: at min 400 - 700, at max 380 - 780
            if (min(s.lam) > 400) || (max(s.lam) < 700)
                error('IES_TM30.Evaluate: spectrum must have wavelength range at least 400..700 nm, found [%g,%g]',min(s.lam),max(s.lam));
            end
            rv = s;
        end

        function iCCT = myCCT(~, s)
            [iCCT, dist_uv, ok, errmsg]  = CCT(s);
            if ~ok
                error('IES_TM30.Evaluate: Cannot compute CCT: %s',errmsg);
            end
            if abs(dist_uv) > 0.05
                warning('IES_TM30.Evaluate: CCT |duv| > 0.05: %g',dist_uv);
            end
        end

        function rv = Scale_to_Y10_100(~,s)
            xyz10 = CIE1964_XYZ(s);
            s.val = s.val * 100 / xyz10.Y;
            s.XYZ1964 = CIE1964_XYZ(s);
            rv = s;
        end

        function rv = ReferenceSource(obj,iCCT)
            lam_ref = obj.IES_TM30_spectra_(:,1);
            if iCCT <= 4000
                s_ref = PlanckSpectrum(lam_ref, iCCT);
            elseif iCCT >= 5000
                s_ref = CIE_Illuminant_D(iCCT, 'lam', lam_ref);
            else
                s_Planck = obj.Scale_to_Y10_100( PlanckSpectrum(lam_ref, iCCT));
                s_CIE_D = obj.Scale_to_Y10_100( CIE_Illuminant_D(iCCT, 'lam', lam_ref));
                u = (5000 - iCCT) / 1000;
                s_ref = AddWeightedSpectra({s_Planck, s_CIE_D},[u, 1-u]);
            end
            rv = obj.Scale_to_Y10_100(s_ref);
            rv.name = sprintf('IES TM30 reference spectrum at CCT = %g',iCCT);
        end

        function [CES_XYZ_s, CES_XYZ_s_ref] = GetCES_XYZ(obj, s, s_ref)
            %CES_XYZ_s = struct(); % 1 x 1 empty
            %CES_XYZ_s_ref = struct();
            nCES = 99;
            for i = 1:nCES
                iCES = MakeSpectrumDirect(obj.IES_TM30_spectra_(:,1), obj.IES_TM30_spectra_(:, i+1));
                CES_XYZ_s(i) = CIE1964_XYZ(MultiplySpectra(s, iCES)); %#ok<AGROW> 
                CES_XYZ_s_ref(i) = CIE1964_XYZ(MultiplySpectra(s_ref, iCES)); %#ok<AGROW> 
            end
        end

        function Jab = CIECAM02(~, s_XYZ, CES_XYZ_s)
            % Y_b = 20;
            % F = 1;
            N_c = 1;
            c = 0.69;
            L_A = 100;
            % D = 1;
            k = 1 / (5 * L_A + 1); % 0.0020;
            F_L = 1/5 * k^4 * (5 * L_A) + 1/10 * (1-k^4)^2 * (5 * L_A)^(1/3); % 0.7937;
            n = 0.2000;
            N_bb = 0.75 * n^(-0.2); %1.0003;
            N_cb = N_bb;
            z = 1.48 + sqrt(n); %1.9272
            nCES = 99;
            M_CAT02 = [  0.7328, 0.4296, -0.1624;
                        -0.7036, 1.6975,  0.0061;
                         0.0030, 0.0136,  0.9834];
            inv_M_CAT02 = inv(M_CAT02);
            iRGB_w = M_CAT02 * [s_XYZ.X; s_XYZ.Y; s_XYZ.Z];
            RGB_w = repmat(iRGB_w,1,nCES);
            %     RGB = M_CAT02 * XYZ_10, 
            %         M_CAT02 from Eq (30)
            RGB = nan(3,nCES);
            for i = 1:nCES
                iCES_XYZ = CES_XYZ_s(i);
                RGB(:,i) = M_CAT02 * [iCES_XYZ.X; iCES_XYZ.Y; iCES_XYZ.Z];
            end
            %     RGB_C = 100 ./ RGB_w .* RGB
            RGB_C = 100 * RGB ./ RGB_w;
            RGB_C_w = 100 * RGB_w ./ RGB_w;
            %     RGBprime = M_HPE * inv(M_CAT02) * RGB_C,
            %         M_HPE from Eq(35)
            M_HPE = [ 0.38971, 0.68898, -0.07868;
                     -0.22981, 1.18340,  0.04641;
                      0.00000, 0.00000,  1.00000];
            RGB_prime = (M_HPE * inv_M_CAT02) * RGB_C; %#ok<MINV> 
            RGB_prime_w = (M_HPE * inv_M_CAT02) * RGB_C_w; %#ok<MINV> 
            %     RGB_a_prime = f(RGBprime)
            %         f defined in Eq(36,37,38)
            tmpRGB = (F_L * RGB_prime / 100).^0.42;
            RGB_a_prime = 0.1 + (400 * tmpRGB) ./ (27.13 + tmpRGB);
            tmpRGB_w = (F_L * RGB_prime_w / 100).^0.42;
            RGB_a_prime_w = 0.1 + (400 * tmpRGB_w) ./ (27.13 + tmpRGB_w);
            %     a,b = func(RGA_a_prime)
            %         func defined in Eq (39,40)
            R_a_prime = RGB_a_prime(1,:);
            G_a_prime = RGB_a_prime(2,:);
            B_a_prime = RGB_a_prime(3,:);
            a = R_a_prime - 12/11 * G_a_prime + 1/11 * B_a_prime;
            b = 1/9 * (R_a_prime + G_a_prime - 2 * B_a_prime);
            R_a_prime_w = RGB_a_prime_w(1,:);
            G_a_prime_w = RGB_a_prime_w(2,:);
            B_a_prime_w = RGB_a_prime_w(3,:);
            % a_w = R_a_prime_w - 12/11 * G_a_prime_w + 1/11 * B_a_prime_w;
            % b_w = 1/9 * (R_a_prime_w + G_a_prime_w - 2 * B_a_prime_w);
            %     Lightness J, chroma C, colorfulness M 
            %         according to Eq 41-47
            A = (2 * R_a_prime + G_a_prime + 1/20 * B_a_prime - 0.305) * N_bb;
            A_w = (2 * R_a_prime_w + G_a_prime_w + 1/20 * B_a_prime_w - 0.305) * N_bb;

            J = 100 * (A ./ A_w) .^(c * z);
            h_rad = atan2(b,a);
            e_t = 1/4 * (cos(h_rad + 2) + 3.8);
            t = 50000 / 13 * N_cb * N_c * ((e_t .* sqrt(a.^2 + b.^2)) ./ (R_a_prime + G_a_prime + 21/20 * B_a_prime));
            C = t.^0.9 .* sqrt(J/100) * (1.64 - 0.29^n)^0.73;
            M = C * F_L^0.25;
            %     CAM02-UCS coordinates Jprime, aprime, bprime
            %         according to Eq 48-51
            M_prime = (1 / 0.0228) * log(1 + 0.0228 * M);
            Jab.J_prime = ((1 + 100 * 0.007) * J) ./ (1 + 0.007 * J);
            Jab.a_prime = M_prime .* cos(h_rad);
            Jab.b_prime = M_prime .* sin(h_rad);
        end

        function rv = Jab_binned(obj, Jab) % hue angle bins
            % 4.3 Hue-angle bins
            %     Put all 99 aprime bprime values for CES_i from reference into 16 angle bins
            %     Put all 99 aprime bprime values for CES_i from test into the same corresponding bins
            %     Compute average aprime bprime values for all 16 bins, both for ref and test
            % compute hue angles -> [-pi;pi] based on reference spectrum
            angle = atan2(obj.Jab_s_ref_.b_prime, obj.Jab_s_ref_.a_prime);
            % map to [0; 2*pi]
            angle(angle < 0) = angle(angle < 0) + 2 * pi;
            angle(angle >= 2 * pi) = angle(angle >= 2 * pi) - 2 * pi;
            % compute bins for each of the 99
            nbins = 16;
            bin = 1 + floor(angle * nbins / (2*pi));
            if max(bin) > nbins || min(bin) < 1
                error('max(bin) > %s || min(bin) < 1: this cannot happen',nbins);
            end
            % compute mean values for each bin
            rv.J_prime = nan(1,nbins);
            rv.a_prime = nan(1,nbins);
            rv.b_prime = nan(1,nbins);
            rv.h = angle;
            rv.bin = bin;
            for i =1:nbins
                rv.J_prime(i) = mean(Jab.J_prime(bin == i));
                rv.a_prime(i) = mean(Jab.a_prime(bin == i));
                rv.b_prime(i) = mean(Jab.b_prime(bin == i));
            end
        end

    end


end