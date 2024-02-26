

clear;

sp{1} = GaussSpectrum(400:500,450,10);
sp{2} = GaussSpectrum(400:700,550,30);

SpectrumSanityCheck

minval = 0.00001; % no zero spectrum values

nSpectra = length(sp);
for i = 1:nSpectra
    [ok, msg, sp{i}] = SpectrumSanityCheck(sp{i});
    phi(i) = IntegrateSpectrum(sp{i}); %#ok<SAGROW>
    F(i) = F_(sp{i},phi(i));
    G(i) = G_(F(i));
end

cat

x = unique(sort(cat(1, G1.lam, G2.lam)));
G1 = ResampleSpectrum(G1, x); % from my spectrum library
G2 = ResampleSpectrum(G2, x);
myG.lam = x;

% the weights
% change w1 to anything in [0;1] to see how the interpolated spectrum behaves
w1 = 0.3;
w2 = 1 - w1;
% and the weighted sum of the inverse probability functions
myG.val = w1 * G1. val + w2 * G2.val;

figure(); hold on;
PlotSpectrum(G1);
PlotSpectrum(G2);
PlotSpectrum(myG,'--');
title("inverse probability functions")

myF.lam = myG.val;
myF.val = myG.lam;
myF.val(1) = 0;

figure();
PlotSpectrum(myF);
title("Interpolated accumulated probability function")

f1 = LinInterpol(blue1.lam, blue1.val, G1.val); % from my spectrum library,
f2 = LinInterpol(blue2.lam, blue2.val, G2.val); % equivalent to interp1 with linear interpolation

myf = 1 ./ (w1 ./ f1 + w2 ./ f2);
myscale = trapz(myG.val,myf)
myphi = w1 * phi1 + w2 * phi2;

myblue.lam = myG.val;
myblue.val = myf / myscale * myphi;

figure();
hold on;
PlotSpectrum(blue1);
PlotSpectrum(blue2);
PlotSpectrum(myblue);
title("Original and interpolated spectra")


%%
function rv = F_(spec, phi)
    rv.lam = spec.lam;
    rv.val = cumtrapz(spec.lam, spec.val) / phi;
    rv.val(end) = 1; % 
end

function rv = G_(rhs)
    rv.lam = rhs.val;
    rv.val = rhs.lam;
    rv.lam(1) = eps; % hack to make it a valid "spectrum" with all lam > 0;
end