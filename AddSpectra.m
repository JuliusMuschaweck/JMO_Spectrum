%% AddSpectra
% 
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp; 
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp; 
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp; 
% <a href="GroupedList.html"> Grouped list</a> &nbsp; | &nbsp;  
% Source code: <a href = "file:../AddSpectra.m"> AddSpectra.m</a>
% </p>
% </html>
%
% Adds two spectra without weights. Convenience function with simpler
% interface than <file:AddWeightedSpectra.html AddWeightedSpectra>
%% Syntax
% |function rv = AddSpectra(lhs, rhs)|
%% Input Arguments
% * |lhs|: A valid spectrum (see <SpectrumSanityCheck.html SpectrumSanityCheck>)
% * |rhs|: A valid spectrum (see <SpectrumSanityCheck.html SpectrumSanityCheck>)
%% Output Arguments
% * |rv|: Spectrum containing the merged wavelengths in field |rv.lam|, and
% the sum of both input spectra in field |rv.val|
%% Algorithm
% Computes the sum of |rhs| and |lhs|. When both spectra do not overlap, the wavelength ranges are concatenated, 
% and the range in between is padded with zero. If they do overlap, then |rv.lam| contains all values from both input spectra, 
% with duplicate values removed, and what is added are the linearly interpolated values from both input spectra. Thus, the sum spectrum is a 
% perfect model of the underlying continuous function which is the sum of the continuous, linearly interpolated input spectra.
%% See also
% <AddWeightedSpectra.html AddWeightedSpectra>, <ScaleSpectrum.html ScaleSpectrum>
%% Usage Example
% <include>Examples\ExampleAddSpectra.m</include>

% publish with publish('AddSpectra.m','evalCode',true,'showCode',false,'codeToEvaluate','runExample(''ExampleAddSpectra'')');

% JMO Spectrum Library, 2021. See https://github.com/JuliusMuschaweck/JMO_Spectrum
% I dedicate the JMO_Spectrum library to the public domain under Creative Commons Zero 
% (https://creativecommons.org/publicdomain/zero/1.0/legalcode)

function rv = AddSpectra(lhs, rhs)
    rv = AddWeightedSpectra({lhs rhs},[1 1]);
end