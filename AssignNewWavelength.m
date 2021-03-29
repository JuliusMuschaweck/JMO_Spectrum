%% AssignNewWavelength
% <html> horst <br> erwin</html>
% Adds several spectra with weights.
%% Syntax
% |function rv = AddWeightedSpectra(spectra,weights)|
%% Input Arguments
% * |spectra|: scalar, 1-D vector or 1-D cell array of valid spectra
% * |weights|: scalar or 1-D vector of double
%% Output Arguments
% * |rv|: Spectrum containing the merged wavelengths in field |rv.lam|, and the weighted sum of all input spectra in field |rv.val|
%% Algorithm
% Computes the weighted sum of all spectra. When spectra do not overlap, the wavelength ranges are concatenated, 
% and the range in between is padded with zero. If they do overlap, then |rv.lam| contains all values from all input spectra, 
% with duplicate values removed, and what is added are the weighted sum of linearly interpolated values from all input spectra. Thus, the sum spectrum is a 
% perfect model of the underlying continuous function which is the weighted sum of the continuous, linearly interpolated input spectra.
%% See also
% <AddSpectra.html AddSpectra>, <MultiplySpectra.html MultiplySpectra>
%% Usage Example
% <include>ExampleAddWeightedSpectra.m</include>

% publish with publish('AssignNewWavelength.m','evalCode',false,'showCode',false,'codeToEvaluate','ExampleAssignNewWavelength();');

% JMO Spectrum Library, 2021. See https://github.com/JuliusMuschaweck/JMO_Spectrum
% I dedicate the JMO_Spectrum library to the public domain under Creative Commons Zero 
% (https://creativecommons.org/publicdomain/zero/1.0/legalcode)

function rv = AssignNewWavelength(spectrum, lam_new)
% replaces the old wavelength array with a new one, interpolating the values, outside = 0
    rv = spectrum;
    rv.lam = lam_new;
    rv.val = LinInterpol(spectrum.lam, spectrum.val, lam_new);
end