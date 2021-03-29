function runExample(funcname, varargin)
    oldpath = path();
    path('Examples',oldpath);
    feval(funcname, varargin{:});
    path(oldpath);
end