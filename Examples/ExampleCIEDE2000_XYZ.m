function ExampleCIEDE2000_XYZ()
    name = ' Air Mass 1.5 Solar Spectrum';
    fprintf('CIEDE2000 dE of CIE D Illuminants vs. %s\n',name);
    d6500 = CIE_Illuminant_D(6500); % our reference white
    d6500.XYZ = CIE1931_XYZ(d6500);
    figure();
    hold on;
    plot(d6500.lam, d6500.val);
    TT = 5000:200:7000;
    am1_5 = ResampleSpectrum(SolarSpectrum('AM15_GlobalTilt'), 360:830);
    am1_5.val = am1_5.val * 33;
    am1_5.XYZ = CIE1931_XYZ(am1_5);
    plot(am1_5.lam, am1_5.val,'k','LineWidth',2);
    leg = {'D(6500)', 'AM 1.5 Global Tilt'};
    for T = TT
        ds = CIE_Illuminant_D(T);
        ds.val = ds.val * 0.5;
        ds.XYZ = CIE1931_XYZ(ds);
        plot(ds.lam, ds.val);
        dE = CIEDE2000_XYZ(ds.XYZ, am1_5.XYZ, d6500.XYZ);
        fprintf('T = %g K, dE = %g\n', T, dE);
        leg{end+1} = sprintf('D(%g)',T);
    end
    xlabel('\lambda (nm)');
    ylabel('Spectrum (a.u.)');
    legend(leg,'Location','northeastoutside');
end