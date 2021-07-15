classdef (Abstract) TCamera
    % TCamera: abstract camera base class
    % has only one abstract method: Response
    properties
        cameraname = 'abstract TCamera';
    end
    
    methods (Abstract)
        RGB_C_prime = Response(obj, spectrum)
        % spectrum has lam, val
        % return value has fields R,G,B, and column (3,1) vector RGB
        obj = WhiteBalance(obj, spectrum)
        % make sure that Response(spectrum) returns (1,1,1)
    end
end

