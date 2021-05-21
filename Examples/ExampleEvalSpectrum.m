function ExampleEvalSpectrum()
    s = PlanckSpectrum(360:830,5000);
    lam = [900, 700, 800, 600, 400]; % any sequence, inside and outside
    v = EvalSpectrum(s, lam);
    figure();
    plot(s.lam, s.val);
    hold on;
    scatter(lam, v);
    axis([300 1000 -0.1 1.1]);
    legend({'Planck spectrum','Interpolated points'},'Location','southwest');
end