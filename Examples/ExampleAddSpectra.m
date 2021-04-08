function ExampleAddSpectra()
    s1 = MakeSpectrum([400,500,600],[1, 2, 4]);
    s2 = MakeSpectrum([400,560,610],[4, 4, 1]);
    sumspec = AddSpectra(s1,s2);
    figure();
    clf;
    hold on;
    plot(s1.lam, s1.val,'Marker','x');
    plot(s2.lam, s2.val,'Marker','x');
    plot(sumspec.lam, sumspec.val,'Marker','x');
    legend({'s1','s2','sumspec'},'Location','NorthWest');
    axis([390 610 0 8]);
    grid on;
    xlabel('lam');
    ylabel('val');
    title('AddSpectra demo');
end