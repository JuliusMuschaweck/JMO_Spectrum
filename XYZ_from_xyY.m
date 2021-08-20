%% XYZ_from_xyY
% 
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp; 
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp;
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp; 
% <a href="GroupedList.html"> Grouped list</a> &nbsp; | &nbsp; 
% Source code: <a href = "file:../XYZ_from_xyY.m"> XYZ_from_xyY.m</a>
% </p>
% </html>
%
% Simple convenience function to create complete XYZ information from xy color coordinates
% and flux
%% Syntax
% |rv = XYZ_from_xyY(x, y, Y)|
%
%% Input Arguments
% * |x|: any array of double. CIE 1931 x color coordinate(s)
% * |y|: any array of double, same size. CIE 1931 y color coordinate(s)
% * |Y|: any array of double, same size. CIE 1931 Y tristimulus value
%
%% Output Arguments
% * |rv|: struct with fields |x|, |y|, (copies of input), |z == 1 - x - y|, |cw| (the color
% weight(s)), and |X|, |Y|, |Z| tristimulus values. Identical structure as the output of
% <CIE1931_XYZ.html CIE1931_XYZ>.
%% Algorithm
% Applies the generic formulas.
%% See also
% <CIE1931_XYZ.html CIE1931_XYZ>
%% Usage Example
% <include>Examples/ExampleXYZ_from_xyY.m</include>

% publish with publishWithStandardExample('filename.m') in PublishDocumentation.m

% JMO Spectrum Library, 2021. See https://github.com/JuliusMuschaweck/JMO_Spectrum
% I dedicate the JMO_Spectrum library to the public domain under Creative Commons Zero 
% (https://creativecommons.org/publicdomain/zero/1.0/legalcode)
%%
function rv = XYZ_from_xyY(x, y, Y)
    rv.cw = Y./y;
    rv.x = x;
    rv.y = y;
    rv.z = 1 - x - y;
    rv.X = x .* rv.cw;
    rv.Y = Y;
    rv.Z = rv.z .* rv.cw;
end