function rv = ColorCheckerTestSamples(ii)
    arguments
        ii (1,:) double = 1:24
    end
    ccs = ColorChecker(ii);
    if isscalar(ii)
        rv = TTestSample(ccs.name, sprintf('Color checker sample # %g',ii), ccs.lam, ccs.val);
        return;
    end
    rv = [];
    j = 0;
    for i = ii
        j = j + 1;
        ccsi = ccs{j};
        ts = TTestSample(ccsi.name, sprintf('Color checker sample # %g',i), ccsi.lam, ccsi.val);
        if isempty(rv)
            rv = ts;
        else
            rv(end+1) = ts; %#ok<AGROW>
        end
    end
end