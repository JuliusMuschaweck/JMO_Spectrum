clear;

rv = TrueRainbow('lam',400:700,'showDiagnostics',true);
%%
am15 = ResampleSpectrum(SolarSpectrum('AM15_GlobalTilt'),360:1000);
planck = PlanckSpectrum(400:700,5700);
figure(1);
clf;
%PlotRainbowFilledSpectrum(am15,'ax',gca);
PlotRainbowFilledSpectrum(am15,'ax',gca);

figure(2);
clf;
hold on;
PlotSpectrum(planck);
PlotHorizontalRainbow(gca,400:700,0,0.1);