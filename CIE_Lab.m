%% CIE_Lab
% 
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp; 
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp;
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp; 
% <a href="GroupedList.html"> Grouped list</a> &nbsp; | &nbsp; 
% Source code: <a href = "file:../CIE_Lab.m"> CIE_Lab.m</a>
% </p>
% </html>
%
% Computes CIELAB L*, a*, b* values from XYZ tristimulus values
%% Syntax
% |rv = CIE_Lab(XYZ, XYZn)|
%% Input Arguments
% * |XYZ|: A |struct| with scalar real fields |X|, |Y|, |Z|: the tristimulus values for which Lab values shall be computed
% * |XYZn|: A |struct| with scalar real fields |X|, |Y|, |Z|: the tristimulus values of the "reference white": the
% brightest diffuse white in the scene from which |XYZ| is taken
%% Output Arguments
% * |rv|: A |struct| with scalar real fields |L|, |a| and |b|. |L| is the lightness, which should be between 0 (totally
% black) and 100 (the reference white). |a > 0| for reddish, |a < 0| for greenish hues, and |b > 0| for yellowish, |b <
% 0| for bluish hues.
%% Algorithm
% Applies the CIELAB formulas (8.3) to (8.11) according to section 8.2.1. of CIE 015:2018 
%% See also
% <CIE1931_XYZ.html CIE1931_XYZ>, <CIE_Luv.html CIE_Luv>, <CIE_upvp.html CIE_upvp>
%% Usage Example
% <include>Examples/ExampleCIE_Lab.m</include>

% publish with publishWithStandardExample('filename.m') in PublishDocumentation.m

% JMO Spectrum Library, 2021. See https://github.com/JuliusMuschaweck/JMO_Spectrum
% I dedicate the JMO_Spectrum library to the public domain under Creative Commons Zero 
% (https://creativecommons.org/publicdomain/zero/1.0/legalcode)
%

function rv = CIE_Lab(XYZ, XYZn)
    fX = f( XYZ.X /XYZn.X );
    fY = f( XYZ.Y /XYZn.Y );
    fZ = f( XYZ.Z /XYZn.Z );
    rv.L = 116 * fY - 16;
    rv.a = 500 * (fX - fY);
    rv.b = 200 * (fY - fZ);
end

function rv = f(rhs)
    if rhs > (24/116)^3
        rv = rhs^(1/3);
    else
        rv = 841 / 108 * rhs + 16 / 116;
    end
end