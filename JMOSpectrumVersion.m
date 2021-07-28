%% JMOSpectrumVersion
% 
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp; 
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp;
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp; 
% <a href="GroupedList.html"> Grouped list</a> &nbsp; | &nbsp; 
% Source code: <a href = "file:../JMOSpectrumVersion.m"> JMOSpectrumVersion.m</a>
% </p>
% </html>
%
% Returns the version of this library
%% Syntax
% |rv = JMOSpectrumVersion()|
%% Output Arguments
% * |rv|: A |struct| with fields |major| and |minor|, both are nonnegative integers.
%% Usage Example
% <include>Examples/ExampleJMOSpectrumVersion.m</include>

% publish with publishWithStandardExample('filename.m') in PublishDocumentation.m

% JMO Spectrum Library, 2021. See https://github.com/JuliusMuschaweck/JMO_Spectrum
% I dedicate the JMO_Spectrum library to the public domain under Creative Commons Zero 
% (https://creativecommons.org/publicdomain/zero/1.0/legalcode)
%
function rv = JMOSpectrumVersion()
    rv.major = 2;
    rv.minor = 1;
end