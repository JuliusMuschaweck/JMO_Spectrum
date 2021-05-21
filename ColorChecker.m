function rv = ColorChecker(i)
    %ColorChecker return i'th sample, i in [1,24]
    % i may be array, then return cell array of spectra
    persistent iColorCheckerSpectra;
    if isempty(iColorCheckerSpectra)
        load('ColorCheckerSpectra.mat', 'ColorCheckerSpectra');
        iColorCheckerSpectra = ColorCheckerSpectra;
    end
    if isscalar(i)
        rv = iColorCheckerSpectra{i};
    else
        rv = iColorCheckerSpectra(i);
    end
end

