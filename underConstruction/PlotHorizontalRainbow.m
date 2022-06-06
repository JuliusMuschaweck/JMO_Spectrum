function PlotHorizontalRainbow(ax, lam, yrel_bottom, yrel_top)
    xlims = get(ax, 'XLim');
    ylims = get(ax, 'YLim');
    ymin = ylims(1);
    ymax = ylims(2);

    ybot = (1-yrel_bottom) * ymin + yrel_bottom * ymax;
    ytop = (1-yrel_top) * ymin + yrel_top * ymax;

    r = TrueRainbow('lam', lam);
    im = r.RainbowImageFunc(lam, true, 100);
    hold on;
    image(ax, xlims, [ybot, ytop], im);
    % set(ax,'YDir','reverse');
    set(ax,'XLim',xlims);
    set(ax,'YLim',[ybot, ylims(2)]);

%         lims = axis();
%         ymin = lims(3);
%         ymax = lims(4);
%         ybotrel = -0.1;
%         ytoprel = -0.05;
%         ybot = ( 1 - ybotrel ) * ymin + ybotrel * ymax;
%         ytop = ( 1 - ytoprel ) * ymin + ytoprel * ymax;
%         image(lims(1:2), [ybot, ytop], im);
%         axis([lims(1), lims(2), ybot, lims(4)]);


end