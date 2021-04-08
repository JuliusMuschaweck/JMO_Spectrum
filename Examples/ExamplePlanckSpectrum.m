function ExamplePlanckSpectrum()
    T1 = 3200;
    T2 = 5600;
    lam = 400:700;
    s1 = PlanckSpectrum(lam, T1);
    s2 = PlanckSpectrum(lam, T2);
    sD = CIE_Illuminant_D(T2,'lam',lam);
    figure();
    clf;
    plot(s1.lam,s1.val);
    hold on;
    plot(s2.lam,s2.val);
    plot(sD.lam,sD.val / max(sD.val));
    xlabel('\lambda (nm)');
    ylabel('normalized spectrum');
    title('Some white spectra');
    legend({'Planck 3200K','Planck 5600K','CIE D 5600K'},'Location','southeast');
end