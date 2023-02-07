clear
load('CVRL_CIE_CMFs.mat');
cie1931 = CIE1931_Data();
cie1964 = CIE1964_Data();

max(abs(cie1931.x - CIE_1931_2deg_xyz.x))
max(abs(cie1931.y - CIE_1931_2deg_xyz.y))
max(abs(cie1931.z - CIE_1931_2deg_xyz.z))
max(abs(cie1964.x - CIE_1964_10deg_xyz.x))
max(abs(cie1964.y - CIE_1964_10deg_xyz.y))
max(abs(cie1964.z - CIE_1964_10deg_xyz.z))
