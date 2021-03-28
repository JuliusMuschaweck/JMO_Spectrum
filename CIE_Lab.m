function rv = CIE_Lab(XYZ, XYZn)
    fX = f( XYZ.X /XYZn.X );
    fY = f( XYZ.Y /XYZn.Y );
    fZ = f( XYZ.Z /XYZn.Z );
    rv.L = 116 * fY - 16;
    rv.a = 500 * (fX - fY);
    rv.b = 200 * (fY - fZ);
end

function rv = f(rhs)
    if rhs > (24/116)^3
        rv = rhs^(1/3);
    else
        rv = 841 / 108 * rhs + 16 / 116;
    end
end