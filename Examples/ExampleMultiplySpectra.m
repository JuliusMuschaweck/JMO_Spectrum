function ExampleMultiplySpectra()
    s1 = GaussSpectrum(400:500, 450,10);
    s2 = MakeSpectrum([430 470],[0 2]);
    prodspec = MultiplySpectra(s1, s2);
    figure();
    clf;
    hold on;
    plot(s1.lam, s1.val);
    plot(s2.lam, s2.val);
    plot(prodspec.lam, prodspec.val);
    legend({'s1','s2','prodspec = s1*s2'},'Location','northwest');
    
end