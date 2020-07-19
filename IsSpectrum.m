function yesno = IsSpectrum(s)
    % checks if s is a valid spectrum
    % struct with fields lam and val, finite real vectors of same length, lam > 0 and ascending
    yesno = isa(s,'struct') && isfield(s,'lam') && isfield(s,'val') ...
    && isFiniteRealVector(s.lam) && isFiniteRealVector(s.val) ...
    && all( s.lam > 0) && all(diff(s.lam) > 0) && length(s.lam) == length(s.val);
end

function rv = isFiniteRealVector(v)
    rv = isreal(v) && isvector(v) && all(isfinite(v)) && ~ any(isnan(v));
end
    