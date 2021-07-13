function ExamplePlanckLocus()
    pl = PlanckLocus();
    fh = figure();clf;
    PlotCIExyBorder('Figure',fh);
    hold on;
    T = [1000 2000 3000 4000 5000 6000];
    xy = pl.xy_func(T);
    scatter(xy(:,1),xy(:,2));
    plot(pl.x,pl.y);
    axis equal;
    grid on;
    axis([-0.05 0.9 -0.05 0.9]);
    xlabel('CIE x');
    ylabel('CIE y');
    title('CIE xy border and Planck locus demo')
end