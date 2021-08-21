function ExampleXYZ_from_xyY()
    xyY = struct('x',0.2,'y',0.3,'Y',3);
    XYZ = XYZ_from_xyY(xyY.x, xyY.y, xyY.Y);
    disp(XYZ);
end