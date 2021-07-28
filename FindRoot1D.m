%% FindRoot1D
% 
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp; 
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp;
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp; 
% <a href="GroupedList.html"> Grouped list</a> &nbsp; | &nbsp; 
% Source code: <a href = "file:../FindRoot1D.m"> FindRoot1D.m</a>
% </p>
% </html>
% 
% Finds root of scalar function of one real variable, without derivatives.
%% Syntax
% |rv = FindRoot1D( func, x1, x2 )|
%
% |rv = FindRoot1D( func, x1, x2, NameValueArgs)|
%
% |[rv, fb, nfe, ok, msg] = FindRoot1D( func, x1, x2, ___)|
%% Description
% |rv = FindRoot1D( func, x1, x2 )| finds a root of the continuous function 
% |func|, bracketed between |x1| and |x2|, i.e.
% |func(x1)| and |func(x2)| must have opposite signs. Then, |func(rv] == 0| within a tolerance |tol|, 
% meaning that |func(x)| changes sign within an interval of width |tol|. The default tolerance is
% |1e-12|.
%
% |rv = FindRoot1D( func, x1, x2, NameValueArgs)| lets you define options via name-value pairs as optional
% arguments. Possible options are
% 
% * |'tol'|: The |x| tolerance, default |1e-12|. Must be a positive real number
% * |'nfemax'|: The maximum number of function evaluations default |100|. Must be a positive integer. 
% * |'throwOnFailure'|: Determines if error conditions cause throwing an error, default = true
%
% |[rv, fb, nfe, ok, msg] = FindRoot1D( func, x1, x2, ___)| returns additional information. |fb| is the
% function value, |fb==func(rv)|, |nfe| is the actual number of function evaluations. |ok| is a boolean
% flag with obvious meaning, and |msg| is an error message.
%
%% Examples
%   x0 = FindRoot1D(@(x) x^4 - 0.1, 0, 1)
%  x0 = 0.5623
%% Input Arguments
% * |func|: A function handle to a function that returns a scalar real when you call it with a scalar
% real parameter, like |func(0.3)|.
% * |x1, x2|: Scalar real numbers such that |func(x1)| and |func(x2)| have opposite signs. 
% * |NameValueArgs|: Optional name-value argument pairs, see above.
%% Output Arguments
% * |rv|: The root, i.e. the value where |func(rv) == 0| within tolerance. NaN on error
% * |fb|: The function value at the root, |fb == func(rv)|. NaN on error
% * |nfe|: Number of function evaluations. Integer >= 2.
% * |ok|: Flag to show success or failure. Logical. Makes sense only if the optional |'throwOnFailure'| flag is
% set to |false|. 
% * |msg|: Error message, on failure. String. Makes sense only if the optional |'throwOnFailure'| flag is
% set to |false|. 
%% Algorithm
% Closely following the Van Wijngaarden-Dekker-Brent method of Press et al., "Numerical Recipes", chapter
% 9.3.
% 
% Tries to converge to the root by inverse parabolic interpolation. When the interpolation step fails or
% doesn't make the bracketing interval shrink fast enough, uses bisection, in effect combining the fail
% safety of bisectioning with the speed of inverse parabolic interpolation.
%
% Does not make use of derivative information. Assumes that the function |func| is continuous. In fact,
% |FindRoot1D(@(x) 1/x, -0.1, 0.2)| happily returns |7.2758e-13| as a root, ignoring that |1/x| has a
% pole at |x==0|.
%
% Provides essentially the same functionality as Matlab's |fzero(func, [x1, x2])|, but is about 13 times
% faster. 
%% See also
% Matlab's |fzero| function
%% Usage Example
% <include>Examples/ExampleFindRoot1D.m</include>

function [rv, fb, nfe, ok, msg] = FindRoot1D( func, x1, x2, NameValueArgs)
    arguments
        func
        x1 (1,1) double
        x2 (1,1) double
        NameValueArgs.tol (1,1) {double, mustBePositive} = 1e-12
        NameValueArgs.nfemax (1,1) {double, mustBePositive, mustBeInteger} = 100
        NameValueArgs.throwOnFailure (1,1) logical = true
    end
    ok = true;
    msg = 'FindRoot1D: success';
    ITMAX = 100;
    a = x1;
    b = x2;
    c = x2;
    fa = func(a);
    fb = func(b);
    nfe = 2;
    if (fa * fb > 0)
        msg = sprintf('FindRoot1D error: Root must be bracketed, f(%g) = %g, f(%g) = %g',a, fa, b, fb);
        if NameValueArgs.throwOnFailure
            error(msg); %#ok<SPERR>
        else 
            rv = NaN;
            fb = NaN;
            ok = false;
            return;
        end
    end
    
    fc = fb;
    for i = 0:(ITMAX-1)
        if fb*fc > 0 % the root must be between a and c
            c = a;
            fc = fa;
            e = b-a;
            d = b-a;
        end
        if abs(fc) < abs(fb)
            a = b;
            b = c;
            c = a;
            fa = fb;
            fb = fc;
            fc = fa;
        end
        tol1 = 2 * eps * abs(b) + 0.5 * NameValueArgs.tol;
        xm = 0.5*(c-b);
        if (abs(xm) <= tol1) || fb == 0.0 % done
            rv = b;
            return;
        end
        if (abs(e) >= tol1) && (abs(fa) > abs(fb)) % attempt inverse quadr. interpolation
            s = fb/fa;
            if (a==c)
                p = 2 * xm * s;
                q = 1 - s;
            else
                q = fa/fc;
                r = fb/fc;
                p = s * (2.0*xm*q*(q-r) - (b-a)*(r-1));
                q = (q-1) * (r-1) * (s-1);
            end
            if p > 0.0
                q = -q;
            end
            p = abs(p);
            min1 = 3.0 * xm * q - abs(tol1 * q);
            min2 = abs (e*q);
            min12 = min(min1, min2);
            if 2 * p < min12 % accept interpolation
                e = d;
                d = p/q;
            else
                d = xm; % interpolation failed, bisection
                e = d;
            end
        else % bounds decreasing too slowly, use bisection
            d = xm;
            e = d;
        end
        a = b;
        fa = fb;
        if (abs(d) > tol1)
            b = b + d;
        else
            b = b + SIGN(tol1, xm);
        end
        fb = func(b);
        nfe = nfe + 1;
    end
    msg = sprintf('FindRoot1D error: too many function evaluations, nfe = %g',nfe);
    if NameValueArgs.throwOnFailure
        error(msg); %#ok<SPERR>
    else 
        rv = NaN;
        fb = NaN;
        ok = false;
    end
end

function rv1 = SIGN(aa,bb)
    if bb >= 0
        rv1 = abs(aa);
    else
        rv1 = - abs(aa);
    end
end