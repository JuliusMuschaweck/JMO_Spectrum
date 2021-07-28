%% CRI
%
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp;
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp;
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp;
% <a href="GroupedList.html"> Grouped list</a> &nbsp; | &nbsp; 
% Source code: <a href = "file:../CRI.m"> CRI.m</a>
% </p>
% </html>
%
% The CRI class provides what is needed to compute Color Rendering Indices
%% Syntax
% * Constructor: |rv = CRI()|
%% Properties
% * |CRISpectra_|: Read-only. Array of 16 structs with test sample properties. Each is a spectrum, with fields |lam == 360:830| 
% in 1 nm steps, |val| (the % sample's reflectivity), |name| (a name from |TCS01| to |TCS016|), |description| (a description 
% like |'Light greyish red'|), and |munsell| (the approximate Munsell code). 
% Elements 1..8 a are the 8 standard reflectivity spectra used for Ra. Elements 9..14 are the 6 additional spectra
% as defined in CIE 13.3-1995. In addition, #15 is (inofficial) "Japanese skin", and #16 is "Perfect white".
% * |strict_5nm_|: A logical scalar flag. When false (default), integration is done in 1 nm steps. When set to true,
% integration is done in 5 nm steps.
%% Methods
% * |function prev = SetStrict_5nm(this, yesno)|: Sets the |strict_5nm_| flag to |yesno| and returns its previous value.
% *Input argument*: |yesno|, logical scalar.
% *Output argument*: |prev|, logical scalar.
% * |function rv = SingleRi(this, spectrum, i)|: Computes the single color rendering index Ri for color sample |i|.
% *Input arguments*: |spectrum|: A valid spectrum, (see <SpectrumSanityCheck.html SpectrumSanityCheck>: the test lamp.
% |i|: Integer scalar, 1 <= i <= 16: The color sample.
% *Output argument*: |rv|, double scalar, the single color rendering index.
% * |function rv = MySingleR(this, testlamp_spectrum, reflectivity_spectrum)|: Computes the single color rendering index
% for a user defined color sample.
% *Input arguments*: |testlamp_spectrum|: A valid spectrum: the test lamp. |reflectivity_spectrum|: A valid spectrum, the sample
% reflectivitiy. Should be >= 0 and <= 1.
% *Output argument*: |rv|, double scalar, the single color rendering index.
% * |function [rv, Ri_1_8] = Ra(this, spectrum)|: Computes the first eight single CRI values, returns Ra as their
% arithmetic mean.
% *Input argument*: |spectrum|: A valid spectrum: the test lamp.
% *Output arguments*: |rv|: Double scalar: the Ra value. |Ri_1_8|: Double array, length 8: the first eight Ri values.
% * |function rv = FullCRI(this, spectrum)|: Computes all 16 Ri values.
% *Input argument*: |spectrum|: A valid spectrum: the test lamp.
% *Output argument*: |rv|, a struct with field |Ri|: double array, length 16, the single Ri values, and field |Ra|, the
% Ra value.
% * |function PlotCRISpectra(this, fh)|: Plots the 16 CRI spectra
% *Input argument*: |fh|: Optional figure handle. When present, clears the figure and plots the spectra there. When
% absent, creates a new figure for plotting.
% * |function [ok, rv_struct] = Test(this, doPrint)|: performs a test, comparing results to expected for a number of
% CIE standard illuminants.
%% Algorithm
% The constructor loads the CRI reflectivity spectra from |CRISpectra.mat|, and interpolates them to |360:830| to speed
% up the color matching integrals. The individual CRI calculations follow the prescription in CIE 13.3-1995. As a
% default, all integrals are executed over wavelengths "interweaving" 360:830 with the actual test lamp spectrum. When
% the |strict_5nm| flag is set to true, all spectra are interpolated to 360:5:830 before integration.
%% See also
% <CIE_Illuminant_D.html CIE_Illuminant_D>, <PlanckSpectrum.html PlanckSpectrum>
%% Usage Example
% <include>Examples/ExampleCRI.m</include>

% publish with publishWithStandardExample('filename.m') in PublishDocumentation.m

% JMO Spectrum Library, 2021. See https://github.com/JuliusMuschaweck/JMO_Spectrum
% I dedicate the JMO_Spectrum library to the public domain under Creative Commons Zero
% (https://creativecommons.org/publicdomain/zero/1.0/legalcode)
%
classdef CRI < handle
    % Compute color rendering index, CIE 13.3-1995 including R15
    properties (GetAccess = public, SetAccess = private)
        % Array of 16 structs containing LED spectra
        %
        % Each struct has fields 'name', 'description', 'munsell', 'lam' and 'val'
        % 1..8 and 9..14 are the standard CRI spectra. #15 is Japanese skin, #16 is perfect white
        % File CRISpectra.mat must be present, this is from where this property is read at construction
        CRISpectra_
        strict_5nm_
    end
    methods
        function this = CRI()
            % Constructor, reads the CRI spectra from CRISpectra.mat
            tmp = load('CRISpectra.mat','CRISpectra');
            s = tmp.CRISpectra;
            lam = s(1).lam;
            for i = 1:length(s)
                s(i).lam = 360:830;
                s(i).val = LinInterpol(lam, s(i).val, s(i).lam);
            end
            this.CRISpectra_ = s;
            this.strict_5nm_ = false;
        end
        
        function prev = SetStrict_5nm(this, yesno)
            prev = this.strict_5nm_;
            this.strict_5nm_ = yesno;
        end
        
        function rv = SingleRi(this, spectrum, i)
            lamp = this.PrepareLamp(spectrum);
            rv = this.SingleRi_1nm(lamp, this.CRISpectra_(i));
        end
        
        function rv = MySingleR(this, testlamp_spectrum, reflectivity_spectrum)
            lamp = this.PrepareLamp(testlamp_spectrum);
            rr = ResampleSpectrum(reflectivity_spectrum, this.CRISpectra_(1).lam);
            rv = this.SingleRi_1nm(lamp, rr);
        end
        
        function [rv, Ri_1_8] = Ra(this, spectrum)
            lamp = this.PrepareLamp(spectrum);
            for i = 1:8
                Ri_1_8(i) = this.SingleRi_1nm(lamp, this.CRISpectra_(i));
            end
            rv = mean(Ri_1_8);
        end
        
        function rv = FullCRI(this, spectrum)
            lamp = this.PrepareLamp(spectrum);
            for i = 1:16
                si = this.CRISpectra_(i);
                rv.Ri(i,1) = this.SingleRi_1nm(lamp, si);
            end
            rv.Ra = mean(rv.Ri(1:8));
        end
        
        function PlotCRISpectra(this, fh)
            if nargin == 1
                fh = figure();
            end
            clf(fh);
            hold on;
            ax = fh.CurrentAxes;
            for i=1:16
                plot(ax, this.CRISpectra_(i).lam, this.CRISpectra_(i).val);
                descriptors{i} = this.CRISpectra_(i).description;
            end
            legend(ax,descriptors,'Location','NorthEastOutside');
            title(ax,'CRI 13.3-1995 reflectivity spectra');
            xlabel(ax,'\lambda (nm)');
            ylabel(ax,'reflectivity');
            axis(ax,[350,850,-0.05,1.05]);
            grid(ax,'on');
        end
        
        function [ok, rv_struct] = Test(this, doPrint)
            if nargin == 1
                doPrint = true;
            end
            prev = this.SetStrict_5nm(false);
            rv_struct = {};
            ok = logical([]);
            rv_struct{end+1} = iTestR1_14(CIE_Illuminant_D(6500), 'D(6500)', 100 * ones(14,1),0.05);
            ok(end+1) = rv_struct{end}.ok;
            rv_struct{end+1} = iTestR1_14(PlanckSpectrum(360:830,4000), 'Planck(4000)', 100 * ones(14,1),0.01);
            ok(end+1) = rv_struct{end}.ok;
            CIE_FL_targets = [76, 64, 57, 51, 72, 59, 90, 96, 90, 81, 83, 83];
            for i = 1:length(CIE_FL_targets)
                sn = sprintf('FL%i',i);
                res = iTestRa(CIE_Illuminant(sn), sn, CIE_FL_targets(i), 1);
                rv_struct{end+1} = res;
                ok(end+1) = rv_struct{end}.ok;
            end
%             CIE_FL_3_targets = ...  % row index = Ri, col index = FL_3_j
%                 [42,65,	64,	91,	99,	97,	97,	95,	94,	99,	90,	95,	98,	93,	99;...
%                 69,	80,	80,	89,	98,	97,	94,	90,	89,	97,	86,	98,	97,	94,	99;...
%                 89,	89,	89,	79,	92,	93,	54,	50,	48,	63,	49,	92,	98,	97,	96;...
%                 38,	65,	68,	88,	96,	97,	88,	85,	84,	92,	82,	95,	97,	94,	98;...
%                 40,	66,	69,	87,	98,	96,	86,	83,	84,	92,	81,	94,	99,	94,	99;...
%                 52,	71,	74,	81,	96,	95,	81,	72,	72,	85,	70,	97,	97,	93,	100;...
%                 66,	79,	81,	88,	96,	97,	87,	86,	85,	92,	85,	93,	94,	97,	98;...
%                 13,	48,	49,	89,	96,	97,	63,	79,	78,	86,	79,	83,	88,	97,	98;...
%                 -110,-38,-63,76,95,	94,	-9,	24, 22,	46,	24,	58,	71,	93,	96;...
%                 28,	51,	51,	69,	91,	90,	51,	42,	38,	62,	34,	88,	99,	91,	99;...
%                 19,	56,	62,	88,	96,	95,	76,	70,	68,	78,	64,	93,	94,	95,	100;...
%                 21,	59,	67,	62,	94,	93,	49,	48,	51,	72,	50,	85,	89,	85,	95;...
%                 47,	68,	68,	91,	99,	97,	97,	96,	95,	97,	90,	97,	99,	92,	98;...
%                 93,	93,	93,	87,	95,	95,	68,	67,	66,	75,	67,	94,	98,	97,	98];
            % now directly from CIE 015:2018
            CIE_FL_3_targets = ...  % row index = Ri, col index = FL_3_j 
                [42	65	64	91	99	97	97	95	94	99	90	95	98	93	99	;...
                69	80	80	89	98	97	94	90	89	96	86	98	97	94	99	;...
                89	89	89	79	92	93	54	50	48	63	49	92	98	97	96	;...
                38	65	68	88	96	97	88	87	85	92	82	95	97	94	98	;...
                40	66	69	87	98	96	86	84	83	92	81	94	99	94	99	;...
                52	71	74	81	96	95	81	74	72	85	69	97	97	93	100	;...
                66	79	81	88	96	97	87	87	86	92	84	92	93	97	98	;...
                13	48	49	89	96	97	63	76	79	86	79	82	88	97	98	;...
                -110,-38,-63,76,95,	94,	-9,	14,	24,	45,	24,	57,	71,	93,	96	;...
                28	51	51	69	91	90	51	42	38	62	34	88	99	92	99	;...
                19	56	62	88	96	95	76	70	67	78	64	93	94	95	99	;...
                21	59	67	62	94	93	49	48	48	72	50	85	89	85	95	;...
                47	68	68	91	99	97	97	96	94	97	90	97	99	92	98	;...
                93	93	93	87	95	95	68	67	66	75	67	94	98	97	97	];
            
            
            for i = 1:15
                sn = sprintf('FL3_%i',i);
                res = iTestR1_14(CIE_Illuminant(sn), sn, CIE_FL_3_targets(:,i), 1);
                rv_struct{end+1} = res;
                ok(end+1) = rv_struct{end}.ok;
            end
            
            this.SetStrict_5nm(prev);
            
            function rv = iTestRa(s, name, target, tol)
                actual = this.Ra(s);
                rv.name = name;
                rv.actual = actual;
                rv.target = target;
                rv.delta = rv.actual - rv.target;
                rv.ok = abs(rv.delta) <= tol;
                if doPrint
                    fprintf('iTestRa: ok = %s, target/actual = %g/%g, delta = %g, name = %s\n',string(~~(rv.ok)), rv.target, rv.actual, rv.delta, rv.name);
                end
            end
            function rv = iTestR1_14(s, name, target, tol)
                tmp = this.FullCRI(s);
                actual = tmp.Ri(1:14);
                rv.name = name;
                rv.actual = actual;
                rv.target = target(:);
                rv.delta = rv.actual - rv.target;
                rv.oki = abs(rv.delta) <= tol;
                rv.ok = all(rv.oki);
                if doPrint
                    for ii = 1:14
                        fprintf('iTestR%i: ok = %s, target/actual = %g/%g, delta = %g, name = %s\n', ...
                            int64(ii), string(~~(rv.oki(ii))), rv.target(ii), rv.actual(ii), rv.delta(ii), rv.name);
                    end
                end
            end
        end
    end
    
    methods (Access = private)
        function rv = PrepareLamp(this, lamp_spectrum)
            % Precompute struct with lamp spectrum, CCT, ref spectrum, warnings, c/d
            %
            % Executes steps 5.2, 5.3, c/d values for step 5.7, scaling to Y=100 for step 5.8
            % Parameters:
            %   lamp_spectrum: @type spectrum test lamp spectrum with fields lam and val
            %
            % Return values:
            %   @type struct Struct with fields:
            %       * s_k: same shape as input, but with lam = 360:830, and val scaled such
            %         that tristimulus Y = 100
            %       * CCT: Correlated color temperature
            %       * dist_uv: Distance of lamp_spectrum to Planck
            %       * delta_uv: Distance between test and reference lamps
            %       * s_r: reference spectrum, lam = 360:830, val scaled to Y = 100
            %       * s_r and s_k both have fields X, Y, Z, x, y, z, u, v
            %       * cd_k: struct with fields c, d, values of test lamp for step 5.7
            %       * cd_r: dito for reference lamp
            %       * warnings: cell array of possible warnings, e.g. if too far from Planck
            
            % prepare test lamp spectrum with lam = 360..830
            s_k = lamp_spectrum; % copy all other fields
            if this.strict_5nm_ == true
                s_k.lam = 360:5:830;
            else
                s_k.lam = sort(unique(vertcat((360:830)',s_k.lam(:))));
            end
            s_k.val = LinInterpol(lamp_spectrum.lam, lamp_spectrum.val, s_k.lam);
            % compute test lamp XYZ color and CCT, scale to Y = 100
            tmp = CIE1931_XYZ(s_k);
            s_k.val = s_k.val * 100 / tmp.Y;
            XYZ_k = CIE1931_XYZ(s_k);
            [CCT, dist_uv, ok, errmsg] = CCT_from_xy(XYZ_k.x, XYZ_k.y);
            if ~ok && contains(errmsg, 'error')
                error('CRI.PrepareLamp: Cannot compute CCT: %s',errmsg);
            end
            warnings = {};
            if dist_uv >= 0.05
                warnings{end+1}=sprintf('test lamp too far from Planck to compute CCT properly, dist_uv = %g, >= 0.05',dist_uv);
            end
            % generate reference spectrum
            if CCT < 5000 % Planck
                s_r = PlanckSpectrum(s_k.lam,CCT);
            else % CIE D
                s_r = CIE_Illuminant_D(CCT,'lam',s_k.lam);
            end
            % compute remaining color coordinates of test and reference lamps
            tmp = CIE1931_XYZ(s_r);
            s_r.val = s_r.val * 100 / tmp.Y;
            XYZ_r = CIE1931_XYZ(s_r);
            uv_k = this.uv(XYZ_k);
            uv_r = this.uv(XYZ_r);
            cd_k = this.cd(uv_k);
            cd_r = this.cd(uv_r);
            % test for setion 5.3 warning
            delta_uv = sqrt((uv_k.u-uv_r.u)^2 + (uv_k.v - uv_r.v)^2);
            if delta_uv >= 5.4e-3
                warnings{end+1} = sprintf('test lamp and reference spectra are too different, DC = delta_uv = %g',delta_uv);
            end
            % assemble return value
            rv.s_k = GenSpectrumStruct(s_k, XYZ_k, uv_k);
            rv.s_r = GenSpectrumStruct(s_r, XYZ_r, uv_r);
            rv.CCT = CCT;
            rv.dist_uv = dist_uv;
            rv.delta_uv = delta_uv;
            rv.cd_k = cd_k;
            rv.cd_r = cd_r;
            function irv = GenSpectrumStruct(s, XYZ, uv)
                % s_r and s_k both have fields X, Y, Z, x, y, z, u, v
                irv = s;
                irv.x = XYZ.x; irv.y = XYZ.y; irv.z = XYZ.z;
                irv.X = XYZ.X; irv.Y = XYZ.Y; irv.Z = XYZ.Z;
                irv.u = uv.u; irv.v = uv.v;
            end
        end
        
        function rv = SingleRi_1nm(this, lamp_ref, sample_spectrum)
            % Compute a single Ri value for precomputed lamp lamp_ref and sample reflectivity spectrum
            
            % all test lamp items have index _k, all reference items have _r like in the standard
            s_k = lamp_ref.s_k;
            s_r = lamp_ref.s_r;
            % 5.5 compute both XYZ
            if this.strict_5nm_==true
                tmp.lam = 360:5:830;
                tmp.val = LinInterpol(sample_spectrum.lam, sample_spectrum.val, tmp.lam);
                sample_spectrum = tmp;
            end
            XYZ_ki = CIE1931_XYZ(MultiplySpectra(s_k, sample_spectrum));
            XYZ_ri = CIE1931_XYZ(MultiplySpectra(s_r, sample_spectrum));
            % 5.6 transform to uv
            uv_ki = this.uv(XYZ_ki);
            uv_ri = this.uv(XYZ_ri);
            % 5.7 apply adaptive color shift for test lamp
            uvprime_ki = this.ColorShift(uv_ki,lamp_ref);
            % 5.8 transform to 1964 U*V*W*
            UVW_ri = UVW(XYZ_ri.Y, uv_ri);
            UVW_ki = UVW(XYZ_ki.Y, uvprime_ki);
            % 5.9 compute Delta U*V*W*
            Delta_Ei = sqrt((UVW_ri.U - UVW_ki.U)^2 + (UVW_ri.V - UVW_ki.V)^2 + (UVW_ri.W - UVW_ki.W)^2);
            % 6.2 compute R_i
            R_i = 100 - 4.6 * Delta_Ei;
            %
            rv = R_i;
            function rv = UVW( Y, uv)
                rv.W = 25 * Y^(1/3) - 17;
                rv.U = 13 * rv.W * (uv.u - lamp_ref.s_r.u);
                rv.V = 13 * rv.W * (uv.v - lamp_ref.s_r.v);
            end
        end
        function irv = ColorShift(this,uv_k,lamp_ref)
            cd_k = this.cd(uv_k);
            c = cd_k.c * lamp_ref.cd_r.c / lamp_ref.cd_k.c;
            d = cd_k.d * lamp_ref.cd_r.d / lamp_ref.cd_k.d;
            den = (16.518 + 1.481*c - d);
            irv.u = (10.872 + 0.404*c - 4*d) / den;
            irv.v = 5.520 / den;
        end
        function rv = uv(~,XYZ)
            den = - 2 * XYZ.x + 12 * XYZ.y + 3;
            rv.u = 4 * XYZ.x / den;
            rv.v = 6 * XYZ.y / den;
        end
        function rv_ = cd(~,uv) % step 5.7
            rv_.c = (4 - uv.u - 10*uv.v) / uv.v;
            rv_.d = (1.708*uv.v + 0.404 - 1.481*uv.u) / uv.v;
        end
        
    end
    
end