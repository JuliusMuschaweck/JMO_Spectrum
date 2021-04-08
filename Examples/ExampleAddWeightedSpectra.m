function ExampleAddWeightedSpectra()
    red = GaussSpectrum(linspace(550,700),620,15);
    green = GaussSpectrum(linspace(430,730),530,20);
    blue = GaussSpectrum(linspace(400,500),450,8);
    sumspec = AddWeightedSpectra([red, green, blue],[2, 5, 1.5]);
    clf;
    hold on;
    plot(red.lam, red.val,'r');
    plot(green.lam, green.val,'g');
    plot(blue.lam, blue.val,'b');
    plot(sumspec.lam, sumspec.val,'k');
    legend({'red','green','blue','sum spectrum'},'Location','NorthWest');
    grid on;
    xlabel('lam');
    ylabel('val');
    title('AddWeightedSpectra demo');
    error('fff');
end