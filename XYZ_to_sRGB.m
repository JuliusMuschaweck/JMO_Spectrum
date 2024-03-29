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
% Computes sRGB display drive values from desired XYZ tristimulus values
%% Syntax
% |rv = XYZ_to_sRGB(X, Y, Z, opts)
%
%% Input Arguments
% * |X|: scalar, vector or matrix of double. The tristimulus X values. When |Y| and |Z| are not
% given, |X| may also be a n x 3 matrix, interpreted as an RGB triplet in each row, or a
% struct with fields |X.X|, |X.Y|, |X.Z| which must be numeric arrays of same size
% * |Y|: Optional scalar, vector or matrix of double, same number of elements as |X|. The tristimulus Y values.
% * |Z|: Optional scalar, vector or matrix of double, same number of elements as |X|. The
% tristimulus Z values. When |Y| is givenm |Z| must also be given.
% * |opts|: Optional name-value pair: |'clip'|, logical scalar. Default is false, which may
% lead to negative sRGB values when the XYZ color point is outside the sRGB color gamut. When
% true, negative values and values > 1 are clipped to [0;1]
%% Output Arguments
% * |rv|: struct with fields |R|, |G|, |B|, same size as |X|, and |RGB|, an nx3 matrix
% with one sRGB triplet per row, and |RGBlin|, the corresponding linear RGB values, before
% gamma is applied.
%% Algorithm
% The sRGB standard, IEC 61966-2-1:1999, including Amendment 1, describes how desired XYZ tristimulus values on the display shall be
% created from sRGB values to encode color and brightness. See also 
% <https://en.wikipedia.org/wiki/SRGB https://en.wikipedia.org/wiki/SRGB> for a detailed
% description. First, the XYZ tristimulus values are converted to "linear RGB" values, by multiplying with the matrix M
% specified in the standard. Then, gamma correction is applied to each individual linear R, G or B value: For small absolute values, the correction is linear, for
% larger absolute values, the correction is a power law. See the standard for details. At this stage, RGB values may be
% negative or larger than 1. When the |'clip'| option is set to |true|, RGB values outside the |[0,1]| interval are clipped. 
% A value of |RGB == [1, 1, 1]| is obtained for 100% D65 white, with |XYZ == [0.9505, 1.0000, 1.0890]|. Input XYZ values
% should be scaled accordingly, to obtain RGB values within |[0,1]|.
%% See also
% <sRGB_to_XYZ.html sRGB_to_XYZ>
%% Usage Example
% <include>Examples/ExampleXYZ_to_sRGB.m</include>
function rv = XYZ_to_sRGB(X, Y, Z, opts)
    arguments
        X (:,:) 
        Y (:,:) double = nan
        Z (:,:) double = nan
        opts.clip (1,1) logical = false
    end
    if isscalar(Y) && isnan(Y) % Y missing - X must be 
        % a n x 3 matrix, to be interpreted as one RGB triplet per row, or
        % a struct with fields X, Y, Z which must be double arrays of same size
        if isnumeric(X)
            assert(size(X,2) == 3,'XYZ_to_sRGB: When single argument X is given and it is an array, it must have size n x 3');
            XYZ = X;
            sz = size(X(:,1));
        else
            assert(isstruct(X) && isfield(X,'X') && isfield(X,'Y') && isfield(X,'Z') ,...
                'XYZ_to_sRGB: non-numeric single argument X must be a struct with fields X, Y, and Z');
            assert(isnumeric(X.X) && isnumeric(X.Y) && isnumeric(X.Y) && ...
                isequal(size(X.X), size(X.Y) ,size(X.Z)),'XYZ_to_sRGB: X.X, X.Y and X.Z must be numeric arrays with same size');
            XYZ = cat(2,X.X(:),X.Y(:),X.Z(:)); % n x 3
            sz = size(X.X);
        end
    else % X must a double matrix, and Y and Z must be same size
        assert(~any(isnan(Z(:))),'XYZ_to_sRGB: Z must be given when Y is given');
        assert(isnumeric(X),'XYZ_to_sRGB: When Y is given, X must be numeric array');
        assert(isequal(size(X), size(Y), size(Z)),'XYZ_to_sRGB: X, Y, Z must have same size');
        XYZ = cat(2,X(:),Y(:),Z(:)); % n x 3
        sz = size(X);
    end
    % See https://en.wikipedia.org/wiki/SRGB
    % X, Y, Z may be arrays of equal size. Must be scaled such that
    % X,Y,Z of D65 white is (X, Y, Z = 0.9505, 1.0000, 1.0890)
    % rv has fields R, G, B which are scalars or arrays of same size
    % and field RGB which is a nx3 array of R,G,B values
                % sz = size(X);
                % XYZ = cat(2,X(:),Y(:),Z(:)); % n x 3
    M = [ 3.2406255, -1.5372080, -0.4986286;
         -0.9689307,  1.8757561,  0.0415175;
          0.0557101, -0.2040211,  1.0569959];
    RGBlin = M * XYZ'; % 3 x n
    
    % apply gamma
    sRGB = Gamma(RGBlin); % 3 x n
    sRGB = sRGB'; % n x 3 again
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
    rv.R = reshape(sRGB(:,1),sz);
    rv.G = reshape(sRGB(:,2),sz);
    rv.B = reshape(sRGB(:,3),sz);
    rv.RGB = sRGB;
    rv.RGBlin = RGBlin';
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
