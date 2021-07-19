clear;
blue = ReadLightToolsSpectrumFile('blue.sre');
blue.XYZ = CIE1931_XYZ(blue);

yellow = ReadLightToolsSpectrumFile('yellow.sre');
yellow.XYZ = CIE1931_XYZ(yellow);

figure(1);
clf;
hold on;
plot(blue.lam, blue.val,'b');
plot(yellow.lam, yellow.val,'Color',[0.5 0.5 0]);
LEDwhite = AddWeightedSpectra({blue,yellow},[1,0.5]);
LEDwhite = ResampleSpectrum(LEDwhite, (min(LEDwhite.lam)) : (max(LEDwhite.lam)));
plot(LEDwhite.lam, LEDwhite.val,'k');
LEDwhite.XYZ = CIE1931_XYZ(LEDwhite);
[LEDwhite.CCT, LEDwhite.dist_uv] = CCT(LEDwhite);
cri = CRI();
LEDwhite.Ra = cri.Ra(LEDwhite);

WriteLightToolsSpectrumFile(LEDwhite, 'LEDWhite.sre','comment',...
    sprintf('typical cold white LED spectrum, CCT = %0.f, Ra = %0.f',round(LEDwhite.CCT), round(LEDwhite.Ra)));

%%
pl = PlanckLocus();
figure(2);
fh = figure(2);
clf;
PlotCIExyBorder('Figure',fh);
hold on;
T = [1000 2000 3000 4000 5000 6000];
xy = pl.xy_func(T);
scatter(xy(:,1),xy(:,2));
plot(pl.x,pl.y);

plot([yellow.XYZ.x, LEDwhite.XYZ.x, blue.XYZ.x],[yellow.XYZ.y, LEDwhite.XYZ.y, blue.XYZ.y],'Color',[0.5 0.5 0],'LineStyle','--','Marker','x');

axis equal;
grid on;
axis([-0.05 0.9 -0.05 0.9]);
xlabel('CIE x');
ylabel('CIE y');
title('White LED spectrum')