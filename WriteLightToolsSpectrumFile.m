%% WriteLightToolsSpectrumFile
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