function ExampleCIE_upvp()
    s = PlanckSpectrum(400:700,3200);
    XYZ = CIE1931_XYZ(s);
    x = XYZ.x;
    y = XYZ.y;
    xy = [x,y];
    xy2 = xy';
    XYZ = CIE_upvp(XYZ)  % u, v, up, vp are added to XYZ
    % fprintf('u = %g, v = %g, up = %g, vp = %g\n',XYZ.u, XYZ.v, XYZ.up, XYZ.vp);
    res = CIE_upvp(xy);
    fprintf('u = %g, v = %g, up = %g, vp = %g\n',res.u, res.v, res.up, res.vp);
    res = CIE_upvp(xy2);
    fprintf('u = %g, v = %g, up = %g, vp = %g\n',res.u, res.v, res.up, res.vp);
    res = CIE_upvp(x, y);
    fprintf('u = %g, v = %g, up = %g, vp = %g\n',res.u, res.v, res.up, res.vp);
end

