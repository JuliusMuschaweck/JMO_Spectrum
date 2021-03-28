function dE = CIEDE2000_XYZ( XYZ1, XYZ2, XYZn )
    dE = CIEDE2000_Lab(CIE_Lab(XYZ1, XYZn), CIE_Lab(XYZ2, XYZn));
end
