r = GaussSpectrum(500:700,620,30);
g = GaussSpectrum(400:650,520,30);
b = GaussSpectrum(400:600,450,30);

w = AddWeightedSpectra({r,g,b},[3,4,2]);

r.xyz = CIE1931_XYZ(r);
g.xyz = CIE1931_XYZ(g);
b.xyz = CIE1931_XYZ(b);
w.xyz = CIE1931_XYZ(w);

fh = figure(1);
clf;
set(fh,'Position',[100 100 1000 400]);

subplot(1,2,1);
hold on;
plot(r.lam,r.val,'r','LineWidth',2);
plot(g.lam,g.val,'g','LineWidth',2);
plot(b.lam,b.val,'b','LineWidth',2);
plot(w.lam,w.val,'k','LineWidth',2);
xlabel('\lambda (nm)');
ylabel('spectrum (a.u.)');
title('white from rgb');

ah = subplot(1,2,2);
PlotCIExyBorder('Axes',ah,'ColorFill',true);
axis equal;
axis([-0.1,0.85,-0.05,0.9]);
hold on;
scatter(r.xyz.x,r.xyz.y,'ko','MarkerFaceColor','k');
scatter(g.xyz.x,g.xyz.y,'ko','MarkerFaceColor','k');
scatter(b.xyz.x,b.xyz.y,'wo','MarkerFaceColor','w');
scatter(w.xyz.x,w.xyz.y,'ko','MarkerFaceColor','k');
title('CIE xy diagram');

saveas(fh,'screenshot.jpg');


