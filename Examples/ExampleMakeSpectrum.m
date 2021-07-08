function ExampleMakeSpectrum()
    lam = 360:830;
    cutoff = 500;
    width = 20;
    val = 0.5 * (1 + tanh((lam - cutoff) / width));
    s = MakeSpectrum(lam, val, 'name', 'HighPass_500_200',...
        'description','high pass filter curve around 500 nm with width 20 nm',...
        'created', datetime('now'))
    figure();
    clf;
    hold on;
    plot(s.lam, s.val);
    plot([cutoff - width, cutoff - width],[0 1],'k--');
    plot([cutoff, cutoff],[0 1],'k--');
    plot([cutoff + width, cutoff + width],[0 1],'k--');
    xlabel('\lambda (nm)');
    ylabel('filter transmission');
    title('500 nm / 20 nm high pass filter transmission');
end