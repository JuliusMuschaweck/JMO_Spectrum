classdef TGammaRGBDisplay < TDisplay
    %TGammaRGBDisplay : A generic class which uses only a matrix and gamma
    % gamma, primaries and white point are the only parameters, like in the TLCI
    % standard, XYZ = M * RGB_C_prime .^gamma
    
    properties
        gamma
        M % the matrix
        whitePoint % struct with .x, .y, .RGB, .XYZ
    end
    
    methods
        function obj = TGammaRGBDisplay( gamma, M, whitePoint )
            % gamma double, M 3x3 double, whitePoint struct with .x .y or
            % 'D65'
            obj.gamma = gamma;
            obj.M = M;
            % compute whitePoint.XYZ and .RGB
            if isstruct(whitePoint)
                x = whitePoint.x;
                y = whitePoint.y;
            else
                assert(strcmp(whitePoint,'D65'));
                x = 0.3127; % EBU Tech 3355
                y = 0.3290;
            end
            tmpXYZ = [x; y; 1 - x - y]; % not yet normalized
            tmpRGB = (M \ tmpXYZ) .^ (1/gamma); % inverse calculation of RGB
            RGB = tmpRGB / max(tmpRGB); % normalize to max(RGB) == 1;
            XYZ = M * (RGB .^ gamma); % calculate XYZ response
            xytest = XYZ(1:2) / sum(XYZ);
            assert(norm([x;y] - xytest) < 1e-12);
            obj.whitePoint = struct;
            obj.whitePoint.RGB = RGB;
            obj.whitePoint.XYZ = XYZ;
        end
        
        function XYZ = Response(obj, RGB_C_prime)
            iRGB = RGB_C_prime.RGB;
            XYZ = obj.M * (iRGB .^ obj.gamma);
        end
    end
end

