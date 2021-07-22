function ExampleColorChecker()
    idx = [1 4 7 14 19 24];
    ccSpectra = ColorChecker(idx);
    figure();
    clf;
    hold on;
    leg = {};
    for i = 1:length(ccSpectra)
        s = ccSpectra{i};
        plot(s.lam, s.val);
        leg{end+1} = s.name; %#ok<AGROW>
    end
    legend(leg);
    xlabel('\lambda (nm)');
    ylabel('reflectivity');
    title('Some ColorChecker reflectivities');
end