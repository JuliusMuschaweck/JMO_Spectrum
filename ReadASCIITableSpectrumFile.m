%% ReadASCIITableSpectrumFile
% 
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp; 
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp;
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp; 
% <a href="GroupedList.html"> Grouped list</a> &nbsp; | &nbsp; 
% Source code: <a href = "file:../ReadASCIITableSpectrumFile.m"> ReadASCIITableSpectrumFile.m</a>
% </p>
% </html>
%
% Reads an (n x 2) matrix of numbers from an ASCII text file, with optional delimiter control and
% generic comment line handling, and creates a spectrum from these two columns
%% Syntax
% |rv = ReadASCIITableSpectrumFile(fn, opts)|
%% Input Arguments
% * |fn|: character string. Filename from where to read.
% * |opts|: Name-Value pairs
%
% <html>
% <p style="margin-left: 25px">
% <table border=1>
% <tr><td> <b>Name</b>    </td> <td>  <b>Type</b>     </td> <td><b>Value</b>     </td> <td><b>Meaning</b>                              </td></tr>
% <tr><td> 'delimiters'   </td> <td> character string </td> <td> '' (default)    </td> <td> set of characters interpreted as delimiters between numbers. See Matlab's 'split' documentation for details. If not specified, white space is used as delimiter(s).</td></tr>
% <tr><td> 'name'         </td> <td> character string </td> <td> '' (default)    </td> <td> When specified, the returned spectrum will have an additional field |'name'| with this parameter</td></tr>
% </table>
% </p>
% </html>
%

%% Output Arguments
% * |rv|: A valid spectrum (struct with fields |lam| and |val|).
%% Algorithm
% Calls <ReadASCIITableFile.html ReadASCIITableFile> to read the table, which is
% expected to have at least two rows and at least two columns. The first column is
% interpreted as wavelength in nanometers, the second column as the values. See
% <SpectrumSanityCheck.html SpectrumSanityCheck> for requirements what constitutes a valid
% spectrum. 
%% See also
% <ReadASCIITableFile.html ReadASCIITableSpectrumFile>,
% <ReadLightToolsSpectrumFile.html ReadLightToolsSpectrumFile>,
% <SpectrumSanityCheck.html SpectrumSanityCheck>
%% Usage Example
% <include>Examples/ExampleReadASCIITableSpectrumFile.m</include>
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