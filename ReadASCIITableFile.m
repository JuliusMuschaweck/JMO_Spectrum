%% ReadASCIITableFile
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
function rv = ReadASCIITableFile(fn, opts)
    arguments
        fn (1,:) char
        opts.delimiters = ''
    end
    line_nr = 1;
    fh = fopen(fn,'r');
    if fh < 0
        error('ReadASCIITableFile: file %s not found',fn);
    end
    try
        rv = [];
        while true
            line_nr = line_nr + 1;
            [next, iline] = GetLine(fh, opts.delimiters, line_nr);
            if isnan(next)
                break; % eof
            elseif isempty(next)
                continue;
            end
            if isempty(rv)
                rv = next;
                ncol = length(next);
            else
                if length(next) ~= ncol
                    error('ReadASCIITableFile(%s): expected %g numbers in line %g: %s',fn, ncol, line_nr, iline);
                end
                rv(end+1,:) = next; %#ok<AGROW>
            end
        end
    catch ME
        fclose(fh);
    end
    
end

function [values, iline] = GetLine(fh, delims, line_nr)
    % read next line. Return NaN at eof, [] for empty/comment lines, vector of doubles otherwise
    iline = fgetl(fh); % read next line
    if iline == -1 % eof reached, return NaN
        values = NaN;
        iline = '';
        return;
    end
    tt = strtrim(iline); % trim white space front and back
    if isempty(tt) % check for empty line
        values = [];
        return;
    end
    isdigit = @(c) c >= '0' && c <= '9'; % check for comment line
    if ~isdigit(tt(1))
        values = [];
        return;
    end
    if isempty(delims) % split line into tokens
        strings = split(tt);
    else
        strings = split(tt,delims);
    end
    values = str2double(strings);% convert tokens to doubles
    values = (values(:))';
    if any(isnan(values)) % see if that want well
        error('ReadASCIITableFile: expect reals in line %g, but found %s',line_nr, itt);
    end
end

