%% FindRootND
% 
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp; 
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp;
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp; 
% <a href="GroupedList.html"> Grouped list</a> &nbsp; | &nbsp; 
% Source code: <a href = "file:../FindRootND.m"> FindRootND.m</a>
% </p>
% </html>
%
% Finds multidimensional root of function in N dimensions, without derivatives
%% Syntax
% |[rv, ok, info] = FindRootND(func, x0, opts)|
%% Input Arguments
% * |func|: handle to function with signature |rv = func(x)|, where both |rv| and |x| are vectors of same length |n|
% * |x0|: double vector, with length |n|. The starting point for the search
% * |opts|: Name-Value pairs
%
% <html>
% <p style="margin-left: 25px">
% <table border=1>
% <tr><td> <b>Name</b>      </td> <td>  <b>Type</b>     </td> <td><b>Value</b>      </td> <td><b>Meaning</b>                              </td></tr>
% <tr><td> 'maxIterations'  </td> <td> positive integer </td> <td> 100 (default)    </td> <td> max. number of line search iterations      </td></tr>
% <tr><td> 'tolF'           </td> <td> positive double  </td> <td> 1e-8 (default)   </td> <td> max. abs. function value for termination   </td></tr>
% <tr><td> 'tolX'           </td> <td> positive double  </td> <td> 1e-12 (default)  </td> <td> max. abs. or rel. change in any x component for termination   </td></tr>
% <tr><td> 'maxStepX'       </td> <td> positive double  </td> <td> 100 (default)    </td> <td> max. abs. or rel. step in x for line search </td></tr>
% <tr><td> 'tolMin'         </td> <td> positive double  </td> <td> 1e-12 (default)  </td> <td> tolerance for local minimum detection </td></tr>
% </table>
% </p>
% </html>
%

%% Output Arguments
% * |rv|: double vector of length |n|. The |x| value at the root.
% * |ok|: scalar logical. |true| for success, |false| for failure
% * |info|: |struct| with fields |fvec| (the last function value), |msg| (a diagnostic string), |iter| (the number of
% line search iterations), and |history|. |history| is a struct with fields |x|, |fvec|, and |xRestart|. They all are
% matrices with size |(2, iter)|: the history of x and function values, and the x values where the Jacobian estimate was
% reset.

%% Algorithm
% Implements Broyden's method (see <https://en.wikipedia.org/wiki/Broyden%27s_method>, closely following the
% implementation in Press et al., Numerical Recipes, chapter 9.7.3. This is a quasi-Newton method, where the Jacobian is
% estimated by simple forward differencing and approximately updated using the function value history. In other words,
% it is a multidimensional generalization of the secant method.
%% See also
% <FindRoot1D.html FindRoot1D>, Matlab's |fsolve| in the Optimization toolbox.
%% Usage Example
% <include>Examples/ExampleFindRootND.m</include>

% publish with publishWithStandardExample('filename.m') in PublishDocumentation.m

