%% RainbowColorMap
% 
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp; 
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp;
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp; 
% <a href="GroupedList.html"> Grouped list</a> &nbsp; | &nbsp; 
% Source code: <a href = "file:../RainbowColorMap.m"> RainbowColorMap.m</a>
% </p>
% </html>
%
% A rainbow color map to be used with Matlab's 'colormap' function
%% Syntax
% |rv = RainbowColorMap(nn)|
%% Input Arguments
% * |nn|: scalar positive integer. Number of colors in map, 256 is a good value in many
% cases.
%% Output Arguments
% * |rv|: double array, size |(nn,3)|. The color map.
%% Usage Example
% <include>Examples/ExampleRainbowColorMap.m</include>

% publish with publishWithStandardExample('filename.m') in PublishDocumentation.m

% JMO Spectrum Library, 2021. See https://github.com/JuliusMuschaweck/JMO_Spectrum
% I dedicate the JMO_Spectrum library to the public domain under Creative Commons Zero 
% (https://creativecommons.org/publicdomain/zero/1.0/legalcode)
%
function rv = RainbowColorMap(nn)
% RainbowColorMap(nn) returns a rainbow colormap with nn columns (256 is good)
% nn = 256;
mymap = zeros(nn,3);
ww = round(0.56*nn);
ww2 = round(ww/2);
gamma = 3;
for i = 1:ww
    cB = round(0.25 * nn);
    cG = round(nn/2);
    cR = round(0.75 * nn);
    iR = i + cR - ww2;
    iG = i + cG - ww2;
    iB = i + cB - ww2;
    vv = (sin(i * pi/ww))^2;
    vv = vv ^(1/gamma);
    if iR > 0 && iR <= nn
        mymap(iR,1) = vv;
    end
    if iG > 0 && iG <= nn
        mymap(iG,2) = vv;
    end
    if iB > 0 && iB <= nn
        mymap(iB,3) = vv;
    end
end

rv = mymap;

end