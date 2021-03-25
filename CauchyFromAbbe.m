function [A0, A1] = CauchyFromAbbe(nd, v)
% Input: 
%   n: refractive index at lambda_d = 587.6 nm
%   v: Abbe number
% Output:
%   A0, A1: First two Cauchy dispersion coefficients, n = A0 + A1 / lambda^2.
%   A0: dimensionless, A1: micron^2
    ld = 0.5876;
    lD = 0.5893;
    lF = 0.4861;
    lC = 0.6563;
    c0 = 1 / ld^2;
    c1 = 1 / lD^2;
    c2 = 1/lF^2 - 1/lC^2;
    c3 = c1 - c2 * v;
    iM = [c3, -c0; -1, 1] / (c3-c0);
    A = iM * [nd; 1];
    A0 = A(1);
    A1 = A(2);
end