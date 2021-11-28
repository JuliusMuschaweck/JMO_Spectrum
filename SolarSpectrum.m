%% SolarSpectrum
% 
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp; 
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp;
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp; 
% <a href="GroupedList.html"> Grouped list</a>
% Source code: <a href = "file:../SolarSpectrum.m"> SolarSpectrum.m</a>
% </p>
% </html>
%
% Returns a specific standardized solar spectrum, AM 0 (extraterrestrial) or AM 1.5 (air mass 1.5)
%% Syntax
% |rv = SolarSpectrum(type)|
%
%% Input Arguments
% * |type|: character string. 
%
% <html>
% <p style="margin-left: 25px">
% <table border=1>
% <tr><td> <b>Value</b>    </td> <td>  <b>Meaning</b> </td>
% <tr><td> 'AM0'  </td> <td> Extraterrestrial irradiance spectrum according to ASTM G173-03, from 280 nm to 4000 nm </td>  
% <tr><td> 'AM15_GlobalTilt'  </td>  <td> Global irradiance spectrum on tilted surface, with air mass 1.5, according to ASTM G173-03, from 280 nm to 4000 nm</td>  
% <tr><td> 'AM15_Direct_Circumsolar'  </td>  <td> Direct and circumsolar irradiance spectrum on tilted surface, with air mass 1.5, according to ASTM G173-03, from 280 nm to 4000 nm</td>  
% <tr><td> 'AM0_ASTM_E490'  </td>  <td> Extraterrestrial irradiance spectrum according to ASTM G173-03, from 119.5 nm to 1 mm = 1e6 nm</td>  
% </table>
% </p>
% </html>
%
%% Output Arguments
% * |rv|: struct with fields |lam|, |val| (both double vectors) and |name| (character string), the requested solar spectrum
%% Algorithm
% At first call, loads the spectra from 'solarSpectra_AM0_AM15_ASTM_G173_03.mat' and
% 'solarSpectrum_AM0_ASTM_E_490.mat', storing them in persistent variables to speed up
% subsequent calls. Returns requested variant. These spectra have both higher resolution and
% wavelength range compared to the CIE daylight spectra.
%% See also
% <CIE_Illuminant_D.html CIE_Illuminant_D>
%% Usage Example
% <include>Examples/ExampleSolarSpectrum.m</include>

% publish with publishWithStandardExample('filename.m') in PublishDocumentation.m

% JMO Spectrum Library, 2021. See https://github.com/JuliusMuschaweck/JMO_Spectrum
% I dedicate the JMO_Spectrum library to the public domain under Creative Commons Zero 
% (https://creativecommons.org/publicdomain/zero/1.0/legalcode)
%%
function rv = SolarSpectrum(type)
    % Return specific solar spectrum, AM 0 (extraterrestrial) or AM 1.5 (air mass 1.5)
    % Parameters:
    %   type: string or character vector
    %       'AM0', 'AM15_GlobalTilt', 'AM15_Direct_Circumsolar', 'AM0_ASTM_E490'
    % The first three are spectra according to ASTM G173-03, with lam from 280 nm to 4000 nm
    % 'AM0_ASTM_E490', extraterrestrial, according to ASTM E490, with lam from 119.5 nm to 1 mm = 1e6 nm
    arguments
        type {mustBeTextScalar}
    end
    persistent ASTM_G173_03
    persistent ASTM_E_490
    if isempty(ASTM_G173_03)
        load ('solarSpectra_AM0_AM15_ASTM_G173_03.mat','solarSpectra');
        ASTM_G173_03 = solarSpectra;
        load ('solarSpectrum_AM0_ASTM_E_490.mat','AM0_ASTM_E_490');
        ASTM_E_490 = AM0_ASTM_E_490;
    end
    if strcmp(type, 'AM0_ASTM_E490')
        rv = ASTM_E_490;
    elseif strcmp(type, 'AM0')
        rv.lam = ASTM_G173_03.lam;
        rv.val = ASTM_G173_03.extraterrestrial;
        rv.name = 'ASTM G173-03 AM0 extraterrestrial irradiance, [W/(m^2 nm)]';
    elseif strcmp(type, 'AM15_GlobalTilt')
        rv.lam = ASTM_G173_03.lam;
        rv.val = ASTM_G173_03.globalTilt_AM1_5;
        rv.name = 'ASTM G173-03 AM1.5 global tilted irradiance, [W/(m^2 nm)]';
    elseif strcmp(type, 'AM15_Direct_Circumsolar')
        rv.lam = ASTM_G173_03.lam;
        rv.val = ASTM_G173_03.directCircumsolar_AM1_5;
        rv.name = 'ASTM G173-03 AM1.5 direct + circumsolar irradiance, [W/(m^2 nm)]';
    else
        error('SolarSpectrum: unknown typs: %s', type);
    end
end