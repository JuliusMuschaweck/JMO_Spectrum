%% ReadLightToolsSpectrumFile
% 
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp; 
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp;
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp; 
% <a href="GroupedList.html"> Grouped list</a> &nbsp; | &nbsp; 
% Source code: <a href = "file:../ReadLightToolsSpectrumFile.m"> ReadLightToolsSpectrumFile.m</a>
% </p>
% </html>
%
% Reads a spectrum from an ASCII text file in LightTools(R) spectrum format with comment line
% handling.
%% Syntax
% |rv = ReadLightToolsSpectrumFile(fn)|
%% Input Arguments
% * |fn|: character string. Filename from where to read.
%% Output Arguments
% * |rv|: A valid spectrum (struct with fields |lam| and |val|).
%% Algorithm
% Reads the lines from the file, assembling the wavelength and value arrays. The 'dataname'
% entry in the file will make its way into 'dataname' and 'name' fields of the returned
% spectrum. When the 'discrete' flag is present in the file, the spectrum is approximated as
% narrow peaks, with 0.001 times the minimum wavelength interval (there are no line spectra in this library). When the 'photometric' flag
% is set in the file, the returned spectrum is still radiometric, by dividing each value by
% its corresponding V(lambda) value.
%% See also
% <ReadASCIITableFile.html ReadASCIITableSpectrumFile>,
% <ReadASCIITableSpectrumFile.html ReadASCIITableSpectrumFile>,
% <SpectrumSanityCheck.html SpectrumSanityCheck>
%% Usage Example
% <include>Examples/ExampleReadLightToolsSpectrumFile.m</include>
%
% publish with publishWithStandardExample('filename.m') in PublishDocumentation.m

% JMO Spectrum Library, 2021. See https://github.com/JuliusMuschaweck/JMO_Spectrum
% I dedicate the JMO_Spectrum library to the public domain under Creative Commons Zero 
% (https://creativecommons.org/publicdomain/zero/1.0/legalcode)
%
function rv = ReadLightToolsSpectrumFile( fn )
    % Read a spectrum from LightTols .sre file format. Return spectrum, with field "dataname" if present
    %
    % Can also read a simple two column table of numbers, with or without leading string headers
    % If photometric, converts to radiometric
    % if discrete, creates spectrum with narrow peaks (0.001 * minimum lambda interval)
    
    fh = fopen(fn,'r');
    if fh < 0
        error('ReadLightToolsSpectrumFile: file %s not found',fn);
    end
    emptyline = 0;
    dataline = 1;
    commentline = 2;
    stringline = 3;
    line_number = 0;
    dataname = '';
    discrete = false;
    photometric = false;
    [ln, eof, linetype] = Getline();
    % parse header, find dataname if present
    while ~eof && linetype ~= dataline
        if linetype == stringline
            [test, rest] = LineStartsWith(ln,'dataname:');
            if test
                dataname = rest;
            end
            if LineStartsWith(ln, 'discrete')
                discrete = true;
            end
            if LineStartsWith(ln, 'photometric')
                photometric = true;
            end
        end
        [ln, eof, linetype] = Getline();        
    end    
    % parse data
    lam = [];
    val = [];
    while ~eof
        % stop at first empty line, allowing for last line to be empty
        if linetype == emptyline
            break;
        end            
        if linetype ~= dataline
            error('ReadLightToolsSpectrumFile: numeric data expected in line %g, found %s',line_number, ln);
        end
        ilamval = str2num(ln); %#ok<ST2NM>
        if ~isequal(size(ilamval),[1,2])
            error('ReadLightToolsSpectrumFile: two numbers expected in line %g, found %s',line_number, ln);
        end
        lam(end+1) = ilamval(1);  %#ok<AGROW>
        val(end+1) = ilamval(2); %#ok<AGROW>
        [ln, eof, linetype] = Getline();        
    end
    if isempty(lam)
        error('ReadLightToolsSpectrumFile: no data, parsing until line %g',line_number);
    end
    % test for ascending lam
    test = (diff(lam) > 0);
    if ~all(test)
        warning('ReadLightToolsSpectrumFile: wavelengths are not strictly ascending');
        [lam, idx] = sort(lam);
        val = val(idx);
    end
    % test for unique lambdas
    test = (diff(lam) == 0);
    if any(test)
        dbl = lam(test);
        error('ReadLightToolsSpectrumFile: wavelengths are not unique, e.g. %g',dbl(1));
    end
    % convert photometric to radiometric if necessary
    if photometric
       Vlam = Vlambda();
       iVlam = LinInterpol(Vlam.lam, Vlam.val, lam);
       if ~all(iVlam > 0)
           error('ReadLightToolsSpectrumFile: photometric file with some lambda outside 360..830');
       end
       val = val ./ iVlam;
    end
    % make narrow peaks if discrete
    if discrete
        dlam = 0.001 * min(diff(lam));
        % create left and right points. Peaks all have same width, so integrals are ok
        mlam = lam - dlam;
        plam = lam + dlam;
        zeroval = zeros(size(val));
        % exploit column major storage to sort
        ilam = cat(1,mlam,lam,plam);
        ival = cat(1,zeroval, val, zeroval);
        % create row vectors again
        lam = (ilam(:))';
        val = (ival(:))';
    end
    rv.lam = lam(:);
    rv.val = val(:);
    rv.dataname = dataname;
    rv.name = dataname;
    comment = '';
    delim = '';
    if photometric
        comment = 'converted to radiometric from photometric';
        delim = ', ';
    end
    if discrete
        comment = strcat(comment, delim, 'with narrow peaks since spectrum is discrete');
    end
    if ~isempty(comment)
        rv.comment = comment;
    end
    
    function [rv, eof, linetype] = Getline()
        % read line from fh, remove leading whitespace. If at eof, return '' and true
        ln = fgetl(fh);
        line_number = line_number + 1;
        if ischar(ln)
            ln = strrep(ln,char(9),' ');        
            rv = TrimWhitespace(ln);
            eof = false;
        else
            rv = '';
            eof = true;
        end
        if isempty(rv)
            linetype = emptyline;
        elseif rv(1) >= '0' && rv(1) <= '9'
            linetype = dataline;
        elseif rv(1) == '#'
            linetype = commentline;
        else
            linetype = stringline;
        end
    end
    
    function rv = TrimWhitespace(str)
        rv = str;
        while ~isempty(rv) && isspace(rv(1))
            rv = rv(2:end);
        end
    end
    
    function [rv, remainder] = LineStartsWith(str, pattern)
        ix = strfind(str,pattern);
        rv = ~isempty(ix) && ix(1) == 1;
        if rv
            remainder = TrimWhitespace(ln((length(pattern)+1):end));
        else
            remainder = '';
        end
    end
end