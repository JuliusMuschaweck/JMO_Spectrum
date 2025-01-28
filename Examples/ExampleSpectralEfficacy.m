function ExampleSpectralEfficacy()
    blue = ReadLightToolsSpectrumFile('LERTDUW_S2WP_blue.sre');
    blue_465nm = ShiftToLdom(blue, 465);
    K = SpectralEfficacy(blue_465nm);
    fprintf("spectral efficacy of 465 LED K = %0.1f lm/W\n",K);
    fprintf("spectral efficacy at 465 nm    = %0.1f lm/W\n",Vlambda(465) * 683);
end