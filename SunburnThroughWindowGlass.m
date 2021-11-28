
clear;
am15 = SolarSpectrum('AM15_GlobalTilt');
am0 = SolarSpectrum('AM0');

UVs = ResampleSpectrum(am15,280:400);
UVs_ext = ResampleSpectrum(am0,280:400);
figure(1);
clf;
hold on;
plot(UVs_ext.lam, UVs_ext.val);
plot(UVs.lam, UVs.val);

% table from https://refractiveindex.info/?shelf=3d&book=glass&page=soda-lime-clear
tau_glass_4mm= MakeSpectrum( 280:10:400, [1e-10, 1e-10, 1e-10, 0.0003, 0.12, 0.38, 0.67, 0.85, 0.93, 0.95, 0.92, 0.96, 0.97]);
od_glass = MakeSpectrum(tau_glass_4mm.lam, - 0.25 * log10(tau_glass_4mm.val));

d_pane = 4;
n_pane = 3;
thickness = d_pane * n_pane;
fresnel = 0.92^n_pane;

ts = sprintf('glass filtered, %g mm',thickness);
tau_glass = MakeSpectrum(od_glass.lam, fresnel * 10.^(- od_glass.val * thickness));

UV_filtered = MultiplySpectra(UVs, tau_glass);
plot(tau_glass.lam, tau_glass.val);
plot(UV_filtered.lam, UV_filtered.val);
grid on;
xlabel('wavelength (nm)');
title('glass filtered and direct solar spectrum');
legend({'extraterrestrial','direct','transmission',ts},'Location','northwest');

% https://www.ies.org/definitions/erythemal-action-spectrum/
ery.lam = 250:400;
ery.val = NaN(size(ery.lam));
for i = 1:length(ery.val)
    lam = ery.lam(i);
    if lam <= 298
        ery.val(i) = 1;
    elseif lam <= 328
        ery.val(i) = 10^(0.094 * (298-lam));
    else
        ery.val(i) = 10^(0.015 * (140-lam));
    end
end
figure(2);
semilogy(ery.lam, ery.val);
grid on;
xlabel('wavelength (nm)');
title('erythemal sensitivity');

figure(3);
clf; hold on;
grid on;
eff_UVs = MultiplySpectra(UVs, ery);
eff_filtered = MultiplySpectra(UV_filtered, ery);
bar(eff_UVs.lam, eff_UVs.val,1.0,'g','EdgeColor','none');
bar( eff_filtered.lam, eff_filtered.val,1.0,'EdgeColor','none');
sun_int = IntegrateSpectrum(eff_UVs);
filtered_int = IntegrateSpectrum(eff_filtered);
title(sprintf('erythema weighted spectra, overall transmission = %0.0f%%',filtered_int / sun_int * 100));
xlabel('wavelength (nm)');
legend({'direct',ts});


