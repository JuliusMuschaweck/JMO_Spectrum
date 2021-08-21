function ExampleSpectrumSanityCheck()
    good = MakeSpectrum([400 700], [1 1]);
    [ok1, msg1, rv1] = SpectrumSanityCheck(good);
    bad = struct('lam', [1, 2, 1], 'val', [0 0 0]);
    [ok2, msg2, rv2] = SpectrumSanityCheck(bad, 'doThrow', false)
end