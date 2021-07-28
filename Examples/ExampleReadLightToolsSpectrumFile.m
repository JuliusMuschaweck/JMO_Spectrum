function ExampleReadLightToolsSpectrumFile()
    fn = 'LED_2666K.sre';
    spec = ReadLightToolsSpectrumFile(fn); 
    spec
    figure();
    plot(spec.lam, spec.val);
    xlabel('\lambda (nm)');
    title(spec.name);
end