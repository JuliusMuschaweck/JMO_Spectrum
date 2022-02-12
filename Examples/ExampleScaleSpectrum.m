function ExampleScaleSpectrum()
    s = CIE_Illuminant_D(4000);
    fprintf('test spectrum: %s, peak = %g, integral = %g\n',s.name, max(s.val), IntegrateSpectrum(s));
    s2 = ScaleSpectrum(s); % no change
    fprintf('compare should be 1 (true): %g\n',isequal(s.lam(:), s2.lam(:)) && isequal(s.val(:),s2.val(:)));
    
    % scale to peak 1
    s_peak_1 = ScaleSpectrum(s, mode = 'normalize_peak'); % no need to specify value: default 1.0
    fprintf('peak should be 1: %g\n', max(s_peak_1.val));

    % scale to peak 100 
    s_peak_100 = ScaleSpectrum(s, mode = 'normalize_peak', value = 100);
    fprintf('peak should be 100: %g\n', max(s_peak_100.val));
    
    % scale to radiant flux = 2
    s_radiant_flux_2 = ScaleSpectrum(s, mode = 'normalize_radiant_flux', value = 2);
    fprintf('integral should be 2: %g\n', IntegrateSpectrum(s_radiant_flux_2 ));
    
    % scale to luminous flux 1
    s_luminous_flux_1 = ScaleSpectrum(s, mode = 'normalize_luminous_flux');
    xyz = CIE1931_XYZ(s_luminous_flux_1);
    fprintf('lum. flux should be 1: %g\n', xyz.Y * 683 );

    % scale such that some weighted integral has value 10
    w = GaussSpectrum(400:700,550,30);
    s_weighted = ScaleSpectrum(s, mode = 'normalize_integral', weight = w, value = 10);
    fprintf('weighted integral should be 10: %g\n', IntegrateSpectrum(s_weighted, w) );
end