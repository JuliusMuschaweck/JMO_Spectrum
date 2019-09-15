function rv = PlanckSpectrum(lam_vec, T, varargin)
% function rv = PlanckSpectrum(lam_vec, T, varargin)
%% Output: spectrum with .lam == lam_vec, .val spectral values for blackbody 
%   spectrum 
%  .name an appropriate name, and .XYZ if lam_vec is in nm units
%% Input: lam_vec vector of reals, T scalar real in K. 
%   T may be inf, then returns lam_vec^(-4), scaled to 'localpeak1'
%   Options: 
%   'normalize' -> string, default 'globalpeak1'
%       'globalpeak1': scaled such that global peak would be 1.0 even if
%           outside lambda range
%       'localpeak1': scaled such that the peak value of any lam_vec is
%           1.0, Note: Not exactly identical if global peak is in range, due to
%           discretization
%       'localflux1: scaled such that integral over lambda range is 1.0
%       'radiance': scaled such rv is blackbody spectral radiance, W/(wlu m²sr)
%       'exitance': scaled such that rv is blackbody spectral exitance, W/(wlu m²)
%           wlu is wavelengthUnit, see below
%   'wavelengthUnit' -> real, default 1e-9 (nanometers)
%       1e-9 : lam_vec given in nm, returned spectrum is W / (nm m² sr) or W / (nm m²)
%               rv.XYZ will be CIE XYZ values X, Y, Z, x, y
%       1e-6: lam_vec given in µm, returned spectrum is W / (µm m² sr) or W / (µm m²)
%       1  : lam_vec given in m, returned spectrum is W / (m m² sr) or W / (m m²)
    p = inputParser;
    addRequired(p,'lam_vec',@(x) isreal(x) && isvector(x));
    addRequired(p,'T',@(x) isreal(x) && isscalar(x) && x>0);
    addParameter(p,'normalize','globalpeak1',@normalize_validate);
    addParameter(p,'wavelengthUnit', 1e-9, @(x) isreal(x) && isscalar(x) && x>0);
    parse(p,lam_vec,T,varargin{:});
    
    normalize = p.Results.normalize;
    wlu = p.Results.wavelengthUnit;
    % B(lam,T) = c1L lam^(-5) / (exp(c2/(lam T)) - 1)
    % c1L = 2 h c^2
    % c2 = h c / kB
    
    CODATA = CODATA2018();
    b = CODATA.b.value;
    c1L = CODATA.c1L.value;
    c2 = CODATA.c2.value;

    rv.lam = lam_vec(:);
    lam_m = lam_vec(:) * wlu;
    if T == inf
        B = lam_m .^ (-4);
        normalize = 'localpeak1';
    else
        B = c1L * (lam_m .^(-5)) ./ ( exp((c2/T) ./lam_m) -1);
    end
    
    if strcmp(normalize,'globalpeak1')
        lpeak_m = b / T;
        Bpeak = c1L * (lpeak_m ^(-5)) / ( exp((c2/T) /lpeak_m) -1);
        rv.val = B / Bpeak;
        rv.name = ['Planck blackbody spectrum for T = ',num2str(T),' K, normalized to global peak = 1'];
    elseif strcmp(normalize,'localpeak1')
        rv.val = B / max(B);
        rv.name = ['Planck blackbody spectrum for T = ',num2str(T),' K, normalized to peak = 1 within wavelength range'];
    elseif strcmp(normalize,'localflux1')
        flux = trapz(lam_vec,B);
        rv.val = B / flux;
        rv.name = ['Planck blackbody spectrum for T = ',num2str(T),' K, normalized to flux = 1 within wavelength range'];
    elseif strcmp(normalize,'radiance')
        rv.val = B * wlu;
        rv.name = ['Planck blackbody spectral radiance for T = ',num2str(T),' K, in W / (',wluName(wlu),' m^2 sr)'];
    elseif strcmp(normalize,'exitance')
        rv.val = B * wlu * pi;
        rv.name = ['Planck blackbody spectral radiant exitance for T = ',num2str(T),' K, in W / (',wluName(wlu),' m^2)'];
    else 
        error('PlanckSpectrum: this cannot happen');
    end
    
    if wlu == 1e-9
        rv.XYZ = CIE1931_XYZ(rv);
    end
end

function rv = normalize_validate(s)
    rv = ischar(s);
    if ~rv
        return;
    end
    ok = sum(strcmp(s,{'globalpeak1','localpeak1','localflux1','radiance','exitance'})) > 0;
    rv = rv && ok;
end

function rv = wluName(wlu)
    if wlu == 1
        rv = 'm';
    elseif wlu == 1e-6
        rv = 'micron';
    elseif wlu  == 1e-9
        rv = 'nm';
    else 
        rv = [num2str(wlu),'m'];
    end
end

