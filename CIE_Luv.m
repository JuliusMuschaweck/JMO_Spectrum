%% CIE_Luv
% 
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp; 
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp;
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp; 
% <a href="GroupedList.html"> Grouped list</a> &nbsp; | &nbsp; 
% Source code: <a href = "file:../CIE_Luv.m"> CIE_Luv.m</a>
% </p>
% </html>
%
% Computes CIELUV L*, u*, v* values from XYZ tristimulus values
%% Syntax
% |rv = CIE_Luv(XYZ, XYZn)|
%% Input Arguments
% * |XYZ|: A |struct| with scalar real fields |X|, |Y|, |Z|: the tristimulus values for which Luv values shall be computed
% * |XYZn|: A |struct| with scalar real fields |X|, |Y|, |Z|: the tristimulus values of the "reference white": the
% brightest diffuse white in the scene from which |XYZ| is taken
%% Output Arguments
% * |rv|: A |struct| with scalar real fields |L|, |u| and |v|. |L| is the lightness, which should be between 0 (totally
% black) and 100 (the reference white). |u| and |v| is 13 times the u'v' distance to the reference white.
%% Algorithm
% Applies the CIELuv formulas (8.26) to (8.30) according to section 8.2.2. of CIE 015:2018 
%% See also
% <CIE1931_XYZ.html CIE1931_XYZ>, <CIE_Lab.html CIE_Lab>, <CIE_upvp.html CIE_upvp>
%% Usage Example
% <include>Examples/ExampleCIE_Luv.m</include>

% publish with publishWithStandardExample('filename.m') in PublishDocumentation.m

% JMO Spectrum Library, 2021. See https://github.com/JuliusMuschaweck/JMO_Spectrum
% I dedicate the JMO_Spectrum library to the public domain under Creative Commons Zero 
% (https://creativecommons.org/publicdomain/zero/1.0/legalcode)
%
function rv = CIE_Luv(XYZ, XYZn)
    fY = f( XYZ.Y /XYZn.Y );
    XYZ.cw = XYZ.X + XYZ.Y + XYZ.Z;
    XYZ.x = XYZ.X / XYZ.cw;
    XYZ.y = XYZ.Y / XYZ.cw;
    XYZ = CIE_upvp(XYZ);
    XYZn.cw = XYZn.X + XYZn.Y + XYZn.Z;
    XYZn.x = XYZn.X / XYZn.cw;
    XYZn.y = XYZn.Y / XYZn.cw;
    XYZn = CIE_upvp(XYZn);
    
    rv.L = 116 * fY - 16;
    rv.u = 13 * rv.L * (XYZ.up - XYZn.up);
    rv.v = 13 * rv.L * (XYZ.vp - XYZn.vp);
end

function rv = f(rhs)
    if rhs > (24/116)^3
        rv = rhs^(1/3);
    else
        rv = 841 / 108 * rhs + 16 / 116;
    end
end