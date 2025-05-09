classdef SpectrumInterpolator
    properties (SetAccess = private)
        sp_     % cell array of spectra
        phi_    % array of powers
        F_      % cell array of cum funcs
        G_      % cell array of inverse cum funcs
    end
    methods
        function obj = SpectrumInterpolator(sp)
            % minval = 0.00001; % no zero spectrum values
            nSpectra = length(sp);
            for i = 1:nSpectra
                [ok, msg, obj.sp_{i}] = SpectrumSanityCheck(sp{i});
                if ~ok
                    error("SpectrumInterpolator: invalid spectrum #%g: %s",i,msg);
                end
                obj.phi_(i) = IntegrateSpectrum(obj.sp_{i});
                obj.F_{i} = SpectrumInterpolator.F(obj.sp_{i},obj.phi_(i));
                obj.G_{i} = SpectrumInterpolator.G(obj.F_{i}); 
            end
            tmp = obj.G_{1};  
            x = tmp.x;
            for i = 2:nSpectra
                tmp = obj.G_{i};
                x = cat(1,x,tmp.x);
            end
            x = unique(sort(x));
            clear tmp;
            for i = 1:nSpectra
                gg = obj.G_{i};
                tmp.x = x;
                tmp.lam = LinInterpol(gg.x, gg.lam, x);
                obj.G_{i} = tmp;
            end
        end

        function rv = Interpolate(obj, weights)
            arguments 
                obj
                weights (:,1) double
            end
            assert(length(weights) == length(obj.sp_), ...
                "SpectrumInterpolator:Interpolate: wrong # of weights");
            tmp = obj.G_{1};
            x = tmp.lam; 
            ipol_lam = tmp.val * weights(1);
            for i = 2:length(weights)
                tmp = obj.G_{i};
                ipol_lam = ipol_lam + tmp.val * weights(i);
            end

            for i = 1:length(weights)
                iG = obj.G_{i};
                isp = obj.sp_{i};
                ifi{i} = LinInterpol(isp.lam, isp.val, iG.val);
            end
            ff = weights(1) ./ ifi{1};
            for i = 2:length(weights)
                ff = ff + weights(i) ./ ifi{i};
            end
            my_f = 1./ff;
            my_scale = trapz(ipol_lam, my_f);
            my_phi = obj.phi_ * weights;

            tmpval = my_f / my_scale * my_phi;

            rv.lam = unique(ipol_lam);
            rv.val = LinInterpol(ipol_lam, tmpval, rv.lam);
        end

        function rv = Eval( obj, x, weights )
            arguments 
                obj
                x (1,1) double
                weights (:,1) double
            end
            assert(length(weights) == length(obj.sp_), ...
                "SpectrumInterpolator:Eval: wrong # of weights");
            % evaluate interpolated spectrum at x
            n = length(weights);
            gg = zeros(1, n);
            for i = 1:n
                iGG = obj.G_{i};
                gg(i) = interp1(iGG.x, iGG.lam, x);
            end
            rv = gg * weights;
        end


    end
    methods (Static)
        function rv = F(spec, phi)
            rv.lam = spec.lam;
            rv.val = cumtrapz(spec.lam, spec.val) / phi;
            rv.val(end) = 1; % 
        end

        function rv = G(rhs) % inverse of F
            rv.x = rhs.val;
            rv.lam = rhs.lam;
            % rv.lam(1) = eps; % hack to make it a valid "spectrum" with all lam > 0;
        end

    end
end