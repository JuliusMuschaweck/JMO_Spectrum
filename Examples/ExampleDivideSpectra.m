function ExampleDivideSpectra()
    % compute and plot atmospheric transmission
    AM1_5 = SolarSpectrum('AM15_GlobalTilt');
    AM0 = SolarSpectrum('AM0');
    transmission = DivideSpectra(AM1_5,AM0);
    figure();
    hold on;
    plot(AM1_5.lam,AM1_5.val);
    plot(AM0.lam,AM0.val);
    plot(transmission.lam,transmission.val);
    grid on;
    legend({'AM 1.5 global tilt','AM0 extraterrestrial','atmospheric transmission'});
    % demonstrate division by near zero treatment
    s1 = GaussSpectrum(400:800,600,40);
    result = DivideSpectra(s1, s1,'tiny',1e-3);
    figure();
    hold on;
    plot(s1.lam,s1.val,'LineWidth',2);
    plot(s1.lam,log10(s1.val));
    plot(result.lam, result.val);
    legend({'Gauss spectrum s1, \mu = 600 nm, \sigma = 40 nm','log_{10}(s1.val)',...
        's1 divided by itself, near zero threshold 1e-3'},'Location','South');
    xlabel('\lambda (nm)');
end