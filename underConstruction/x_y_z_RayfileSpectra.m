% Measuring ray files with x short, x long, y, and z filters.
% Then: how can we generate ray files that give us the proper sum spectrum?

clear;
%close all;

cie = CIE1931_Data();

sumxyz = MakeSpectrum(cie.lam, 1 * cie.x + 2 * cie.y + 1 * cie.z);
figure(1);
clf;
hold on;
plot(cie.lam,cie.x,'r--');
plot(cie.lam,cie.y,'g--');
plot(cie.lam,cie.z,'b--');
PlotSpectrum(sumxyz,'k','LineWidth',2);

x1 = MakeSpectrum(cie.lam, cie.x / max(cie.x));
y1 = MakeSpectrum(cie.lam, cie.y / max(cie.y));
z1 = MakeSpectrum(cie.lam, cie.z / max(cie.z));


white = ReadLightToolsSpectrumFile('LED_4003K.sre');
figure(2);
clf;
hold on;
PlotSpectrum(white,'k');
PlotSpectrum(MultiplySpectra(white, x1),'r');
PlotSpectrum(MultiplySpectra(white, y1),'g');
PlotSpectrum(MultiplySpectra(white, z1),'b');


%%

sigma = 30;
bmean = 500;
rmean = 610;

lam = 360:830;

bfilter = MakeSpectrum(lam, 0.5 * (1 - tanh( (lam - bmean) / sigma)));
rfilter = MakeSpectrum(lam, 0.5 * (1 + tanh( (lam - rmean) / sigma)));
gfilter = MakeSpectrum(lam, 1 - bfilter.val - rfilter.val);
figure(3);
clf;
hold on;
PlotSpectrum(rfilter,'r');
PlotSpectrum(gfilter,'g');
PlotSpectrum(bfilter,'b');
%PlotSpectrum(Vlambda(),'g--');


