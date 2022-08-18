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
    load('CIE1964_lam_x_y_z.mat','CIE1964XYZ');
    rv = CIE1964XYZ;
end