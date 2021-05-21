function ExampleComputeSpectrumColorimetry()
    XYZn = CIE1931_XYZ(CIE_Illuminant('E'));
    rv = ComputeSpectrumColorimetry(PlanckSpectrum(400:700,5600),'XYZn',XYZn)
end