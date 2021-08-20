%% WriteLightToolsSpectrumFile
% 
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp; 
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp;
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp; 
% <a href="GroupedList.html"> Grouped list</a> &nbsp; | &nbsp; 
% Source code: <a href = "file:../WriteLightToolsSpectrumFile.m"> WriteLightToolsSpectrumFile.m</a>
% </p>
% </html>
%
% Writes a spectrum to a text file in LightTools .sre format
%% Syntax
% |WriteLightToolsSpectrumFile(spectrum, filename, varargin)|
%
%% Input Arguments
% * |spectrum|: valid spectrum struct, see <docDesignDecisions.html requirements>.
% * |filename|: character string. If the filename does not have extension |'.sre'|, that
% extension is appended.
% * |varargin|: Name-Value pairs
%
% <html>
% <p style="margin-left: 25px">
% <table border=1>
% <tr><td> <b>Name</b>  </td> <td>  <b>Type</b>     </td> <td><b>Value</b>     </td> <td><b>Meaning</b>                              </td></tr>
% <tr><td> 'mode'       </td> <td> character string   </td> <td> 'continuous' (default) or 'discrete' </td> <td> Written to the LightTools file </td></tr>
% <tr><td> 'comment'    </td> <td> character string or cell array of strings </td> <td> '' (default) </td> <td> Written to the LightTools file </td></tr>
% </table>
% </p>
% </html>
%
%% Output Arguments
% None
%% Algorithm
% Opens the file with |filename| for writing, writes an appropriate LightTools header, and
% then |lam| and |val| into the following lines, one pair per line
%% See also
% <ReadLightToolsSpectrumFile.html ReadLightToolsSpectrumFile>
%% Usage Example
% <include>Examples/ExampleWriteLightToolsSpectrumFile.m</include>

% publish with publishWithStandardExample('filename.m') in PublishDocumentation.m

% JMO Spectrum Library, 2021. See https://github.com/JuliusMuschaweck/JMO_Spectrum
% I dedicate the JMO_Spectrum library to the public domain under Creative Commons Zero 
% (https://creativecommons.org/publicdomain/zero/1.0/legalcode)

function WriteLightToolsSpectrumFile(spectrum, filename, varargin)
% function WriteLightToolsSpectrumFile(spectrum, filename, varargin)
% Action: Write LightTools .sre spectrum file, to assign to a source
% Input:    spectrum: A valid spectrum with .lam and .val fields
%           filename: name of the spectrum file. 
%               ".sre" is appended if necessary
%           optional arguments: Name-Value pairs
%           'mode': string, only allowed value is "discrete"
%               default spectrum mode is continuous.
%           'comment' : string or cell array of strings, will be written as comments
% If spectrum has other fields which are simple strings or numeric values,
% they will be written as named comments. 
% e.g. if spectrum.name == 'My LED' then 
% '# name: My LED' will be written.
    p = inputParser;    
%    addRequired(p,'spectrum');
%    addRequired(p,'filename');
    addRequired(p,'spectrum', @(x) isstruct(x));
    addRequired(p,'filename', @(x) ischar(x));
    addParameter(p, 'mode', 'continuous');
    addParameter(p, 'comment', []);
    [ok,msg, spectrum] = SpectrumSanityCheck(spectrum);
    if ~ok
        error('WriteLightToolsSpectrumFile: invalid spectrum: %s', msg);
    end
    parse(p,spectrum, filename, varargin{:});    
    res = p.Results;
    fn = filename;
    if ~(length(fn) >= 4 && strcmp(fn((end-3):end), '.sre'))
        fn = strcat(fn,'.sre');
    end
    fh = fopen(fn,'w');
    fprintf(fh,'# LightTools spectrum file, created %s\n',datestr(now));
    if ~(isempty(res.comment))
        if iscell(res.comment)
            for i = 1:length(res.comment)
                fprintf(fh,'# %s\n',res.comment{i});
            end
        else
            fprintf(fh,'# %s\n',res.comment);
        end
    end
    fields = fieldnames(spectrum);
    for i = 1:length(fields)
        v = getfield(spectrum, fields{i});
        if ischar(v)
            fprintf(fh,'# %s: %s\n',fields{i}, v);
        elseif isnumeric(v) && isscalar(v) && isreal(v)
            fprintf(fh,'# %s: %g\n',fields{i}, v);
        end            
    end
    fprintf(fh, 'dfat 1.0\n');
    if isfield(spectrum, 'dataname')
        nn = getfield(spectrum, 'dataname');
    elseif  isfield(spectrum, 'name')
        nn = getfield(spectrum, 'name');
    else
        nn = 'Generated from Matlab spectrum variable';
    end
    fprintf(fh,'dataname: %s\n',nn);
    if strcmp(res.mode, 'discrete')
        fprintf(fh, 'discrete\n');
    else
        fprintf(fh, 'continuous\n');
    end
    fprintf(fh,'radiometric\n');
    for i= 1:length(spectrum.lam)
        fprintf(fh, '%g\t%g\n',spectrum.lam(i), spectrum.val(i));        
    end
    fclose(fh);
end