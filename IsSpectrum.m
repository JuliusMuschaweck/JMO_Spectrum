%% IsSpectrum
% 
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp; 
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp;
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp; 
% <a href="GroupedList.html"> Grouped list</a> &nbsp; | &nbsp; 
% Source code: <a href = "file:../IsSpectrum.m"> IsSpectrum.m</a>
% </p>
% </html>
%
% Checks if a variable is a valid spectrum
%% Syntax
% |yesno = IsSpectrum(s)|
%% Input Arguments
% * |s|: Any variable
%% Output Arguments
% * |yesno|: scalar logical. True if |s| meets the requirements
%% Algorithm
% Checks if |s| is a |struct|, has fields |lam| and |val|, which are both finite, non-NaN real vectors of same length,
% and where |lam| is positive and strictly ascending.
%% See also
% <MakeSpectrum.html MakeSpectrum>
%% Usage Example
% <include>Examples/ExampleIsSpectrum.m</include>

% publish with publishWithStandardExample('filename.m') in PublishDocumentation.m

% JMO Spectrum Library, 2021. See https://github.com/JuliusMuschaweck/JMO_Spectrum
% I dedicate the JMO_Spectrum library to the public domain under Creative Commons Zero 
% (https://creativecommons.org/publicdomain/zero/1.0/legalcode)
%
function yesno = IsSpectrum(s)
    % checks if s is a valid spectrum
    % struct with fields lam and val, finite real vectors of same length, lam > 0 and ascending
    yesno = isa(s,'struct') && isfield(s,'lam') && isfield(s,'val') ...
    && isFiniteRealVector(s.lam) && isFiniteRealVector(s.val) ...
    && all( s.lam > 0) && all(diff(s.lam) > 0) && length(s.lam) == length(s.val);
end

function rv = isFiniteRealVector(v)
    rv = isreal(v) && isvector(v) && all(isfinite(v)) && ~ any(isnan(v));
end
    