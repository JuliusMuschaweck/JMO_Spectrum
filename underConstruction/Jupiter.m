clear;
M_sun_W_m2 = 64e6;
X_sun_sr = pi;
L_sun_W_m2sr = M_sun_W_m2 / X_sun_sr

r_sun_km = 695700
d_sun_km = 780000000;
X_sun_from_jupiter_sr = (r_sun_km/d_sun_km)^2 * pi

E_on_J_W_m2 = L_sun_W_m2sr * X_sun_from_jupiter_sr

J_albedo = 0.5;
L_jupiter_W_m2sr =J_albedo * E_on_J_W_m2 / pi

tau_telescope = 0.85;
F_telescope = 4;
NA_telescope = 1/(2*F_telescope)

X_telescope_sr = NA_telescope^2 * pi

E_image_W_m2 = tau_telescope * L_jupiter_W_m2sr * X_telescope_sr

d_pixel = 3.76e-6;
A_pixel = d_pixel^2;
P_pixel = E_image_W_m2 * A_pixel

wavelength = 550e-9;
cod = CODATA2018();
c = cod.c.value;
freq = c / wavelength
h = cod.h.value
photon_energy = h * freq

photons_per_second = P_pixel / photon_energy
QE = 0.8;
electrons_per_second = photons_per_second * QE

fullwell = 50000;
exposuretime = fullwell / electrons_per_second;
electrons  = electrons_per_second * exposuretime
shotnoise = 1/sqrt(electrons)


