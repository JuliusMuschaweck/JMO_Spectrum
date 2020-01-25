function rv = MultiplySpectra(lhs, rhs)
    % multiply spectra lhs and rhs, checking for overlap
    %
    % Parameters:
    %   lhs: A valid spectrum
    %   rhs: A valid spectrum
    % Results: 
    %   rv: The multiplied spectrum, with the wavelengths interweaved where they overlap
    %
    % Spectra in this library are always continuous, and assumed to be linear between the data points.
    % Now, when multiplying such piecewise linear functions, viewed as functions defined over
    % all reals (zero outside the wavelength range), the product would NOT be piecewise linear: It would be
    % piecewise quadratic. However, we assume piecewise linearity not only for simplicity, but also
    % because we just don't know what the spectrum does between support points. So we apply the same
    % logic to the product of two spectra: When a wavelength point occurs in both spectra, no problem.
    % When a wavelength point occurs only in one spectrum, we interpolate the other spectrum linearly to
    % obtain the data point of the product. Then, this sequence of points is again linearly interpolated,
    % and NOT assumed to be piecewise quadratic.
    [~,~,lhs] = SpectrumSanityCheck(lhs);
    [~,~,rhs] = SpectrumSanityCheck(rhs);
    % treat equal lambda arrays
    if isequal(lhs.lam, rhs.lam)
        rv.lam = lhs.lam;
        rv.val = lhs.val .* rhs.val;
        return;
    end
    % treat no overlap case
    % use <= to avoid single line spectra
    if (lhs.lam(end) <= rhs.lam(1))
        rv.lam = [lhs.lam(1),rhs.lam(end)];
        rv.val = [0,0];
        return;
    end
    if (rhs.lam(end) <= lhs.lam(1))
        rv.lam = [rhs.lam(1),lhs.lam(end)];
        rv.val = [0,0];
        return;
    end
    % treat overlapping, unequal lambdas
    % result nonzero only in [lam0;lam1] interval
    lam0 = max(lhs.lam(1), rhs.lam(1));
    lam1 = min(lhs.lam(end), rhs.lam(end));
    % compute interveawed lam, removing duplicates
    tmplam = unique(sort(cat(1,lhs.lam,rhs.lam)));
    tmpIdx = (tmplam >= lam0) & (tmplam <= lam1);
    rv.lam = tmplam(tmpIdx);
    if isempty(rv.lam)
        error('MultiplySpectra: This cannot happen');
    end
    % Interpolate both lhs and rhs, multiply elementwise
    vl = LinInterpol(lhs.lam,lhs.val,rv.lam);
    vr = LinInterpol(rhs.lam,rhs.val,rv.lam);
    rv.val = vl .* vr;
end