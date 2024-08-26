%% CIE1931_Data
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
% Returns |struct| with CIE 1931 color matching functions, monochromatic border and Planck locus
%% Syntax
% |rv = CIE1931_Data()|
%% Input Arguments
% none
%% Output Arguments
% |rv|: struct with fields:
% 
% * |lam|:  360:830 in 1 nm
% * |x, y, z|: the color matching functions
% * |xBorder, yBorder, zBorder|: the coordinates of the monochromatic border 
% * |PlanckT, Planckx, Plancky|: temperature, x and y coordinates of the Planck locus
%% Algorithm
% Retrieves the data stored in |CIE1931_lam_x_y_z.mat|
%% See also
% <CIE1931_XYZ.html CIE1931_XYZ>, <PlotCIExyBorder.html PlotCIExyBorder>
%% Usage Example
% <include>Examples/ExampleCIE1931_Data.m</include>

% publish with publishWithStandardExample('filename.m') in PublishDocumentation.m

% JMO Spectrum Library, 2021. See https://github.com/JuliusMuschaweck/JMO_Spectrum
% I dedicate the JMO_Spectrum library to the public domain under Creative Commons Zero 
% (https://creativecommons.org/publicdomain/zero/1.0/legalcode)
%

function rv = CIE1931_Data()
    persistent irv;
    if isempty(irv)
        % 21.8.2024 JM: New official CIE data
        cie = CIEData();
        irv.lam = cie.Column_by_Idx("CIE1931_xyz",1);
        irv.x = cie.Column_by_Idx("CIE1931_xyz",2);
        irv.y = cie.Column_by_Idx("CIE1931_xyz",3);
        irv.z = cie.Column_by_Idx("CIE1931_xyz",4);
        border_lam = cie.Column_by_Idx("CIE1931_border",1);
        if ~isequal(border_lam,irv.lam)
            error('CIE1931_Data: Inconsistent wavelength arrays');
        end
        irv.xBorder = cie.Column_by_Idx("CIE1931_border",2);
        irv.yBorder = cie.Column_by_Idx("CIE1931_border",3);
        irv.zBorder = cie.Column_by_Idx("CIE1931_border",4);
        pl = PlanckLocus();
        irv.PlanckT = pl.T;
        irv.Planckx = pl.x;
        irv.Plancky = pl.y;

        % before 21.8.24
        % load('CIE1931_lam_x_y_z.mat');
        %irv = CIE1931XYZ;
    end
    rv = irv;
end