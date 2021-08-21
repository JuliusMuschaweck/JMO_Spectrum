function ExampleWriteLightToolsSpectrumFile()
    spec = MakeSpectrum([400 700],[1 2],'name','example spectrum');
    WriteLightToolsSpectrumFile(spec, 'tmp.sre');
    !more tmp.sre
    !del tmp.sre
end