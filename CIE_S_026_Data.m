%% CIE_S_026_Data
% 
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp; 
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp;
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp; 
% <a href="GroupedList.html"> Grouped list</a> &nbsp; | &nbsp; 
% Source code: <a href = "file:../CIE_S_026_Data.m"> CIE_S_026_Data.m</a>
% </p>
% </html>
%
% Returns |struct| with the five human eye sensitivity spectra according to CIE S 026
%% Syntax
% |rv = CIE_S_026_Data()|
%% Input Arguments
% none
%% Output Arguments
% |rv|: struct with fields:
% 
% * |S_cone_opic_sensitivity|: sensitivity spectrum of S (blue) cones
% * |M_cone_opic_sensitivity|: sensitivity spectrum of M (green) cones
% * |L_cone_opic_sensitivity|: sensitivity spectrum of L (red) cones
% * |rhodopic_sensitivity|: sensitivity spectrum of rods (for night vision)
% * |melanopic_sensitivity|: sensitivity spectrum of melanopic ipRGC cells (day/night)

%% Algorithm
% Retrieves the data stored in |CIES026_lam_S_M_L_r_m.mat|
%% See also
% (not yet implemented)
% <CIE1964_XYZ.html CIE1964_XYZ>, <PlotCIExyBorder.html PlotCIExyBorder>
%% Usage Example
% <include>Examples/ExampleCIE_S_026_Data.m</include>

% publish with publishWithStandardExample('filename.m') in PublishDocumentation.m

% JMO Spectrum Library, 2021. See https://github.com/JuliusMuschaweck/JMO_Spectrum
% I dedicate the JMO_Spectrum library to the public domain under Creative Commons Zero 
% (https://creativecommons.org/publicdomain/zero/1.0/legalcode)
%

function rv = CIE_S_026_Data()
    load('CIES026_lam_S_M_L_r_m.mat','CIES026');
    rv = CIES026;
end