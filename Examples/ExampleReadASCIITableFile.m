function ExampleReadASCIITableSpectrumFile()
    fn = 'LED_2666K.sre';
    spec = ReadASCIITableSpectrumFile(fn); % default delimiters are ok
    spec
end