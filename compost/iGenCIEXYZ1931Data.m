% script to create CIE 1931 XYZ color matching and chromaticity data 
% from raw text as in ISO/CIE 11664-1:2019(E)

CIE1931XYZ_2019_raw = readmatrix('CIE1931_xyz_raw_11664_1_2019.txt');
% the sums according to the standard
% x and z sums are exact, y sum is off by <1e-13 while the test value is 
% precise is given to only 1e-12
assert(abs(sum(CIE1931XYZ_2019_raw(:,2)) - 106.865469489595) == 0);
assert(abs(sum(CIE1931XYZ_2019_raw(:,3)) - 106.856917101172) < 1e-13);
assert(abs(sum(CIE1931XYZ_2019_raw(:,4)) - 106.892251278636) == 0);

CIE1931XYZ.lam = CIE1931XYZ_2019_raw(:,1);
CIE1931XYZ.x = CIE1931XYZ_2019_raw(:,2);
CIE1931XYZ.y = CIE1931XYZ_2019_raw(:,3);
CIE1931XYZ.z = CIE1931XYZ_2019_raw(:,4);
CIE1931XYZ.xBorder = CIE1931XYZ_2019_raw(:,5);
CIE1931XYZ.yBorder = CIE1931XYZ_2019_raw(:,6);
CIE1931XYZ.zBorder = CIE1931XYZ_2019_raw(:,7);

% test if chromaticities all add up to 1.000 -- error is < 3e-15 but numbers in 
% standard are only 5 digits 
assert(sum(abs(CIE1931XYZ.xBorder + CIE1931XYZ.yBorder + CIE1931XYZ.zBorder - 1)) < 3e-15);

% make sure that PlanckLocus is completely recreated
clear PlanckLocus;
clear PlanckSpectrum;
pl = PlanckLocus();

CIE1931XYZ.PlanckT = pl.T;
CIE1931XYZ.Planckx = pl.x;
CIE1931XYZ.Plancky = pl.y;

save('CIE1931_lam_x_y_z.mat', 'CIE1931XYZ');