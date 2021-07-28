%% IsOctave
% 
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp; 
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp;
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp; 
% <a href="GroupedList.html"> Grouped list</a> &nbsp; | &nbsp; 
% Source code: <a href = "file:../IsOctave.m"> IsOctave.m</a>
% </p>
% </html>
%
% Determines if program is running under GNU Octave
%% Syntax
% |rv = IsOctave()|
%% Description
% This library is not generally supporting GNU Octave as a Matlab replacement. In particular, the |arguments| syntax (missing in Octave) is
% just too attractive to avoid. However, <LinInterpol.html LinInterpol>, a routine at the very core of this library,
% which is using a C++ DLL under Matlab to greatly speed up the ubiquitous linear spectrum interpolation, uses
% |IsOctave| to reroute the DLL call to the builtin |interp1| function.
%% Output Arguments
% * |rv|: scalar logical, with obvious meaning
%% Algorithm
% Checks if there is a builtin script named |OCTAVE_VERSION|

% publish with publishWithStandardExample('filename.m') in PublishDocumentation.m

% JMO Spectrum Library, 2021. See https://github.com/JuliusMuschaweck/JMO_Spectrum
% I dedicate the JMO_Spectrum library to the public domain under Creative Commons Zero 
% (https://creativecommons.org/publicdomain/zero/1.0/legalcode)
%
function rv = IsOctave()
% function rv = IsOctave() determines if program is running under GNU Octave
persistent x;
  if (isempty (x))
    x = (exist ('OCTAVE_VERSION', 'builtin') == 5);
  end
  rv = x;
end