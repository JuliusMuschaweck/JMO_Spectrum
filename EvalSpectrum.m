function rv = EvalSpectrum(s, lam)
    arguments
        s (1,1) struct
        lam (:,1) double
    end
    rv = LinInterpol(s.lam, s.val, lam);
end