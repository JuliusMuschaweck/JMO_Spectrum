function ExampleIsSpectrum()
    s.lam = [400 700];
    s.val = [1 1];
    fprintf('For a very simple spectrum, IsSpectrum(s) returns %g\n', IsSpectrum(s));
    s2 = s;
    s2.lam = [400 400]; % not strictly ascending!
    fprintf('When lam is not strictly ascending, IsSpectrum(s) returns %g\n', IsSpectrum(s2));
end
