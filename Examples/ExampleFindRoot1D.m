function ExampleFindRoot1D()
    rv = FindRoot1D( @log, 0.1, 42);
    fprintf('Root of log function = %g, with %g difference to 1\n',rv, rv-1);
    tol = 1e-6;
    [rv, fb, nfe, ok, msg] = FindRoot1D( @log, 0.1, 42, 'tol',tol);
    fprintf('Same, but with tol = %g: root = %g, with %g difference to 1\n',tol, rv, rv-1);
    fprintf('function value at root = %g, using %g evaluations\n', fb, nfe);
end
