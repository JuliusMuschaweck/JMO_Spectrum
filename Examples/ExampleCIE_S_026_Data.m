function ExampleCIE_S_026_Data()
    CIES026 = CIE_S_026_Data();
    figure();
    clf;
    hold on;
    PlotSpectrum(CIES026.S_cone_opic_sensitivity,'b');
    PlotSpectrum(CIES026.M_cone_opic_sensitivity,'g');
    PlotSpectrum(CIES026.L_cone_opic_sensitivity,'r');
    PlotSpectrum(CIES026.rhodopic_sensitivity,'k');
    PlotSpectrum(CIES026.melanopic_sensitivity,'m');
    legend({'S_cone_opic','M_cone_opic',...
        'L_cone_opic','rhodopic','melanopic'},'Interpreter','none');
    xlabel('\lambda (nm)');
    title('human eye cone sensitivities (CIE S 026)');

    D65 = CIE_Illuminant('D65');
    D65_lm = 683 * IntegrateSpectrum(D65, Vlambda());
    D65_melanopic_mW = 1000 * IntegrateSpectrum(D65, CIES026.melanopic_sensitivity);
    fprintf('6500 K cold white daylight  spectrum has %0.2f mW/lm melanopic efficacy\n', D65_melanopic_mW/D65_lm);

    Planck2700 = PlanckSpectrum(360:830,2700);
    Planck2700_lm = 683 * IntegrateSpectrum(Planck2700, Vlambda());
    Planck_melanopic_mW = 1000 * IntegrateSpectrum(Planck2700, CIES026.melanopic_sensitivity);
    fprintf('2700 K warm white blackbody spectrum has %0.2f mW/lm melanopic efficacy\n',Planck_melanopic_mW/Planck2700_lm);
end