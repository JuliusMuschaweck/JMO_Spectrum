function rv = CIE_Luv(XYZ, XYZn)
    fY = f( XYZ.Y /XYZn.Y );
    XYZ.cw = XYZ.X + XYZ.Y + XYZ.Z;
    XYZ.x = XYZ.X / XYZ.cw;
    XYZ.y = XYZ.Y / XYZ.cw;
    XYZ = CIE_upvp(XYZ);
    XYZn.cw = XYZn.X + XYZn.Y + XYZn.Z;
    XYZn.x = XYZn.X / XYZn.cw;
    XYZn.y = XYZn.Y / XYZn.cw;
    XYZn = CIE_upvp(XYZn);
    
    rv.L = 116 * fY - 16;
    rv.u = 13 * rv.L * (XYZ.up - XYZn.up);
    rv.v = 13 * rv.L * (XYZ.vp - XYZn.vp);
end

function rv = f(rhs)
    if rhs > (24/116)^3
        rv = rhs^(1/3);
    else
        rv = 841 / 108 * rhs + 16 / 116;
    end
end