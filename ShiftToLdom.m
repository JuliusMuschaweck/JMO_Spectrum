%% ShiftToLdom
% 
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp; 
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp;
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp; 
% <a href="GroupedList.html"> Grouped list</a>
% Source code: <a href = "file:../ShiftToLdom.m"> ShiftToLdom.m</a>
% </p>
% </html>
%
% Shifts the wavelength array of a spectrum such that the desired dominant wavelength
% results.
%% Syntax
% |[spec_out, delta_lam] = ShiftToLdom(spec_in, ldom)|
%
%% Input Arguments
% * |spec_in|: struct, a valid spectrum (see <docDesignDecisions.html design decisions> for
% requirements). The spectrum whose wavelength shall be shifted
% * |ldom|: scalar double. The target dominant wavelength in nm. Must be >= 400 and <= 695
%% Output Arguments
% * |spec_out|: struct, a valid spectrum. Same |val| as the input spectrum, but a constant shift has been added to |lam| 
% in order to achieve the desired dominant wavelength. 
%% Algorithm
% Iteratively applies a candidate shift, computes the resulting dominant wavelength, and
% adjusts the candidate shift until agreement is reached within roundoff error. 
% See <LDomPurity.html LDomPurity> for definition of dominant wavelength.
%% See also
% <FindRoot1D.html FindRoot1D>, <LDomPurity.html LDomPurity>
%% Usage Example
% <include>Examples/ExampleShiftToLdom.m</include>

% publish with publishWithStandardExample('filename.m') in PublishDocumentation.m

% JMO Spectrum Library, 2021. See https://github.com/JuliusMuschaweck/JMO_Spectrum
% I dedicate the JMO_Spectrum library to the public domain under Creative Commons Zero 
% (https://creativecommons.org/publicdomain/zero/1.0/legalcode)
%
function [spec_out, delta_lam] = ShiftToLdom(spec_in, ldom)
    % delta_lam must be added to spec_in to get dominant wavelength ldom
    spec_in = struct('lam', spec_in.lam, 'val', spec_in.val); % to remove possible other fields like spec_in.XYZ
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
        minshift = min(ldom - ldom0, maxshift);
        for u = [0, 0.03, 0.1, 0.3, 0.7, 0.999]
            shift = (1-u) * minshift + u * maxshift;
            test = spec_in;
            test.lam = test.lam + shift;
            testldom = LDomPurity(test);
            if abs(ldom - testldom) < 1e-3 % lucky punch
                spec_out = test;
                delta_lam = shift;
                return;
            end
            if testldom > ldom % sufficient
                break;
            end
        end
        if testldom <= ldom
            error('ShiftToLdom: cannot adjust spectrum far enough towards red');
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