function ExamplePlotCIEupvpBorder()
    % bare minimal plot
    PlotCIEupvpBorder();
    % more complex example
    fh = figure();
    hold on;
    [ah, fh] = PlotCIEupvpBorder('Figure', fh, 'LineSpec','m','PlotOptions',{'LineWidth',1.5},'Ticks', [510 520 530], 'TickFontSize',10, 'ColorFill',true);
    green = ComputeSpectrumColorimetry(GaussSpectrum(450:600,520,30));
    % find the point on the monochromatic border corresponding to lDom
    load('CIE1931_lam_x_y_z.mat','CIE1931XYZ');
    xPure = LinInterpol(CIE1931XYZ.lam, CIE1931XYZ.xBorder, green.Ldom);
    yPure = LinInterpol(CIE1931XYZ.lam, CIE1931XYZ.yBorder, green.Ldom);
    % plot line from white point, to x/y of green, to border at green.lDom
    white = CIE_upvp(1/3, 1/3);
    pure = CIE_upvp(xPure, yPure);
    plot([white.up,green.up,pure.up], [white.vp,green.vp,pure.vp],'--bx');
    axis([-0.1 0.7 0 0.7]);
    % result looks as intended, but things like "axis equal", "grid on" etc. are missing when figure or axes are
    % specified
end