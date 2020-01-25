function [iCCT, dist_uv, ok, errmsg] = CCT(spectrum)
% computes CCT in the range of 1000K to 1000.000K with extreme precision
% dist_uv is the distance to the Planck locus in uv coordinates, should be
% less than 0.05 for valid CCT.
    if ~isfield(spectrum,'XYZ')
        XYZ = CIE1931_XYZ(spectrum);
    else
        XYZ = spectrum.XYZ;
    end
    [iCCT, dist_uv, ok, errmsg] = CCT_from_xy(XYZ.x, XYZ.y);
end

