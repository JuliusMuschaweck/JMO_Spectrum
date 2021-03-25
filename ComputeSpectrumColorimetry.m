function rv = ComputeSpectrumColorimetry(spec, varargin)
    % For input spectrum s, compute colorimetry information, return same spectrum with added fields
    % Parameters:
    %   s: spectrum, struct with fields lam and val
    %   varargin: Name/Value pair
    %       'Normalize', 'peak' | 'off' (default) 
    % Normalize -> 'peak' scales spectrum .val to have peak = 1
    % Normalize -> 'off' leaves .val unchanged
    % Computed and added fields are:
    %   XYZ: struct with fields x, y, z, X, Y, Z as returned from CIE1931_XYZ(s)
    %   CCT, dist_uv_Planck: color temperature and distance to Planck locus
    %   CRI_all: struct with all 16 Ri and Ra
    %   Ra: number, general CRI value
    %   Ldom: Dominant wavelength
    %   purity: purity
    persistent cri
    if isempty(cri)
        cri = CRI();
    end
    p = inputParser;
    p.addRequired('s');
    validateNormalize = @(str) strcmp(str,'peak') || strcmp(str,'off');
    p.addParameter('Normalize','off',validateNormalize);
    parse(p, spec, varargin{:});
    rv = p.Results.s;
    if strcmp(p.Results.Normalize,'peak')
        rv.val = rv.val / max(rv.val); % normalize to max = 1;
    end
    rv.XYZ = CIE1931_XYZ(rv);
    [rv.CCT, rv.dist_uv_Planck, ok, ~] = CCT_from_xy(rv.XYZ.x, rv.XYZ.y);
    if ok
        rv.CRI_all = cri.FullCRI(rv);
        rv.Ra = rv.CRI_all.Ra;
    else
        rv.Ra = NaN;
        rv.CRI_all.Ra = NaN;
        rv.CRI_all.Ri = NaN(16,1);
    end
    [rv.Ldom, rv.purity] = LDomPurity(rv.XYZ);
end