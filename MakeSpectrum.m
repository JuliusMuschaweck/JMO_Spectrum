function rv = MakeSpectrum(lam, val, varargin)
% function rv = MakeSpectrum(lam, val)
% creates a spectrum struct out of fields lam and val
% and checks if they meet the requirements
    rv = struct('lam',lam,'val',val);
    [~,~,rv] = SpectrumSanityCheck(rv);
end