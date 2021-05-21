function ExampleCIE_Luv()
    white = CIE_Illuminant('D65');
    red = MultiplySpectra(white, GaussSpectrum(360:830, 620, 60));
    green = MultiplySpectra(white, GaussSpectrum(360:830, 505, 30));
    blue = MultiplySpectra(white, GaussSpectrum(360:830, 430, 60));
    
    white.XYZ = CIE1931_XYZ(white);
    red.XYZ = CIE1931_XYZ(red);
    green.XYZ = CIE1931_XYZ(green);
    blue.XYZ = CIE1931_XYZ(blue);

    show1 = @(name, Luv) fprintf('%s L = %g, u = %g, v = %g\n',name, Luv.L, Luv.u, Luv.v);
    XYZn = white.XYZ;
    show1('white', CIE_Luv(white.XYZ, XYZn));
    show1('red', CIE_Luv(red.XYZ, XYZn));
    show1('green', CIE_Luv(green.XYZ, XYZn));
    show1('blue', CIE_Luv(blue.XYZ, XYZn));
    
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

