%% ReadASCIITableFile
% 
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp; 
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp;
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp; 
% <a href="GroupedList.html"> Grouped list</a> &nbsp;| &nbsp; 
% Source code: <a href = "file:../ReadASCIITableFile.m"> ReadASCIITableFile.m</a>
% </p>
% </html>
%
% Reads a matrix of numbers from an ASCII text file, with optional delimiter control and
% generic comment line handling.
%% Syntax
% |rv = ReadASCIITableFile(fn, opts)|
%% Input Arguments
% * |fn|: character string. Filename from where to read.
% * |opts|: Name-Value pair
%
% <html>
% <p style="margin-left: 25px">
% <table border=1>
% <tr><td> <b>Name</b>    </td> <td>  <b>Type</b>     </td> <td><b>Value</b>     </td> <td><b>Meaning</b>                              </td></tr>
% <tr><td> 'delimiters'   </td> <td> character string </td> <td> '' (default)    </td> <td> set of characters interpreted as delimiters between numbers. See Matlab's 'split' documentation for details. If not specified, white space is used as delimiter(s).</td></tr>
% </table>
% </p>
% </html>
%

%% Output Arguments
% * |rv|: double array. Content of the ASCII table
%% Algorithm
% Reads lines, trimming white space at beginning and end. Trimmed lines that don't start with
% a digit ('0'...'9') are considered comments and are discarded. Non-comment lines are
% expected to contain only real number in ASCII format, separated by the given delimiters.
% Number of columns is taken
% from first non-comment line, and all subsequent non-comment lines are expected to have the
% same number of columns.
%
%% See also
% <ReadASCIITableSpectrumFile.html ReadASCIITableSpectrumFile>,
% <ReadLightToolsSpectrumFile.html ReadLightToolsSpectrumFile>
%% Usage Example
% <include>Examples/ExampleReadASCIITableFile.m</include>

% publish with publishWithStandardExample('filename.m') in PublishDocumentation.m

% JMO Spectrum Library, 2021. See https://github.com/JuliusMuschaweck/JMO_Spectrum
% I dedicate the JMO_Spectrum library to the public domain under Creative Commons Zero 
% (https://creativecommons.org/publicdomain/zero/1.0/legalcode)
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
        rethrow(ME);
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
    test = isnan(values);
    if min(diff(test)) >= 0 %% there is no NaN before a good number
        values = values(~test);
    else
        error('ReadASCIITableFile: expect reals in line %g, but found %s',line_nr, tt);
    end
    if isempty(values) % see if that went well
        error('ReadASCIITableFile: expect reals in line %g, but found %s',line_nr, tt);
    end
end

