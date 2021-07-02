function mustBeStrictlyAscending( lam )
    if length(lam) < 2
        error('Wavelength array must be a vector of length >= 2');
    end
    if sum(diff(lam) <= 0) > 0
        error('must be strictly ascending');
    end
end