% script to create CIE 1964 XYZ 10° color matching and chromaticity data 
% from raw text as in ISO/CIE 11664-1:2019(E)

CIE1964XYZ_2019_raw = readmatrix('CIE1964_x10y10z10_raw_11664_1_2019.txt');
% the sums according to the standard
% x and z sums are exact, y sum is off by <1e-13 while the test value is 
% given to only 1e-12
assert(abs(sum(CIE1964XYZ_2019_raw(:,2)) - 116.648519508908) == 0);
assert(abs(sum(CIE1964XYZ_2019_raw(:,3)) - 116.661877102312) < 1e-13);
assert(abs(sum(CIE1964XYZ_2019_raw(:,4)) - 116.673980514647) == 0);
%%
CIE1964XYZ.lam = CIE1964XYZ_2019_raw(:,1);
CIE1964XYZ.x = CIE1964XYZ_2019_raw(:,2);
CIE1964XYZ.y = CIE1964XYZ_2019_raw(:,3);
CIE1964XYZ.z = CIE1964XYZ_2019_raw(:,4);
CIE1964XYZ.xBorder = CIE1964XYZ_2019_raw(:,5);
CIE1964XYZ.yBorder = CIE1964XYZ_2019_raw(:,6);
CIE1964XYZ.zBorder = CIE1964XYZ_2019_raw(:,7);


figure(8);
plot(CIE1964XYZ.lam, CIE1964XYZ.xBorder + CIE1964XYZ.yBorder + CIE1964XYZ.zBorder - 1);
hold on;
% we see that at lam == 393, there is an error of 1e-5:
% the standard says 0,17983 0,01919 0,80099 which add up to 1.00001.
% we fix this by modifying the largest of the three:
CIE1964XYZ.zBorder(34) = CIE1964XYZ.zBorder(34) - 0.00001;
plot(CIE1964XYZ.lam, CIE1964XYZ.xBorder + CIE1964XYZ.yBorder + CIE1964XYZ.zBorder - 1);

% test if chromaticities all add up to 1.000 -- error is < 3e-15 but numbers in 
% standard are only 5 digits 
assert(sum(abs(CIE1964XYZ.xBorder + CIE1964XYZ.yBorder + CIE1964XYZ.zBorder - 1)) < 3e-15);

save('CIE1964_lam_x_y_z.mat', 'CIE1964XYZ');