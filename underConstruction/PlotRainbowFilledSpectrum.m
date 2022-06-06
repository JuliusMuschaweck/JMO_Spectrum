function PlotRainbowFilledSpectrum(spec, opts)
    arguments
        spec (1,1) struct
        opts.ax = []
    end
    if isempty(opts.ax)
        ax = gca;
    else
        ax = opts.ax;
    end
    r = TrueRainbow('lam', spec.lam);
    im = r.RainbowImageFunc(spec.lam, false, 1);
    bar(spec.lam, spec.val,1,'LineStyle','none','EdgeColor','none','FaceColor','flat','CData',im);
    hold on;
end


