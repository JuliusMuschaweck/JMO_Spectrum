function rv = MultiplySpectra(lhs, rhs)
% function rv = MultiplySpectra(lhs, rhs)
% multiply spectra lhs and rhs, checking for overlap
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
    lam0 = max(lhs.lam(1), rhs.lam(1));
    lam1 = min(lhs.lam(end), rhs.lam(end));
    tmplam = unique(sort(cat(1,lhs.lam,rhs.lam)));
    tmpIdx = (tmplam >= lam0) & (tmplam <= lam1);
    rv.lam = tmplam(tmpIdx);
    if isempty(rv.lam)
        error('MultiplySpectra: This cannot happen');
    end
    vl = LinInterpol(lhs.lam,lhs.val,rv.lam);
    vr = LinInterpol(rhs.lam,rhs.val,rv.lam);
    rv.val = vl .* vr;
end