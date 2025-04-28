close all;
lambda = 300:1000;
sun = ResampleSpectrum(SolarSpectrum('AM15_GlobalTilt'), lambda);
tmp = (lambda(1) ./ lambda).^4;
scatter_weight = MakeSpectrum(lambda, tmp);
blue_sky = MultiplySpectra(sun, scatter_weight);
figure(1); clf; hold on; grid on;
xlabel("\lambda (nm)");
ylabel("spectrum (a.u.)")
PlotSpectrum(sun,'r');
PlotSpectrum(blue_sky,'b');

blue_sky.xyz = CIE1931_XYZ(blue_sky);
blue_sky.CCT = CCT(blue_sky);
blue_sky.CCT
sun.xyz = CIE1931_XYZ(sun);
sun.CCT = CCT(sun);


ax = PlotCIExyBorder('ColorFill', true);
pl = PlanckLocus();
plot(ax,pl.x,pl.y);
scatter(blue_sky.xyz.x,blue_sky.xyz.y,'x');
scatter(sun.xyz.x,sun.xyz.y,'o');


