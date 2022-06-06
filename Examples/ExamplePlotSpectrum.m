function ExamplePlotSpectrum()
    % create some spectra
    s1 = GaussSpectrum(400:700,550,50);
    s2 = GaussSpectrum(400:700,550,10);
    % create a figure;
    figure();
    ax = gca; % remember the axes
    PlotSpectrum(s1);
    hold on;
    % create a second figure
    figure()
    % Plot with some graph settings
    PlotSpectrum(s2,'r-.','LineWidth',2) % or any other arguments that plot(...) recognizes

    % now plot the same to the first figure
    PlotSpectrum(ax,s2,'r-.','LineWidth',2) % or any other arguments that plot(...) recognizes
end