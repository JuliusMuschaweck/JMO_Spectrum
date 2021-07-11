function ExampleMatchWhiteLEDSpectrum()
    
    % source LED spectrum at 4003 K
    spec = ReadLightToolsSpectrumFile('LED_4003K.sre');
    spec.XYZ = CIE1931_XYZ(spec);
    
    matchOriginal = MatchWhiteLEDSpectrum(spec, spec.XYZ);
    delta = matchOriginal.spec.val - spec.val;
    test = max(abs(delta)) < 1e-14;
    fprintf('match original deviation : %g\n',max(abs(delta)));
    
    % prepare target at 4500K Planck
    xyt = PlanckLocus().xy_func(4500);
    xt = xyt(1);
    yt = xyt(2);
    Yt = spec.XYZ.Y * 1.2; % a little more flux
    XYZ_target = XYZ_from_xyY(xt, yt, Yt);
    
    
    match4500 = MatchWhiteLEDSpectrum(spec, XYZ_target);
    
    %%
    figure();
    clf;
    hold on;
    plot(spec.lam, spec.val,'k');
    plot(match4500.spec.lam, match4500.spec.val, ' m','LineWidth',2);
    plot(match4500.blue.lam, match4500.blue.val, '--b','LineWidth',2);
    plot(match4500.yellow.lam, match4500.yellow.val, '--','Color', [0, 0.7, 0],'LineWidth',2);
    xlabel('\lambda (nm)');
    legend({'original LED','target matched LED','blue part','yellow part'});
    title('Matching white LED spectrum to different white point');
    
    fh = figure();
    clf;
    PlotCIExyBorder('Figure',fh,'ColorFill', true);
    axis equal;
    axis([0 0.8 0 0.9]);
    hold on;
    scatter(spec.XYZ.x, spec.XYZ.y,'k');
    scatter(xt, yt,'x');
    scatter(matchOriginal.blue.XYZ.x, matchOriginal.blue.XYZ.y,'y');
    scatter(match4500.blue.XYZ.x, match4500.blue.XYZ.y,'xy');
    
    scatter(matchOriginal.yellow.XYZ.x, matchOriginal.yellow.XYZ.y,'b');
    scatter(match4500.yellow.XYZ.x, match4500.yellow.XYZ.y,'xb');
    
    plot([matchOriginal.blue.XYZ.x, matchOriginal.yellow.XYZ.x],[matchOriginal.blue.XYZ.y, matchOriginal.yellow.XYZ.y],'k');
    plot([match4500.blue.XYZ.x, match4500.yellow.XYZ.x],[match4500.blue.XYZ.y, match4500.yellow.XYZ.y],'k');
    xlabel('CIE x');
    ylabel('CIE y');
    title('Matching white LED to different white point');
    
end