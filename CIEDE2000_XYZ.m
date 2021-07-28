%% CIEDE2000_XYZ
% 
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp; 
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp;
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp; 
% <a href="GroupedList.html"> Grouped list</a>  &nbsp; | &nbsp; 
% Source code: <a href = "file:../CIEDE2000_XYZ.m"> CIEDE2000_XYZ.m</a>
% </p>
% </html>
%
% Compute the CIEDE2000 color difference between two XYZ stimuli.
%% Syntax
% |dE = CIEDE2000_XYZ( XYZ1, XYZ2, XYZn )|
%% Input Arguments
% * |XYZ1|: A |struct| with scalar real fields |X|, |Y| and |Z|, the first stimulus
% * |XYZ2|: A |struct| with scalar real fields |X|, |Y| and |Z|, the second stimulus
% * |XYZn|: A |struct| with scalar real fields |X|, |Y| and |Z|, the tristimulus values of the "reference white": the brightest diffuse white in the scene from which |XYZ1| aand |XYZ2| are taken
%% Output Arguments
% * |dE|: scalar double. The color difference. |dE == 1| is assumed to be just noticeable.
%% Algorithm
% Computes CIELAB Lab values for |XYZ1| and |XYZ2| using <CIE_Lab.html CIE_Lab>. (This is the step for which the reference white is needed). Then forwards to <CIEDE2000_Lab.html CIEDE2000_Lab> to do the actual work. 
%% See also
% <CIEDE2000_Lab.html CIEDE2000_XYZ> <CIE_Lab.html CIE_Lab>
%% Usage Example
% <include>Examples/ExampleCIEDE2000_XYZ.m</include>

% publish with publishWithStandardExample('filename.m') in PublishDocumentation.m

% JMO Spectrum Library, 2021. See https://github.com/JuliusMuschaweck/JMO_Spectrum
% I dedicate the JMO_Spectrum library to the public domain under Creative Commons Zero 
% (https://creativecommons.org/publicdomain/zero/1.0/legalcode)
%
function dE = CIEDE2000_XYZ( XYZ1, XYZ2, XYZn )
    dE = CIEDE2000_Lab(CIE_Lab(XYZ1, XYZn), CIE_Lab(XYZ2, XYZn));
end