% JMO Spectrum Library, 2021. See https://github.com/JuliusMuschaweck/JMO_Spectrum
% I dedicate the JMO_Spectrum library to the public domain under Creative Commons Zero 
% (https://creativecommons.org/publicdomain/zero/1.0/legalcode)
%

function [rv, ok, info] = FindRootND(func, x0, opts)
    arguments
        func
        x0 (:,1) double
        opts.maxIterations (1,1) double {mustBePositive, mustBeInteger} = 200
        opts.tolF (1,1) double {mustBePositive} = 1e-8
        opts.tolX (1,1) double {mustBePositive} = 1e-12
        opts.maxStepX (1,1) double {mustBePositive} = 100
        opts.tolMin (1,1) double {mustBePositive} = 1e-12
    end
    x0 = x0(:);
    n = length(x0);
    x = x0;
    xold = NaN(n,1);
    ff = @(xx) reshape(func(xx), n, 1);
    [f, fvec] = Fmin(ff, x);
    info = struct();
    info.history.x = x;
    info.history.fvec = fvec;
    info.history.xRestart = x;
    restart = true; % trigger new Jacobi matrix calculation
    % test for initial guess being a root
    if all(abs(fvec) < opts.tolF)
        rv = x;
        ok = true;
        info.fvec = fvec;
        info.msg = 'Initial guess was root';
        info.iter = 0;
        return;
    end
    % calc stepmax for line search
    stepmax = opts.maxStepX * max(norm(x), n);
    % iteration loop
    for iter = 1:opts.maxIterations
        if restart % new jacobi and QR
            [jac, fvec] = Jacobi(ff, x);
            if iter > 2
                info.history.xRestart(:,end+1) = x;
            end
            [Q,R] = qr(jac);
            if IsSingularR(R)
                [Q,R] = qr(eye(n));
            end
        else % Broyden update
            s = x - xold;
            t = R * s;
            w = fvec - fvec_old - Q' * t;
            w_lim = eps * (abs(fvec) + abs(fvec_old));
            w_noisy = abs(w) < w_lim;
            w(w_noisy) = 0;
            if ~all(w_noisy) % don't update with noisy w
                t = Q' * w;
                s = s / (s' * s);
                % [Q, R] = qrupdate(Q, R, t, s); % different meaning between Matlab and Press
                [Q, R] = qrupdate(Q, R, w, s); % different meaning between Matlab and Press
                if IsSingularR(R)
                    error('FindRootND: Singular Broyden update');
                end
            end
        end
        % rhs  -Q' * f
        p = - Q' * fvec;
        % estimate gradient F
        g = - R' * p;
        xold = x;
        fvec_old = fvec;
        fold = f;
        % solve linear equations
        p = R \ p;
        slope = g' * p;
        if slope >= 0
            restart = true;
            continue;
        end
        % line search
        fmin = @(xx) Fmin(ff, xx);
        [x, f, fvec, tooClose] = LineSearch(fmin, xold, fold, g, p, stepmax);
        info.history.x(:,end+1) = x;
        info.history.fvec(:,end+1) = fvec;
        % test for convergence
        if max(abs(fvec)) < opts.tolF
            rv = x;
            ok = true;
            info.fvec = fvec;
            info.msg = 'Root found';
            info.iter = iter;
            return;
        end
        % if failed to find new x
        if tooClose
        %   if just reinitalized Jacobi -> error
            if restart
                rv = NaN(n,1);
                ok = false;
                info.fvec = fvec;
                info.last_x = x;
                info.msg = 'no root found';
                info.iter = iter;
                return;
            end
            %   check for spurious convergence
            xTest = MaxAbsOrOne(x);
            test = max(abs(g) .* xTest / max(f, 0.5*n));
            if test < opts.tolMin
                rv = NaN(n,1);
                ok = false;
                info.fvec = fvec;
                info.last_x = x;
                info.msg = 'no root found: converged on minimum of f*f';
                info.iter = iter;
                return;
            end
            %   trigger restart jacobi
            restart = true;
        else % (successful step)
            %   untrigger restart jacobi
            restart = false;
            %   check for convergence
            test = max( abs(x - xold) ./ MaxAbsOrOne(x));
            if test < opts.tolX
                rv = x;
                ok = true;
                info.fvec = fvec;
                info.msg = 'Initial guess was root';
                info.iter = 0;
                return;
            end
            %   use update for next iteration
        end
    end % end iteration loop
    error('FindRootND: max. iterations == %g exceeded', opts.maxIterations);
end

function [rv, fvec] = Fmin( ff, x )
    fvec = ff(x);
    rv = 0.5 * (fvec' * fvec);
end

function rv = MaxAbsOrOne(xx)
    rv = abs(xx);
    rv( rv < 1 ) = 1;
end

function [rv, fvec] = Jacobi(func, x) % forward difference jacobi matrix
    EPS = 1e-8;
    n = length(x);
    rv = NaN(n,n);
    xh = x;
    fvec = func(x);
    for j = 1:n
        temp = xh(j);
        h = EPS * abs(temp);
        if h == 0
            h = EPS;
        end
        xh(j) = temp + h; % reduce finite precision error
        h = xh(j) - temp;
        f = func(xh); 
        xh(j) = temp;
        df = (f - fvec) / h;
        rv(j,:) = (df(:))';
    end
    rv = rv';
end

function rv = IsSingularR( R )
    dd = abs(diag(R));
    sumdd = sum(dd);
    rv = (sumdd == 0 || min(dd) / sumdd < 10 * eps);
end

function [x, f, fvec, tooClose] = LineSearch(func, xold, fold, g, p, stepmax)
    ALF = 1e-4;
    TOLX = eps;
    alam2 = 0;
    f2 = 0;
    % n = length(xold);
    tooClose = false;
    sum = sqrt(p' * p);
    if sum > stepmax
        p = p * (stepmax / sum);
    end
    slope = g' * p;
    if slope >= 0
        error('FindRootND: positive slope in LineSearch');
    end
    test = max(abs(p) ./ MaxAbsOrOne(xold));
    alamin = TOLX / test;
    alam = 1;
    while true
        x = xold + alam * p;
        [f, fvec] = func(x);
        if alam < alamin % too close to xold
            x = xold;
            tooClose = true;
            return;
        elseif f <= fold + ALF * alam * slope % all is well
            return;
        else % backtrack
            if alam == 1 % first backtrack
                tmplam = - slope / (2 * (f - fold - slope));
            else % next backtracks
                rhs1 = (f - fold - alam*slope) / alam^2;
                rhs2 = (f2 - fold  - alam2*slope) / alam2^2;
                d_alam = alam - alam2;
                a = (rhs1 - rhs2) / d_alam;
                b = (alam2 * rhs1 + alam * rhs2) / d_alam;
                if a == 0
                    tmplam = -slope / (2*b);
                else
                    disc = b^2 - 3 * a * slope;
                    if disc < 0
                        tmplam = 0.5 * alam;
                    elseif b <= 0
                        tmplam  = (-b + sqrt(disc)) / (3*a);
                    else
                        tmplam = -slope / (b + sqrt(disc));
                    end
                end
                tmplam = min(tmplam, 0.5*alam);
            end
        end
        alam2 = alam;
        f2 = f;
        alam = max(tmplam, 0.1 * alam);
    end
end


