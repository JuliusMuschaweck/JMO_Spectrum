%% CCT
% 
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp; 
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp;
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp; 
% <a href="GroupedList.html"> Grouped list</a> &nbsp; | &nbsp; 
% Source code: <a href = "file:../CCT.m"> CCT.m</a>
% </p>
% </html>
%
% Computes the correlated color temperature (CCT) of a spectrum
%% Syntax
% |[iCCT, dist_uv, ok, errmsg] = CCT(spec)|
%% Input Arguments
% * |spec|: A valid spectrum (see <SpectrumSanityCheck.html SpectrumSanityCheck>)
%% Output Arguments
% * |iCCT|: scalar double. The correlated color temperature in Kelvin
% * |dist_uv|: scalar double. The distance to the Planck locus in uv coordinates. Negative when below Planck locus
% (towards magenta).
% * |ok|: When requested, function sets ok to false, sets iCCT and dist_uv to NaN in case of error instead of throwing
% error.
% * |errmsg|: Contains error and warning message(s)
%% Algorithm
% For a CIE 1931 xy color point, transform it to CIE 1960 uv coordinates, and then find the
% closest point on the Planck locus in CIE 1960 uv coordinates. The absolute temperature corresponding to the blackbody
% radiation that yields this point on the Planck locus is the CCT. See also the official CIE definition
% <https://cie.co.at/eilvterm/17-23-068>. 
%
% This function first computes xy color coordinates from the input spectrum, and then calls <CCT_from_xy.html
% CCT_from_xy> 
%% See also
% <CCT_from_xy.html
% CCT_from_xy>
%% Usage Example
% <include>Examples/ExampleCCT.m</include>

% publish with publishWithStandardExample('filename.m') in PublishDocumentation.m

% JMO Spectrum Library, 2021. See https://github.com/JuliusMuschaweck/JMO_Spectrum
% I dedicate the JMO_Spectrum library to the public domain under Creative Commons Zero 
% (https://creativecommons.org/publicdomain/zero/1.0/legalcode)
%
function [iCCT, dist_uv, ok, errmsg] = CCT(spec)
% computes CCT in the range of 1000K to 1000.000K with extreme precision
% dist_uv is the distance to the Planck locus in uv coordinates, should be
% less than 0.05 for valid CCT.
    if ~isfield(spec,'XYZ')
        XYZ = CIE1931_XYZ(spec);
    else
        if (isfield(spec.XYZ,'x') && isfield(spec.XYZ,'y'))
            XYZ = spec.XYZ;
        else
            XYZ = CIE1931_XYZ(spec);
        end
    end
    [iCCT, dist_uv, ok, errmsg] = CCT_from_xy(XYZ.x, XYZ.y);
end

