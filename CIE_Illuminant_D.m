function rv = CIE_Illuminant_D(CCT,varargin)
% Compute CIE standard illuminant D for color temperature CCT, for 360:830 nm. Optional 'lam',lam 
    if CCT < 4000 || CCT > 25000
        error('CIE_Illuminant_D: CCT = %g out of range (4000..25000K)',CCT);
    end
    p = inputParser;
    p.addRequired('CCT');
    p.addParameter('lam',360:830);
    parse(p, CCT, varargin{:});
    lam = p.Results.lam;
    persistent CIE_Standard;
    if isempty(CIE_Standard)
        tmp = load('CIE_Standard_Illuminants.mat','CIE_Standard');
        CIE_Standard = tmp.CIE_Standard;
    end
    % formulas from https://en.wikipedia.org/wiki/Standard_illuminant#Illuminant_series_D
    iT = 1000 / CCT;
    if CCT > 7000
        xD = 0.237040 + 0.24748 * iT + 1.9018 * iT^2 - 2.0064 * iT^3;
    else % CCT in 4000;7000
        xD = 0.244063 + 0.09911 * iT + 2.9678 * iT^2 - 4.6070 * iT^3;
    end
    yD = - 3 * xD^2 + 2.870 * xD - 0.275;
    M = 0.0241 + 0.2562 * xD - 0.7341 * yD;
    M1 =(-1.3515 - 1.7703 * xD + 5.9114 * yD) / M;
    M2 = (0.03000 - 31.4424 * xD + 30.0717 * yD) / M;
    ilam = CIE_Standard.DaylightComponents.lam;
    S0 =  CIE_Standard.DaylightComponents.S0;
    S1 =  CIE_Standard.DaylightComponents.S1;
    S2 =  CIE_Standard.DaylightComponents.S2;
    SD = S0 + M1 * S1 + M2 * S2;
    rv.lam = lam;
    rv.val = LinInterpol(ilam, SD, lam);
    rv.name = sprintf('CIE standard illuminant D for CCT = %g',CCT);        
end