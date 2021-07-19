clear;
%%
% read blue and yellow parts of LED spectrum, compose white 
blue = ReadLightToolsSpectrumFile('blue.sre');
yellow = ReadLightToolsSpectrumFile('yellow.sre');
figure(1);
clf;
hold on;
plot(blue.lam,blue.val,'b');
plot(yellow.lam, yellow.val,'Color',[0.5 0.5 0]);

white = AddWeightedSpectra({blue,yellow},1.1*[2.1 1]); % reasonable white point;
plot(white.lam, white.val,'k');
xlabel('\lambda');
ylabel('spectrum (a.u.)');
title('composition of white LED spectrum');
legend({'blue part','yellow part','weighted sum'});
grid on;
white.XYZ = CIE1931_XYZ(white);
[white.CCT, white.dist_uv] = CCT_from_xy(white.XYZ.x,white.XYZ.y);
white.name = 'typical white LED spectrum';
white_1nm = ResampleSpectrum(white,400:780);
white_1nm.val = white_1nm.val / max(white_1nm.val);

white_array = zeros(length(white_1nm.lam),2);
white_array(:,1) = white_1nm.lam;
white_array(:,2) = white_1nm.val;

%%
% compute CRI values, also when spectrum shifted

cri = CRI();
Ra = cri.Ra(white);
CRIspec = cri.CRISpectra_;
CRI_all = cri.FullCRI(white);

shifted_Ra=[];
dLams = -15:3:15;
for dLam = dLams
    shifted = white;
    shifted.lam = shifted.lam + dLam;
    shifted_Ra(end+1) = cri.Ra(shifted);
end
figure(2);
clf;
plot(dLams, shifted_Ra);
xlabel('wavelength shift (nm)');
ylabel('R_a');
title('R_a vs. wavelength shift of white LED');
grid on;

%%
% see how addition of a LED-like spectrum changes Ra
centers = 420:10:630;
sigma = 15;
height = 0.4;
shifted_Ra=[];
for center = centers
    gauss = GaussSpectrum(white.lam,center,sigma);
    sumspec = AddWeightedSpectra({white, gauss},[1,height]);
    shifted_Ra(end+1) = cri.Ra(sumspec);
end
figure(3);
clf;
plot(centers, shifted_Ra);
hold on;
plot(centers([1,end]),[Ra Ra]);
xlabel('center wavelength of added Gauss (nm)');
ylabel('R_a');
title('R_a vs. wavelength of added gauss');
grid on;
axis([-Inf,Inf,55,80]);

figure(4);
hold on;
plot(white.lam, white.val);
gauss485 = GaussSpectrum(white.lam,485,sigma);
better = AddWeightedSpectra({white,gauss485},[1,height]);
plot(better.lam, better.val);
Ra485 = cri.Ra(better);

%%
best = AddWeightedSpectra({white,GaussSpectrum(white.lam,485,sigma),GaussSpectrum(white.lam,630,sigma)},[1,1.5,0.27]);
bestXYZ = CIE1931_XYZ(best);
CCTbest = CCT_from_xy(bestXYZ.x,bestXYZ.y);
fprintf('x/y: %g/%g, CCT = %g\n',bestXYZ.x,bestXYZ.y,CCTbest);
RaBest = cri.Ra(best);
figure(5);
plot(best.lam, best.val);
title(sprintf('white LED with two added Gauss spectra, Ra = %g',RaBest));