function ExampleCIE_Lab()
    white = CIE_Illuminant('D65');
    red = MultiplySpectra(white, GaussSpectrum(360:830, 620, 60));
    green = MultiplySpectra(white, GaussSpectrum(360:830, 505, 30));
    blue = MultiplySpectra(white, GaussSpectrum(360:830, 430, 60));
    
    white.XYZ = CIE1931_XYZ(white);
    red.XYZ = CIE1931_XYZ(red);
    green.XYZ = CIE1931_XYZ(green);
    blue.XYZ = CIE1931_XYZ(blue);

    show1 = @(name, Lab) fprintf('%s L = %g, a = %g, b = %g\n',name, Lab.L, Lab.a, Lab.b);
    XYZn = white.XYZ;
    show1('white', CIE_Lab(white.XYZ, XYZn));
    show1('red', CIE_Lab(red.XYZ, XYZn));
    show1('green', CIE_Lab(green.XYZ, XYZn));
    show1('blue', CIE_Lab(blue.XYZ, XYZn));
    
    figure();
    hold on;
    plot(white.lam, white.val,'k');
    plot(red.lam, red.val,'r');    
    plot(green.lam, green.val,'g');        
    plot(blue.lam, blue.val,'b');
    
    PlotCIExyBorder('ColorFill',true);
    title('');
    scatter(white.XYZ.x, white.XYZ.y,'kx');
    scatter(red.XYZ.x, red.XYZ.y,'kx');
    scatter(green.XYZ.x, green.XYZ.y,'kx');
    scatter(blue.XYZ.x, blue.XYZ.y,'kx');
end

