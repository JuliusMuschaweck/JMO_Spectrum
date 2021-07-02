function ExampleLDomPurity()
    red = GaussSpectrum(360:830, 620, 20);
    [ldomRed, purityRed] = LDomPurity(red);
    green = GaussSpectrum(360:830, 510, 20);
    [ldomGreen, purityGreen] = LDomPurity(green);
    fprintf('ldom = %g, purity = %g for red\n',ldomRed, purityRed);
    fprintf('ldom = %g, purity = %g for green\n',ldomGreen, purityGreen);
    PlotCIExyBorder();
    hold on;
    scatter(1/3,1/3,'xk');
    xyRed = CIE1931_XYZ(red);
    xyGreen = CIE1931_XYZ(green);
    scatter(xyRed.x, xyRed.y,'or');
    scatter(xyGreen.x, xyGreen.y,'xg');
    % compute directly from xy vector
    [ldomMagenta, purityMagenta] = LDomPurity([0.4, 0.15]);
    % or compute from xy struct
    magenta_xy.x = 0.4;
    magenta_xy.y = 0.15;
    [ldomMagenta, purityMagenta] = LDomPurity(magenta_xy);
    scatter(magenta_xy.x, magenta_xy.y,'xm');
    fprintf('ldom = %g, purity = %g for magenta\n',ldomMagenta, purityMagenta);
end