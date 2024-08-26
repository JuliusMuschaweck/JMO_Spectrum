%% CIE1964_Data
% 
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp; 
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp;
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp; 
% <a href="GroupedList.html"> Grouped list</a> &nbsp; | &nbsp; 
% Source code: <a href = "file:../CIE1931_Data.m"> CIE1931_Data.m</a>
% </p>
% </html>
%
% Returns |struct| with CIE 1964 (10 degree) color matching functions, and monochromatic border
%% Syntax
% |rv = CIE1964_Data()|
%% Input Arguments
% none
%% Output Arguments
% |rv|: struct with fields:
% 
% * |lam|:  360:830 in 1 nm
% * |x, y, z|: the color matching functions
% * |xBorder, yBorder, zBorder|: the coordinates of the monochromatic border 
%% Algorithm
% Retrieves the data stored in |CIE1964_lam_x_y_z.mat|
%% See also
% (not yet implemented)
% <CIE1964_XYZ.html CIE1964_XYZ>, <PlotCIExyBorder.html PlotCIExyBorder>
%% Usage Example
% <include>Examples/ExampleCIE1964_Data.m</include>

% publish with publishWithStandardExample('filename.m') in PublishDocumentation.m

% JMO Spectrum Library, 2021. See https://github.com/JuliusMuschaweck/JMO_Spectrum
% I dedicate the JMO_Spectrum library to the public domain under Creative Commons Zero 
% (https://creativecommons.org/publicdomain/zero/1.0/legalcode)
%

function rv = CIE1964_Data()
    % 21.8.2024 JM: New official CIE data
    persistent irv;
    if isempty(irv)
        cie = CIEData();
        irv.lam = cie.Column_by_Idx("CIE1964_xyz",1);
        irv.x = cie.Column_by_Idx("CIE1964_xyz",2);
        irv.y = cie.Column_by_Idx("CIE1964_xyz",3);
        irv.z = cie.Column_by_Idx("CIE1964_xyz",4);
        border_lam = cie.Column_by_Idx("CIE1964_border",1);
        if ~isequal(border_lam,irv.lam)
            error('CIE1964_Data: Inconsistent wavelength arrays');
        end
        irv.xBorder = cie.Column_by_Idx("CIE1964_border",2);
        irv.yBorder = cie.Column_by_Idx("CIE1964_border",3);
        irv.zBorder = cie.Column_by_Idx("CIE1964_border",4);
    end
    rv = irv;
    % before 21.8.24
    % load('CIE1964_lam_x_y_z.mat','CIE1964XYZ');
    % rv = CIE1964XYZ;
end