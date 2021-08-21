function ExampleSolarSpectrum()
    AM0 = SolarSpectrum('AM0');
    AM15 = SolarSpectrum('AM15_GlobalTilt');
    AM15_direct = SolarSpectrum('AM15_Direct_Circumsolar');
    figure();clf;hold on;
    plot(AM0.lam, AM0.val);
    plot(AM15.lam, AM15.val);
    plot(AM15_direct.lam, AM15_direct.val);
    legend({'AM0','AM1.5','AM1.5 direct'});
    xlabel('\lambda (nm)');
    ylabel('spectral irradiance in W/(m^2 nm)');
    AM0_E490 = SolarSpectrum('AM0_ASTM_E490');
    figure();clf;
    plot(log10(AM0_E490.lam),log10(AM0_E490.val));
    xlabel('log_{10}(\lambda)');
    ylabel('log_{10}(E_\lambda)');
    legend('log-log AM0');
end