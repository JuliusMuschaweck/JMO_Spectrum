function rv = IntegrateSpectrum(spectrum, weight)
    % compute weighted integral of spectrum. If weight omitted, compute just the integral.
    %
    % Spectra in this library are always continuous, and assumed to be linear between the data points.
    % First, spectrum and weight are multiplied. The result will have the wavelengths interweaved, and
    % the multiplication result will be the product of the linearly interpolated individual values.
    % The multiplication result is assumed to be linear between these interweaved points, just like every
    % spectrum in this library. Accordingly, we integrate the multiplication result by simple trapezoidal
    % rule.
    % This means, however, that even for simple linear spectra and weights, the
    % integral depends on the wavelength resolution. For example:
    if nargin == 1
        rv = trapz(spectrum.lam, spectrum.val);
    else 
        integrand = MultiplySpectra(spectrum, weight);
        rv = trapz(integrand.lam, integrand.val);
    end
end
    