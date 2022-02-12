%% IntegrateSpectrum
% 
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp; 
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp;
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp; 
% <a href="GroupedList.html"> Grouped list</a>  &nbsp; | &nbsp; 
% Source code: <a href = "file:../IntegrateSpectrum.m"> IntegrateSpectrum.m</a>
% </p>
% </html>
%
% Compute integral of spectrum over wavelength, with an optional weighting function
%% Syntax
% |rv = IntegrateSpectrum(spectrum)| integrates |spectrum|
%
% |rv = IntegrateSpectrum(spectrum, weight)| integrates |spectrum * weight|
%% Input Arguments
% * |spectrum|: A valid spectrum, see <IsSpectrum.html IsSpectrum>. The spectrum to be integrated
% * |weight|: A valid spectrum. The weighting function to multiply
% before integration

%% Output Arguments
% * |rv|: scalar double. The integral
%% Algorithm
% |spectrum| is interpreted as a piecewise linear function of wavelength, continuous within the wavelength range and
% zero outside.
% Accordingly, applying the simple trapezoidal rule (by calling |trapz|) is an analytically correct integral of a spectrum. When |weight| is present,
% it is the result of calling |MultiplySpectra(spectrum, weight)| which is integrated; this means the two wavelength
% arrays are properly interweaved, and both |spectrum| and |weight| are linearly interpolated to determine the
% additional support points. See <MultiplySpectra.html MultiplySpectra>. However: This is not exactly an analytically
% correct integral of the product of |spectrum| times |weight|: This product function would be piecewise quadratic, not
% linear. If that is an issue, use <ResampleSpectrum.html ResampleSpectrum> to create a higher resolution version of the
% product spectrum.
%% See also
% <MultiplySpectra.html MultiplySpectra>, <ResampleSpectrum.html ResampleSpectrum>, <ScaleSpectrum.html ScaleSpectrum>, <CIE1931_XYZ.html CIE1931_XYZ>
%% Usage Example
% <include>Examples/ExampleIntegrateSpectrum.m</include>

% publish with publishWithStandardExample('filename.m') in PublishDocumentation.m

% JMO Spectrum Library, 2021. See https://github.com/JuliusMuschaweck/JMO_Spectrum
% I dedicate the JMO_Spectrum library to the public domain under Creative Commons Zero 
% (https://creativecommons.org/publicdomain/zero/1.0/legalcode)
%

function rv = IntegrateSpectrum(spectrum, weight)
    if nargin == 1
        rv = trapz(spectrum.lam, spectrum.val);
    else 
        integrand = MultiplySpectra(spectrum, weight);
        rv = trapz(integrand.lam, integrand.val);
    end
end
    