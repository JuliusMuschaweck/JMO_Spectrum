%% SpectralEfficacy
% 
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp; 
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp;
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp; 
% <a href="GroupedList.html"> Grouped list</a> &nbsp; | &nbsp; 
% Source code: <a href = "file:../CCT.m"> CCT.m</a>
% </p>
% </html>
%
% Computes the spectral efficacy of a spectrum, in lm/W
%% Syntax
% |rv = SpectralEfficacy(spec)|
%% Input Arguments
% * |spec|: A valid spectrum (see <SpectrumSanityCheck.html SpectrumSanityCheck>)
%% Output Arguments
% * |rv|: The spectral efficacy K
%% Algorithm
% Computes luminous and radiant flux by integration via 
% <IntegrateSpectrum.html IntegrateSpectrum>, and returns the ratio times 683
% lm/W
%% See also
% <IntegrateSpectrum.html IntegrateSpectrum>, <Vlambda.html Vlambda>
%% Usage Example
% <include>Examples/ExampleSpectralEfficacy.m</include>

% publish with publishWithStandardExample('filename.m') in PublishDocumentation.m

% JMO Spectrum Library, 2021. See https://github.com/JuliusMuschaweck/JMO_Spectrum
% I dedicate the JMO_Spectrum library to the public domain under Creative Commons Zero 
% (https://creativecommons.org/publicdomain/zero/1.0/legalcode)
%
function rv = SpectralEfficacy(spec)
    SpectrumSanityCheck(spec);
    Phi = IntegrateSpectrum(spec);
    Phiv = IntegrateSpectrum(spec, Vlambda());
    rv = 683 * Phiv / Phi;
end

