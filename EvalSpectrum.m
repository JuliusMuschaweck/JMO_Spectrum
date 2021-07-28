%% EvalSpectrum
% 
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp; 
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp;
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp; 
% <a href="GroupedList.html"> Grouped list</a> &nbsp; | &nbsp; 
% Source code: <a href = "file:../EvalSpectrum.m"> EvalSpectrum.m</a>
% </p>
% </html>
%
% Evaluates the function modeled by a spectrum
%% Syntax
% |rv = EvalSpectrum(s, lam)|
%% Input Arguments
% * |s|: A valid spectrum
% * |lam|: Vector of double. The idea is that these are wavelengths, but unlike the wavelengths in a spectrum, these
% values don't need to be ascending or positive.

%% Output Arguments
% * |rv|: Vector of double, same length as |lam|. The interpolated values.
%% Algorithm
% Thinks of the spectrum as a model of a scalar function which piecewise interpolates linearly between the individual
% wavelength points of the spectrum |s|, and jumps to zero outside. Evaluates this function for each requested value in
% |lam|. Does the same as calling Matlab's |interp1(s.lam, s.val, lam, 'linear', 0)|
%% See also
% <LinInterpol.html LinInterpol>
%% Usage Example
% <include>Examples/ExampleEvalSpectrum.m</include>

% publish with publishWithStandardExample('filename.m') in PublishDocumentation.m

% JMO Spectrum Library, 2021. See https://github.com/JuliusMuschaweck/JMO_Spectrum
% I dedicate the JMO_Spectrum library to the public domain under Creative Commons Zero 
% (https://creativecommons.org/publicdomain/zero/1.0/legalcode)
%

function rv = EvalSpectrum(s, lam)
    arguments
        s (1,1) struct
        lam (:,1) double
    end
    rv = interp1(s.lam, s.val, lam,'linear',0);
end