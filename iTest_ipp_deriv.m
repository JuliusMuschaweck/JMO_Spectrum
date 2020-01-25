clear;

xx = (0:0.05:1).^2 * pi;
yy = sin(xx);
dyy = cos(xx);
figure(1);
clf;
hold on;
scatter(xx,yy,'r');
scatter(xx,dyy,'b');

pp = makima(xx,yy);

ixx = 0:0.1:pi;
plot(ixx, ppval(pp,ixx),'r');

dpp = ipp_deriv(pp);
plot(ixx, ppval(dpp,ixx),'b');

