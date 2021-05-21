classdef TDisplay
    %TDisplay abstract display base class
    
    
    methods (Abstract)
        XYZ = Response(RGB_C_prime)
        % XYZ tristimulus values from display drive signal, with fields
        % X, Y, Z (double) and XYZ (3,1) column
        % RGB_C_prime is struct with field RGB which is a (3,1) column
    end
end

