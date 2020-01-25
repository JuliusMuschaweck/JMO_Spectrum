function rv = MakeSpectrum(lam, val, varargin)
% function rv = MakeSpectrum(lam, val)
% creates a spectrum struct out of fields lam and val
% and checks if they meet the requirements
    rv = struct('lam',lam,'val',val);
    [~,~,rv] = SpectrumSanityCheck(rv);
    i = 1;
    if IsOctave()
        va = varargin;
    else
        va = cellfun( @convertStringsToChars, varargin, 'UniformOutput',false); % be compatible with both "" and '' input
    end
    while nargin >= i + 3
        fieldname = va{i};
        fieldvalue = va{i+1};
        if ~ischar(fieldname)
            error('MakeSpectrum: optional argument # %g must be a string, the name of a name/value pair',i);
        end
        rv.(fieldname) = fieldvalue;
        i = i + 2;
    end
end