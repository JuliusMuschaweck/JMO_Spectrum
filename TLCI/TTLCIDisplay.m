classdef TTLCIDisplay < TGammaRGBDisplay
    %TTLCIDisplay the standard TLCI values for Gamma and Matrix
    %   Detailed explanation goes here
    
    
    methods
        function obj = TTLCIDisplay()
            gamma = 2.4; 
            M = [0.412391, 0.357584, 0.180481;...
                 0.212639, 0.715169, 0.072192;...
                 0.019331, 0.119195, 0.950532];
             obj@TGammaRGBDisplay(gamma, M, 'D65');
        end
        
    end
end

