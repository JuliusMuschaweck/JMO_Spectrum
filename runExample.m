function runExample(funcname, varargin)
    oldpath = path();
    path('Examples',oldpath);
    try
        feval(funcname, varargin{:});
    catch ME
        warning(ME.identifier,'error in runExample: %s',ME.message);
    end
    path(oldpath);
end