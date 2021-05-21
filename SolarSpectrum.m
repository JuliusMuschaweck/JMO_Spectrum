%% SolarSpectrum
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