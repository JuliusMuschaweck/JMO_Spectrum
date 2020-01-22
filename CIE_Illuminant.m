function rv = CIE_Illuminant(name,varargin)
% Compute CIE standard illuminant D for color temperature CCT, for 360:830 nm. Optional 'lam',lam 
% Available names:
% 'A';'D65';'C';'E','D50';'D55';'D75';'FL1';'FL2';'FL3';'FL4';'FL5';'FL6';'FL7';'FL8';'FL9';'FL10';'FL11';'FL12';
% 'FL3_1';'FL3_2';'FL3_3';'FL3_4';'FL3_5';'FL3_6';'FL3_7';'FL3_8';'FL3_9';'FL3_10';'FL3_11';'FL3_12';'FL3_13';'FL3_14';'FL3_15';
% 'HP1';'HP2';'HP3';'HP4';'HP5'}
    p = inputParser;
    p.addRequired('name');
    p.addParameter('lam',360:830);
    parse(p, name, varargin{:});
    lam = p.Results.lam;
    persistent CIE_Standard;
    if isempty(CIE_Standard)
        tmp = load('CIE_Standard_Illuminants.mat','CIE_Standard');
        CIE_Standard = tmp.CIE_Standard;
    end
    if isfield(CIE_Standard, name)
        s = CIE_Standard.(name);
        s.name = sprintf('CIE standard illuminant %s',name);
    elseif strcmp(name,'E')
        s = MakeSpectrum(lam,ones(size(lam)));
        s.name = 'CIE standard illuminant E';
        return;
    else
        error('CIE_Illuminant: unknown illuminant name: %s',name);
    end
    rv.lam = lam;
    rv.val = LinInterpol(s.lam, s.val, lam);
    rv.name = s.name;
end