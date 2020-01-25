function rv = Vlambda()
    % return spectrum (fields lam and val) for Vlambda with lam == 360:830
    persistent iXYZ;
    if isempty(iXYZ)
        load('CIE1931_lam_x_y_z.mat','CIE1931XYZ');
        iXYZ = CIE1931XYZ;
    end
    rv.lam = iXYZ.lam;
    rv.val = iXYZ.y;
    rv.name = 'V(lambda)';
end