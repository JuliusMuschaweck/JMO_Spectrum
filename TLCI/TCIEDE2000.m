classdef TCIEDE2000 < TSingleColorDifferenceCalculator
    %TCIEDE2000: The standard TLCI / CIEDE2000 color difference
    
    % See "The CIEDE2000 color?difference formula: Implementation notes, supplementary test data, 
    % and mathematical observations", by G. Sharma et al., https://doi.org/10.1002/col.20070
    % www2.ece.rochester.edu/~gsharma/ciede2000/ciede2000noteCRNA.pdf, for implementation notes and
    % additional test data pairs.
    properties
        XYZ_White % the display white
    end
    
    methods
        function obj = TCIEDE2000(display)
            % compute display white point
            %% 1.099 is the signal for 100% white
            % RGB_C_prime.RGB = [1.099;1.099;1.099] .^ 2.4;
            RGB_C_prime.RGB = [1;1;1];
            iXYZ = display.Response(RGB_C_prime);
            obj.XYZ_White = struct('X', iXYZ(1), 'Y', iXYZ(2),'Z', iXYZ(3));
        end

        function delta = Diff( obj, XYZ1, XYZ2 )
            delta = obj.dE_XYZ(XYZ1, XYZ2);
        end
        
        function delta = dE_XYZ( obj, XYZ1, XYZ2 ) 
            % First, calculate CIELAB values for the two samples
            Lab1 = obj.CIELAB(XYZ1);
            Lab2 = obj.CIELAB(XYZ2);
            % Then, calculate intermediate values for each color
            delta = obj.dE_Lab(Lab1, Lab2);
        end
        
        
        function delta = dE_Lab( ~, Lab1, Lab2 )
            delta = CIEDE2000_Lab(Lab1, Lab2);
        end
       
        
        function Lab = CIELAB(obj,XYZ)
            Lab = CIE_Lab(XYZ, obj.XYZ_White);
        end

    end
end

