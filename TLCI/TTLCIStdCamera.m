classdef TTLCIStdCamera < TMatrixGammaCamera
    % TTLCIStdCamera: the standard TLCI camera
    
    methods
        function obj = TTLCIStdCamera()
            load('TLCICamera.mat','TLCICamera');
            rS.lam = TLCICamera.lam;
            rS.val = TLCICamera.r;
            gS.lam = TLCICamera.lam;
            gS.val = TLCICamera.g;
            bS.lam = TLCICamera.lam;
            bS.val = TLCICamera.b;
            M = [1.182, -0.209, 0.027;...
                 0.107, 0.890, 0.003;...
                 0.040, -0.134, 1.094];
            obj@TMatrixGammaCamera(rS, gS, bS, M);
            obj.cameraname = 'TLCI standard camera';
        end
        
        function X_C_prime = Gamma(obj, X_B)
            if X_B <= 0
                X_B = 0;
            end
            if X_B < 0.018
                X_C_prime = 4.5 * X_B;
            else
%                X_C_prime = 1.099  * (X_B ^ 0.45);
%               error in EBU_tech3355 eq (28)
%               see R-REC-BT.709, p. 3, item 1.2
                X_C_prime = 1.099  * (X_B ^ 0.45) - 0.099;
            end
        end
        
        function RGB_B = SaturationControl(obj, RGB_M) % 
            m_03 = 1.0 / 30;
            m_93 = 1 - 2 * m_03;
            A = [m_93, m_03, m_03; ...
                m_03, m_93, m_03;...
                m_03, m_03, m_93];
            RGB_B = A * RGB_M;
                
        end
    end
end

