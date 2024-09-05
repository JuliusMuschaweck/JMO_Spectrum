function ExampleAddWeightedSpectra()
    %% add three gauss spectra with weights
    red = GaussSpectrum(linspace(550,700),620,15);
    green = GaussSpectrum(linspace(430,730),530,20);
    blue = GaussSpectrum(linspace(400,500),450,8);
    sumspec = AddWeightedSpectra([red, green, blue],[2, 5, 1.5]);
    figure(); clf; hold on;
    plot(red.lam, red.val,'r');
    plot(green.lam, green.val,'g');
    plot(blue.lam, blue.val,'b');
    plot(sumspec.lam, sumspec.val,'k');
    legend({'red','green','blue','sum spectrum'},'Location','NorthWest');
    grid on;
    xlabel('lam');
    ylabel('val');
    title('AddWeightedSpectra demo');
    %% demonstrate handling of discontinuties
    s1 = MakeSpectrum([400,500],[1,1]);
    s2 = MakeSpectrum([480,550],[1.2,1.2]);
    s3 = MakeSpectrum([530,600],[0.8,0.8]);
    s123 = AddWeightedSpectra([s1, s2, s3], [2,3,4]);
    figure(); clf; hold on;
    PlotSpectrum(s1);
    PlotSpectrum(s2);
    PlotSpectrum(s3);
    PlotSpectrum(s123);
    xlabel('lam');
    ylabel('val');
    title('AddWeightedSpectra demo: discontinuities');
    legend({"s1","s2","s3","weighted sum"});
    %% demonstrate non-overlap
    s1 = MakeSpectrum([400,500],[1,1]);
    s2 = MakeSpectrum([530,600],[0.8,0.8]);
    s12 = AddWeightedSpectra([s1, s2], [2,3]);
    figure(); clf; hold on;
    PlotSpectrum(s1);
    PlotSpectrum(s2);
    PlotSpectrum(s12);
    xlabel('lam');
    ylabel('val');
    title('AddWeightedSpectra demo: non-overlap');
    legend({"s1","s2","weighted sum"});
    % error('fff');
end