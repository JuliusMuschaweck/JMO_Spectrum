%% sRGB_to_XYZ
%
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp; 
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp;
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp; 
% <a href="GroupedList.html"> Grouped list</a> &nbsp; | &nbsp; 
% Source code: <a href = "file:../sRGB_to_XYZ.m"> sRGB_to_XYZ.m</a>
% </p>
% </html>
%
% Computes XYZ tristimulus value of displayed color on ideal sRGB display
%% Syntax
% |rv = sRGB_to_XYZ(R, G, B)|
%
%% Input Arguments
% * |R|: scalar, vector or matrix of double. The red sRGB values. Negative values are
% allowed; they correspond to colors outside the sRGB gamut.
% * |G|: scalar, vector or matrix of double. The green sRGB values, must be same number of
% elements as R
% * |B|: scalar, vector or matrix of double. The blue sRGB values, must be same number of
% elements as R
%% Output Arguments
% * |rv|: struct with fields |X| , |Y|, |Z|, |x|,|y|, |z| (the tristimulus X, Y, Z values and
% color coordinates x, y, z, all same size as input argument |R|), and |XYZ|, an |(n, 3)|
% matrix, where |n| is the number of elements of input argument |R|, containing one XYZ value
% per row.
%% Algorithm
% The sRGB standard, IEC 61966-2-1:1999, including Amendment 1, describes how desired XYZ tristimulus values on the display shall be
% created from sRGB values to encode color and brightness. See also 
% <https://en.wikipedia.org/wiki/SRGB https://en.wikipedia.org/wiki/SRGB> for a detailed
% description. sRGB values are "gamma corrected": the first step is therefore to remove the
% gamma correction. For small values, gamma correction is linear, for large absolute values,
% it is a power function with $\gamma = 2.4$. To cope with negative values, gamma correction
% f(X) is applied as -f(-X). After removing gamma correction, the result is known as "linear
% RGB": the amounts of the sRGB red, green and blue primaries. In step 2, linear RGB is
% converted to $XYZ = M \times RGB$ with the matrix M derived from standardized primaries'
% tristimulus values. A display white point corresponding to D65 is assumed.
%% See also
% <XYZ_to_sRGB.html XYZ_to_sRGB>
%% Usage Example
% <include>Examples/ExamplesRGB_to_XYZ.m</include>

% publish with publishWithStandardExample('filename.m') in PublishDocumentation.m

% JMO Spectrum Library, 2021. See https://github.com/JuliusMuschaweck/JMO_Spectrum
% I dedicate the JMO_Spectrum library to the public domain under Creative Commons Zero 
% (https://creativecommons.org/publicdomain/zero/1.0/legalcode)
%
function rv = sRGB_to_XYZ(R, G, B)
    arguments
        R (:,:) double
        G (:,:) double
        B (:,:) double
    end
    RGB = cat(2,R(:),G(:),B(:)); % n x 3
    negative = (RGB < (- 0.04045));
    positive = (RGB > (+ 0.04045));
    small = ~(negative | positive);
    RGBlin = NaN(size(RGB));
    RGBlin(small) = 25 * RGB(small) / 323;
    RGBlin(positive) = ((200 * RGB(positive) + 11) / 211) .^ 2.4; 
    RGBlin(negative) = - ((- 200 * RGB(negative) + 11) / 211) .^ 2.4; 
    
    M = [0.4124, 0.3576, 0.1805;
         0.2126, 0.7152, 0.0722;
         0.0193, 0.1192, 0.9505];
    XYZ = M * RGBlin'; % 3 x n

    rv.X = XYZ(1,:);
    rv.Y = XYZ(2,:);
    rv.Z = XYZ(3,:);
    rv.XYZ = XYZ';
    cw = sum(XYZ);
    sz = size(R);
    rv.X = reshape(rv.X,sz);
    rv.Y = reshape(rv.Y,sz);
    rv.Z = reshape(rv.Z,sz);
    rv.x = rv.X ./ cw;
    rv.y = rv.Y ./ cw;
    rv.z = rv.Z ./ cw;
    
end



%     M = [ 3.2406255, -1.5372080, -0.4986286;
%          -0.9689307,  1.8757561,  0.0415175;
%           0.0557101, -0.2040211,  1.0569959];
%     iM = inv(M); % then copy paste
%     iM = [0.412399997173099,0.357600002651009,0.180500014352339;
%           0.212599990736123,0.715199984234609,0.0722000155301504;
%           0.0193000170459133,0.119200041926217,0.950500047104164];
