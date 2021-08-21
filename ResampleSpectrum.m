%% ResampleSpectrum
% 
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp; 
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp; 
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp; 
% <a href="GroupedList.html"> Grouped list</a>
% Source code: <a href = "file:../ResampleSpectrum.m"> ResampleSpectrum.m</a>
% </p>
% </html>
%
% Assign a new wavelength vector to a spectrum, interpolating the old values.
%% Syntax
% |function rv = ResampleSpectrum(spectrum, lam_new)|
%% Input Arguments
% * |spectrum|: scalar, valid spectrum (see <SpectrumSanityCheck.html SpectrumSanityCheck>)
% * |lam_new|: 1-D vector of double, valid wavelength array (positive, stricly ascending)
%% Output Arguments
% * |rv|: A copy of the old spectrum with all fields, but |lam| is replaced and |val| is linearly interpolated. For
% |lam_new values| outside the old interval, |val(i) == 0|
%% Algorithm
% See Output Arguments
%% See also
% <EvalSpectrum.html EvalSpectrum>
%% Author's notice
% JMO Spectrum Library, 2021. See <https://github.com/JuliusMuschaweck/JMO_Spectrum> for complete up to date code and
% documentation. 
% I dedicate the JMO_Spectrum library to the public domain under Creative Commons Zero 
% <https://creativecommons.org/publicdomain/zero/1.0/legalcode>
%% Usage Example
% <include>Examples/ExampleResampleSpectrum.m</include>


function rv = ResampleSpectrum(spectrum, lam_new)
% replaces the old wavelength array with a new one, interpolating the values, outside = 0
    rv = spectrum;
    rv.lam = lam_new;
    rv.val = LinInterpol(spectrum.lam, spectrum.val, lam_new);
end