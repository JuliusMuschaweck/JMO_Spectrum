function ExampleIntegrateSpectrum()
    s = PlanckSpectrum(360:830,5600);
    cie = CIE1931_Data();
    cie_x_function = MakeSpectrum(cie.lam, cie.x);
    cie_y_function = MakeSpectrum(cie.lam, cie.y);
    cie_z_function = MakeSpectrum(cie.lam, cie.z);
    s_radiant_flux = IntegrateSpectrum(s);
    fprintf('radiant flux integral = %g\n',s_radiant_flux);
    s_tristimulusX = IntegrateSpectrum(s, cie_x_function);
    s_tristimulusY = IntegrateSpectrum(s, cie_y_function);    
    s_tristimulusZ = IntegrateSpectrum(s, cie_z_function);    
    s_colorWeight = s_tristimulusX + s_tristimulusY + s_tristimulusZ;
    s_x = s_tristimulusX / s_colorWeight;
    s_y = s_tristimulusY / s_colorWeight;
    fprintf('Planck 5600K color point is (x,y) = (%g, %g)\n',s_x, s_y);
    fprintf('luminous efficacy within visible range = %g lm/W\n',683 * s_tristimulusY / s_radiant_flux);
end