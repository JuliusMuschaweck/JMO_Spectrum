classdef TRGBFilterCamera < TCamera
    % TRGBFilterCamera: most cameras use three filters
    % is still an abstract class: Response is not implemented
    properties
        rSensitivity % lam, val
        gSensitivity
        bSensitivity
        whiteBalance % fields r, g, b to be multiplied with SensorResponse
    end
    
    methods
        function obj = TRGBFilterCamera(rS, gS, bS)
            if nargin == 0
                lam = [400,500,600,700];
                obj.rSensitivity.lam = lam;
                obj.rSensitivity.val = [0,0,1,1];
                obj.gSensitivity.lam = lam;
                obj.gSensitivity.val = [0,1,1,0];
                obj.bSensitivity.lam = lam;
                obj.bSensitivity.val = [1,1,0,0];
            else
                obj.rSensitivity = rS;
                obj.gSensitivity = gS;
                obj.bSensitivity = bS;
            end
            obj.whiteBalance.r = 1;
            obj.whiteBalance.g = 1;
            obj.whiteBalance.b = 1;
            obj.cameraname = 'abstract TRGBFilterCamera';
        end
        
        function naked = SensorResponse(obj, spectrum)
            R = IntegrateSpectrum(obj.rSensitivity, spectrum) ;
            G = IntegrateSpectrum(obj.gSensitivity, spectrum) ;
            B = IntegrateSpectrum(obj.bSensitivity, spectrum) ;
            naked.R = IntegrateSpectrum(obj.rSensitivity, spectrum) ;
            naked.G = IntegrateSpectrum(obj.gSensitivity, spectrum) ;
            naked.B = IntegrateSpectrum(obj.bSensitivity, spectrum) ;
%             R = IntegrateProductSpectra(obj.rSensitivity, spectrum) ;
%             G = IntegrateProductSpectra(obj.gSensitivity, spectrum) ;
%             B = IntegrateProductSpectra(obj.bSensitivity, spectrum) ;
%             naked.R = IntegrateProductSpectra_Regine(obj.rSensitivity, spectrum) ;
%             naked.G = IntegrateProductSpectra_Regine(obj.gSensitivity, spectrum) ;
%             naked.B = IntegrateProductSpectra_Regine(obj.bSensitivity, spectrum) ;
            
            naked.RGB = [naked.R; naked.G; naked.B];
        end
        
        function RGB_C = WhiteBalancedResponse(obj, spectrum)
            % default implementation: just multiply 
            naked = obj.SensorResponse(spectrum);
            tt.R = naked.R  * obj.whiteBalance.r;
            tt.G = naked.G  * obj.whiteBalance.g;
            tt.B = naked.B  * obj.whiteBalance.b;
            tt.RGB = [tt.R; tt.G; tt.B];
            RGB_C = tt;
        end

        function obj = WhiteBalance(obj, spectrum)
            test = obj.SensorResponse(spectrum);
            obj.whiteBalance.r = 1 / test.R;
            obj.whiteBalance.g = 1 / test.G;
            obj.whiteBalance.b = 1 / test.B;            
        end

    end
end

