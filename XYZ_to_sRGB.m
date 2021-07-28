%% XYZ_to_sRGB
% 
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp; 
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp;
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp; 
% <a href="GroupedList.html"> Grouped list</a> &nbsp; | &nbsp; 
% Source code: <a href = "file:../XYZ_to_sRGB.m"> XYZ_to_sRGB.m</a>
% </p>
% </html>
%
% documentation to be completed
function rv = XYZ_to_sRGB(X, Y, Z, opts)
    arguments
        X (:,:) double
        Y (:,:) double
        Z (:,:) double
        opts.clip (1,1) logical = false
    end
    % See https://en.wikipedia.org/wiki/SRGB
    % X, Y, Z may be arrays of equal size. Must be scaled such that
    % X,Y,Z of D65 white is (X, Y, Z = 0.9505, 1.0000, 1.0890)
    % rv has fields R, G, B which are scalars or arrays of same size
    % and field RGB which is a nx3 array of R,G,B values
    XYZ = cat(2,X(:),Y(:),Z(:)); % n x 3
    M = [ 3.2406255, -1.5372080, -0.4986286;
         -0.9689307,  1.8757561,  0.0415175;
          0.0557101, -0.2040211,  1.0569959];
    RGBlin = M * XYZ'; % 3 x n
    
    % apply gamma
    sRGB = Gamma(RGBlin);
    % clip
    if opts.clip
        lt0 = (sRGB < 0);
        gt1 = (sRGB > 1);
        sRGB(lt0) = 0;
        sRGB(gt1) = 1;
        rv.clipped = any(lt0,'all') || any(gt1,'all');
    else
        rv.clipped = false;
    end
    rv.R = sRGB(1,:);
    rv.G = sRGB(2,:);
    rv.B = sRGB(3,:);
    rv.RGB = sRGB';
end

function X_C_prime = Gamma(X_B)
    X_C_prime = NaN(size(X_B));
    negative = (X_B < (-0.0031308));
    positive = (X_B > 0.0031308);
    small = ~(negative | positive);
    X_C_prime(small) = 323/25 * X_B(small);
    X_C_prime(positive) = (211 * X_B(positive).^(5/12) - 11) / 200 ;
    X_C_prime(negative) = - (211 * ((-X_B(negative)).^(5/12)) - 11) / 200 ;
end
