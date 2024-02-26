clear;

figure(1); clf; hold on; grid on;
p1 = GaussSpectrum(400:500,450,10);
PlotSpectrum(p1);
p2 = GaussSpectrum(400:700,550,30);
p2.val = p2.val * 2;
PlotSpectrum(p2);
legend({'input 1','input 2'})

figure(2); clf; hold on; grid on;
p1 = GaussSpectrum(400:500,450,10);
PlotSpectrum(p1);
p2 = GaussSpectrum(400:700,550,30);
p2.val = p2.val * 2;
PlotSpectrum(p2);

%%

si = SpectrumInterpolator({p1,p2});
figure(2);

for w1 = [0.25, 0.5, 0.75]
    weights = [w1, 1-w1];
    ipol = si.Interpolate(weights);
    PlotSpectrum(ipol);
end
legend({'input 1','input 2', '0.25', '0.5','0.75'})

%%


