classdef TMatrixGammaCamera <TRGBFilterCamera
    %TMatrixGammaCamera: 
    % The kind TLCI uses, with sensitivity, constant matrix, gamma,
    % and saturation control
    
    properties
        M  % the matrix
    end
    
    methods (Abstract)
        X_C_prime = Gamma(obj, X_B) % abstract
        RGB_B = SaturationControl(obj, RGB_M) % abstract, both are (3,1) vectors
    end
    
    methods
        function obj = TMatrixGammaCamera(rS, gS, bS, M)
            if nargin == 0
                superArgs = {};
                MM = eye(3);
            else
                superArgs = {rS, gS, bS};
                MM = M;
            end                
            obj@TRGBFilterCamera(superArgs{:});
            obj.M = MM;
            obj.cameraname = 'abstract TMatrixGammaCamera';
        end

        function RGB_C_prime = Response(obj, spectrum)
            RGB_C_prime = struct;
            RGB_C = obj.WhiteBalancedResponse(spectrum);
            %% Regine: check clipping before applying M
            [RGB_C, sensorClipped] = obj.Clip(RGB_C);
            RGB_M = obj.M * RGB_C.RGB;            
            RGB_B = obj.SaturationControl(RGB_M);
            iRGB = [obj.Gamma(RGB_B(1));obj.Gamma(RGB_B(2));obj.Gamma(RGB_B(3))];
            %% Regine: check clipping again for display
            RGB_C_prime.R = iRGB(1);
            RGB_C_prime.G = iRGB(2);
            RGB_C_prime.B = iRGB(3);
            RGB_C_prime.RGB = iRGB;            
            [RGB_C_prime, displayClipped] = obj.Clip(RGB_C_prime);
            RGB_C_prime.clipped = sensorClipped || displayClipped;
        end
        
        function [RGB, clipped] = Clip(obj, RGBin)
            RGB.R = min(RGBin.R,1);
            RGB.G = min(RGBin.G,1);
            RGB.B = min(RGBin.B,1);
            RGB.R = max(RGBin.R,0);
            RGB.G = max(RGBin.G,0);
            RGB.B = max(RGBin.B,0);
            RGB.RGB = [RGB.R; RGB.G; RGB.B];
            clipped = ~ (RGB.R == RGBin.R) && (RGB.G == RGBin.G) && (RGB.B == RGBin.B);
        end
    end
end

