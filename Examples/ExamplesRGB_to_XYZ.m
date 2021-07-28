function ExamplesRGB_to_XYZ()
    % the standard sRGB display white point: D65
    d65_XYZ = CIE1931_XYZ( CIE_Illuminant('D65') );
    % now compare to RGB = (1,1,1)
    test = sRGB_to_XYZ(1, 1, 1);
    fprintf('expected white point x,y,Y = (%g, %g, %g), got (%g, %g, %g)\n',...
        d65_XYZ.x, d65_XYZ.y, 1.000,  test.x, test.y, test.Y);
    
    % test brightness and color of "perceived 50% gray": same color, but only 21% luminance
    half = 0.5;
    y_gray = ((200 * half + 11) / 211) .^ 2.4; % the standard sRGB gamma 
    testgray = sRGB_to_XYZ(half, half, half);
    fprintf('expected gray point x,y,Y = (%g, %g, %g), got (%g, %g, %g)\n',...
        d65_XYZ.x, d65_XYZ.y, y_gray,  testgray.x, testgray.y, testgray.Y);
    
    % test red sRGB primary
    sRGB_XYZ_R = [0.4124, 0.2126, 0.0193]; %from the standard
    testR = sRGB_to_XYZ(1,0,0);
    fprintf('red primary: expected (%g, %g, %g), got (%g, %g, %g)\n',...
        sRGB_XYZ_R(1), sRGB_XYZ_R(2), sRGB_XYZ_R(3), testR.X, testR.Y, testR.Z); 
end