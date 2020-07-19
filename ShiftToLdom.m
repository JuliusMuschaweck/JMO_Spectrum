function [spec_out, delta_lam] = ShiftToLdom(spec_in, ldom)
    % delta_lam must be added to spec_in to get dominant wavelength ldom
    maxldom = 695;
    minldom = 400;
    if ldom > maxldom || ldom < minldom
        error('ShiftToLdom: ldom out of range, %g is < %g of > %g',ldom, minldom, maxldom);
    end
    ldom0 = LDomPurity(spec_in);
    if abs(ldom - ldom0) < 1e-3
        spec_out = spec_in;
        delta_lam = 0;
        return;
    end
    if ldom > ldom0 % shift to red
        nonzero = spec_in.val > 0;
        nonzerolam = spec_in.lam(nonzero);
        lam_min = nonzerolam(1);
        maxshift = maxldom - lam_min;
        testshift = 2 * (ldom - ldom0);
        shift = min(maxshift, testshift);
        test = spec_in;
        test.lam = test.lam + shift;
        testldom = LDomPurity(test);
        if testldom <= ldom
            shift = maxshift;
            test = spec_in;
            test.lam = test.lam + shift;
            testldom = LDomPurity(test);
            if testldom <= ldom
                error('ShiftToLdom: cannot adjust spectrum far enough towards red');
            end
        end
        % now ldom0 < ldom < testldom => bracket
        if shift <= 0
            error('ShiftToLdom: shift <= 0 for red shift: this cannot happen');
        end
        [shift0, fb, nfe, ok, msg] = FindRoot1D( @LDomRoot, 0, shift);
        if ~ok
            error('ShiftToLdom: cannot find root: %s, nfe = %g, fb = %g ', msg, nfe, fb);
        end
        spec_out = spec_in;
        spec_out.lam = spec_out.lam + shift0;
        delta_lam = shift;
    else % shift to blue
        nonzero = spec_in.val > 0;
        nonzerolam = spec_in.lam(nonzero);
        lam_max = nonzerolam(end);
        maxshift = minldom - lam_max; % < 0, hopefully
        testshift = 2 * (ldom - ldom0); % < 0
        shift = max(maxshift, testshift); % the smaller shift, due to < 0
        test = spec_in;
        test.lam = test.lam + shift;
        testldom = LDomPurity(test);
        if testldom >= ldom
            shift = maxshift;
            test = spec_in;
            test.lam = test.lam + shift;
            testldom = LDomPurity(test);
            if testldom >= ldom
                error('ShiftToLdom: cannot adjust spectrum far enough towards blue');
            end
        end
        % now ldom0 > ldom > testldom => bracket
        if shift >= 0
            error('ShiftToLdom: shift >= 0 for blue shift: this cannot happen');
        end
        [shift0, fb, nfe, ok, msg] = FindRoot1D( @LDomRoot, shift, 0);
        if ~ok
            error('ShiftToLdom: cannot find root: %s, nfe = %g, fb = %g ', msg, nfe, fb);
        end
        spec_out = spec_in;
        spec_out.lam = spec_out.lam + shift0;
        delta_lam = shift;
    end
    
    function rv = LDomRoot(shift)
        mytest = spec_in;
        mytest.lam = mytest.lam + shift;
        rv = LDomPurity(mytest) - ldom;
    end
end