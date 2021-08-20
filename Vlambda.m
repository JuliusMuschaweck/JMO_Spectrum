%% Vlambda
% 
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp; 
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp;
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp; 
% <a href="GroupedList.html"> Grouped list</a> &nbsp; | &nbsp; 
% Source code: <a href = "file:../Vlambda.m"> Vlambda.m</a>
% </p>
% </html>
%
% returns spectrum (fields lam and val) for Vlambda with |lam == 360:830|
%% Syntax
% |rv = Vlambda()|
%
%% Input Arguments
%
% none
%
%% Output Arguments
% * |rv|: spectrum struct, with |rv.lam == 360:830| and |rv.val| the standardized
% V(lambda) values, and an appropriate |rv.name| field.
%% Algorithm
% Calls <CIE1931_Data.html CIE1931_Data> to retrieve V(lambda) as the y color matching
% function and returns it.
%% See also
% <CIE1931_Data.html CIE1931_Data> <CIE1931_XYZ.html CIE1931_XYZ>
%% Usage Example
% <include>Examples/ExampleVlambda.m</include>

% publish with publishWithStandardExample('filename.m') in PublishDocumentation.m

% JMO Spectrum Library, 2021. See https://github.com/JuliusMuschaweck/JMO_Spectrum
% I dedicate the JMO_Spectrum library to the public domain under Creative Commons Zero 
% (https://creativecommons.org/publicdomain/zero/1.0/legalcode)
%
function rv = Vlambda()
    iXYZ = CIE1931_Data();
    rv.lam = iXYZ.lam;
    rv.val = iXYZ.y;
    rv.name = 'V(lambda)';
end