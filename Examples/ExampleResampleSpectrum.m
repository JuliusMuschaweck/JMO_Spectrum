function ExampleResampleSpectrum()
    s_old = MakeSpectrum([400 500], [0 100]);
    s_new = ResampleSpectrum(s_old, [450 451 452])
end