function ExampleReadASCIITableSpectrumFile()
    fn = 'LED_2666K.sre';
    spec = ReadASCIITableSpectrumFile(fn, 'name', 'Generic 2666K white LED spectrum'); % default delimiters are ok
    spec
    figure()
    plot(spec.lam, spec.val);
    xlabel('\lambda (nm)');
    title(spec.name);
end