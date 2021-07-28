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
% * |xBorder, yBorder|: the coordinates of the monochromatic border 
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
    load('CIE1931_lam_x_y_z.mat');
    rv = CIE1931XYZ;
end