function Example_XYZ_to_sRGB()
    % D65 should be RGB 1-1-1
    d65XYZ = CIE1931_XYZ(CIE_Illuminant('D65'));
    % d65XYZ.Y == 100 (approximately) by definition -> scale to 1.0000
    sRGB_d65 = XYZ_to_sRGB(d65XYZ.X/100, d65XYZ.Y/100, d65XYZ.Z/100); 
    fprintf('the following values should be all close to zero (differences between expected and actual RGB / XYZ values)\n');
    testdiff = sRGB_d65.RGB - [1,1,1]
    d65XYZ_2 = sRGB_to_XYZ(sRGB_d65.R,sRGB_d65.G,sRGB_d65.B);
    testdiff_2 = d65XYZ_2.XYZ - 0.01 * [d65XYZ.X, d65XYZ.Y, d65XYZ.Z]
    
    n = 10000;
    rng('default');
    rand_RGB = 3 * rand(n, 3) - 1;
    rand_XYZ = sRGB_to_XYZ(rand_RGB(:,1),rand_RGB(:,2),rand_RGB(:,3));
    rand_RGB_2 = XYZ_to_sRGB(rand_XYZ.X,rand_XYZ.Y, rand_XYZ.Z);
    testdiff_3 = rand_RGB - rand_RGB_2.RGB;
    fprintf('the max. error of converting %g random RGB triplets to XYZ and back is %g\n',n,max(abs(testdiff_3(:))));
end