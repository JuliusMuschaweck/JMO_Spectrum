classdef (Abstract) TReferenceSpectrumGenerator
    % TReferenceSpectrumGenerator: abstract base class
    % has only one abstract method: ReferenceSpectrum
    
    methods (Abstract)
        rv = ReferenceSpectrum(obj, spectrum)
        % spectrum has lam, val, optionally XYZ (with fields X, Y, Z, x, y, z) and CCT
        % return value is a valid spectrum
    end
end
