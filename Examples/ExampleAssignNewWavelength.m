function ExampleAssignNewWavelength()
    s_old = MakeSpectrum([400 500], [0 100]);
    s_new = AssignNewWavelength(s_old, [450 451 452])
end