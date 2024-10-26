%% JMOSpectrumPath
% 
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp; 
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp;
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp; 
% <a href="GroupedList.html"> Grouped list</a> &nbsp; | &nbsp; 
% Source code: <a href = "file:../CIEDE2000_Lab.m"> CIEDE2000_Lab.m</a>
% </p>
% </html>
%
% Returns the path to the JMO Spectrum Library main folder. Utility
% function to make |addpath| to library subdirectories portable.
%% Syntax
% |rv = JMOSpectrumPath()|
%% Input Arguments
% None
%% Output Arguments
% * |rv|: String, contains the path without trailing backslash.
%% Algorithm
% Uses the built-in |which| and |fileparts| functions.
%% See also
% <OpenJMOSpectrumHelp.html OpenJMOSpectrumHelp>

% publish with publishWithStandardExample('filename.m') in PublishDocumentation.m

% JMO Spectrum Library, 2021. See https://github.com/JuliusMuschaweck/JMO_Spectrum
% I dedicate the JMO_Spectrum library to the public domain under Creative Commons Zero 
% (https://creativecommons.org/publicdomain/zero/1.0/legalcode)
%

function rv = JMOSpectrumPath()
    tmp = which("JMOSpectrumPath.m");
    rv = string(fileparts(tmp));
end