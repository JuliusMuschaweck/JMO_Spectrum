
function rv = CIE1931_XYZ(spec)
% function rv = CIE1931_XYZ(spec)
% compute CIE 1931 XYZ tristimulus and xy coords from spec.lam, spec.val
% spec is struct with spec.lam and spec.val arrays
% rv is struct with tristimulus values rv.X, rv.Y, rv.Z, and color coordinates rv.x and rv.y
% also returns rv.z = 1 - rv.x-rv.y
    persistent iXYZ;
    if isempty(iXYZ)
        load('CIE1931_lam_x_y_z.mat','CIE1931XYZ');
        iXYZ = CIE1931XYZ;
    end
    if (iXYZ.lam(2) - iXYZ.lam(1)) ~= 1
        error('CIE1931_XYZ: no unit spacing in CIE1931XYZ.lam');
    end
    if spec.lam(1) >= iXYZ.lam(end) || spec.lam(end) <= iXYZ.lam(1)
        % no overlap
        rv.X = 0;
        rv.Y = 0;
        rv.Z = 0;
        rv.x = NaN;
        rv.y = NaN;
        rv.z = NaN;
        return;
    end
    if numel(spec.lam) == 1
        rv.X = interp1(iXYZ.lam,iXYZ.x,spec.lam);
        rv.Y = interp1(iXYZ.lam,iXYZ.y,spec.lam);
        rv.Z = interp1(iXYZ.lam,iXYZ.z,spec.lam);
        rv.x = rv.X / (rv.X+rv.Y+rv.Z);
        rv.y = rv.Y / (rv.X+rv.Y+rv.Z);
        rv.z = 1 - rv.x - rv.y;
        return;
    end
    lam0 = floor(max(spec.lam(1), iXYZ.lam(1)));
    lam1 = ceil(min(spec.lam(end), iXYZ.lam(end)));
    ispecval = LinInterpol(spec.lam,spec.val,(lam0:lam1)');
    idxlam0 = lam0 - iXYZ.lam(1) + 1;
    idxlam1 = lam1 - iXYZ.lam(1) + 1;
    rv.X = trapz(ispecval .* iXYZ.x(idxlam0:idxlam1)); % ok since iXYZ.x,y,z have unit spacing
    rv.Y = trapz(ispecval .* iXYZ.y(idxlam0:idxlam1));
    rv.Z = trapz(ispecval .* iXYZ.z(idxlam0:idxlam1));
    rv.x = rv.X / (rv.X+rv.Y+rv.Z);
    rv.y = rv.Y / (rv.X+rv.Y+rv.Z);
    rv.z = 1 - rv.x - rv.y;
end