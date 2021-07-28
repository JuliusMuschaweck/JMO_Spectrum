%% MakeSpectrum
% 
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp; 
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp;
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp; 
% <a href="GroupedList.html"> Grouped list</a> &nbsp; | &nbsp; 
% Source code: <a href = "file:../MakeSpectrum.m"> MakeSpectrum.m</a>
% </p>
% </html>
%
% creates a spectrum struct out of fields lam and val, with sanity checks
%% Syntax
% |rv = MakeSpectrum(lam, val, varargin)|
%% Input Arguments
% * |lam|: vector of double. The wavelength array, should be strictly positive and strictly ascending, with length > 1
% (no single line spectra in this library)
% * |val|: vector of double, of same length as |lam|. The values of the spectrum
% * |varargin|: Name-Value pairs, which get added to the spectrum struct as additional fields.
%% Output Arguments
% * |rv|: a struct with fields |lam|, |val| (both column vectors of same length), and any additional fields defined by
% the name-value pairs in |varargin|.
%% Algorithm
% Creates the struct, and calls |SpectrumSanityCheck| to make sure all requirements are met and that |lam| and |val| are
% column vectors.
%% See also
% <MakeSpectrumDirect.html MakeSpectrumDirect>, <SpectrumSanityCheck.html SpectrumSanityCheck>
%% Usage Example
% <include>Examples/ExampleMakeSpectrum.m</include>

% publish with publishWithStandardExample('filename.m') in PublishDocumentation.m

% JMO Spectrum Library, 2021. See https://github.com/JuliusMuschaweck/JMO_Spectrum
% I dedicate the JMO_Spectrum library to the public domain under Creative Commons Zero 
% (https://creativecommons.org/publicdomain/zero/1.0/legalcode)
%
function rv = MakeSpectrum(lam, val, varargin)
% function rv = MakeSpectrum(lam, val)
% creates a spectrum struct out of fields lam and val
% and checks if they meet the requirements
    rv = struct('lam',lam,'val',val);
    [~,~,rv] = SpectrumSanityCheck(rv);
    i = 1;
    if IsOctave()
        va = varargin;
    else
        va = cellfun( @convertStringsToChars, varargin, 'UniformOutput',false); % be compatible with both "" and '' input
    end
    while nargin >= i + 3
        fieldname = va{i};
        fieldvalue = va{i+1};
        if ~ischar(fieldname)
            error('MakeSpectrum: optional argument # %g must be a string, the name of a name/value pair',i);
        end
        rv.(fieldname) = fieldvalue;
        i = i + 2;
    end
end