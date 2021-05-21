%% ReadASCIITableSpectrumFile
% 
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp; 
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp;
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp; 
% <a href="GroupedList.html"> Grouped list</a>
% </p>
% </html>
%
% documentation to be completed
%
function rv = ReadASCIITableSpectrumFile(fn, opts)
    arguments
        fn (1,:) char
        opts.delimiters = ''
        opts.name = ''
    end
    tt = ReadASCIITableFile(fn, 'delimiters', opts.delimiters);
    sz = size(tt);
    if sz(1) < 2 
        error('ReadASCIITableSpectrumFile(%s): need at least two wavelengths for spectrum',fn);
    end
    if sz(2) < 2
        error('ReadASCIITableSpectrumFile(%s): need at least two columns for spectrum',fn);
    end
    if sz(2) > 2
        warning('ReadASCIITableSpectrumFile(%s): found %g columns, only column 1 (lam) and 2 (val) are used',fn,sz(2));
    end
    rv.lam = tt(:,1);
    rv.val = tt(:,2);
    if ~isempty(opts.name)
        rv.name = opts.name;
    end
    [ok, msg, rv] = SpectrumSanityCheck(rv,'doThrow', false);
    if ~ok
        error('ReadASCIITableSpectrumFile(%s): not a good spectrum: %s',fn, msg);
    end
end