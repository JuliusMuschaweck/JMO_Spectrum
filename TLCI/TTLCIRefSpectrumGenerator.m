classdef TTLCIRefSpectrumGenerator < TReferenceSpectrumGenerator
    methods
        function rv = ReferenceSpectrum(~, spectrum)
            % spectrum has lam, val, optionally XYZ (with fields X, Y, Z, x, y, z) and CCT
            % return value is a valid spectrum
            if isfield(spectrum, 'CCT')
                iCCT = spectrum.CCT;
            else
                iCCT = CCT(spectrum);
            end
            rv = TLCIReferenceSpectrum(iCCT);
        end
    end
end