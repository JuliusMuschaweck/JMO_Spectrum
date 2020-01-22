function rv = AssignNewWavelength(spectrum, lam_new)
% replaces the old wavelength array with a new one, interpolating the values, outside = 0
    rv = spectrum;
    rv.lam = lam_new;
    rv.val = LinInterpol(spectrum.lam, spectrum.val, lam_new);
end