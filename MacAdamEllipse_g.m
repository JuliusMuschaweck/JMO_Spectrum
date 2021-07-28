%% MacAdamEllipse_g
% 
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp; 
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp;
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp; 
% <a href="GroupedList.html"> Grouped list</a> &nbsp; | &nbsp; 
% Source code: <a href = "file:../MacAdamEllipse_g.m"> MacAdamEllipse_g.m</a>
% </p>
% </html>
% Helper function for <MacAdamEllipse.html MacAdamEllipse>
%% Syntax
% |g = MacAdamEllipse_g(X, Y, Z)|
%% Input Arguments
% * |X, Y; Z|: scalar doubles. Tristimulus values of center point.
%% Output Arguments
% * |g|: 3x3 double array. The matrix of the 3x3 tristimulus ellipsoid. Use only g(1:2,1:2) for the x-y ellipse matrix
%% Algorithm
% Algorithm follows Chickering, K. D. „Optimization of the MacAdam-Modified 1965 Friele 
%   Color-Difference Formula“. JOSA 57, Nr. 4 (1. April 1967): https://doi.org/10.1364/JOSA.57.000537.
% and Chickering, K. D. „FMC Color-Difference Formulas: Clarification Concerning Usage“.
%   JOSA 61, Nr. 1 (1. Januar 1971): 118. https://doi.org/10.1364/JOSA.61.000118.
%% See also
% <MacAdamEllipse.html MacAdamEllipse>
%% Usage Example
% See <MacAdamEllipse.html MacAdamEllipse>

% publish with publishWithStandardExample('filename.m') in PublishDocumentation.m

% JMO Spectrum Library, 2021. See https://github.com/JuliusMuschaweck/JMO_Spectrum
% I dedicate the JMO_Spectrum library to the public domain under Creative Commons Zero 
% (https://creativecommons.org/publicdomain/zero/1.0/legalcode)
%
%

function g = MacAdamEllipse_g(X, Y, Z, varargin)
% Compute MacAdamEllipsoid g matrix (inverse covariance matrix of ellipsois
% Input:
%       X, Y, Z: tristimulus values of center point
% Output:
%       g:      the 3 x 3 X-Y-Z tristimulus ellipsoid
%       
% Algorithm follows Chickering, K. D. „Optimization of the MacAdam-Modified 1965 Friele 
%   Color-Difference Formula“. JOSA 57, Nr. 4 (1. April 1967): https://doi.org/10.1364/JOSA.57.000537.
% and Chickering, K. D. „FMC Color-Difference Formulas: Clarification Concerning Usage“.
%   JOSA 61, Nr. 1 (1. Januar 1971): 118. https://doi.org/10.1364/JOSA.61.000118.
    % When applyK1K2 = false, we compute the FMC-1 formula according to Chickering 1971
    % then, the result depends only on x,y color coordinates, not on lightness/luminance
    % in other words, X,Y,Z can be multiplied with the same factors without changing result.
    % When applyK1K2 = true, we compute the FMC-2 formula, see Chickering 1971.
    % Then, scaling Y to 10.79 yields almost identical results to FMC-1.
    % OSRAM ColorCalculator uses FMC-1
    applyK1K2 = false;
    % eq (4)
    P = 0.724 * X + 0.382 * Y - 0.098 * Z;
    Q = - 0.48 * X + 1.37 * Y + 0.1276 * Z;
    S = 0.686 * Z;
    % eq (5)
    D = sqrt(P^2+Q^2);
    % eq (6)
    a = sqrt(17.3e-6 * D^2 / (1 + 2.73 * P^2*Q^2/(P^4+Q^4)));
    % eq (7)
    b = sqrt(3.098e-4 * (S^2 + 0.2015 * Y^2));
    % eq (11)
    K1 = 0.55669 + Y * (0.049434 + Y * (-0.82575e-3 + Y * (0.79172e-5 - 0.30087e-7 * Y)));
    % eq (12)
    K2 = 0.17548 + Y * (0.027556 + Y * (-0.57262e-3 + Y * (0.63893e-5 - 0.26731e-7 * Y)));
    % eq 20 - 23
    if ~applyK1K2 
        K1 = 1;
        K2 = 1;
    end
    e1 = K1 * S / (b * D^2); % D^2 in denom?
    e2 = K1 / b;
    e3 = 0.279 * K2 / (a * D);
    e4 = K1 / (a * D);
    % eq 14-19
    C11 = (e1^2 + e3^2) * P^2 + e4^2 * Q^2;
    C12 = (e1^2 + e3^2 - e4^2) * P*Q;
    C22 = (e1^2 + e3^2) * Q^2 + e4^2 * P^2; 
    C13 = - e1*e2*P;
    C23 = - e1*e2*Q;
    C33 = e2^2;
    C21 = C12;
    C31 = C13;
    C32 = C23;
    % eq 25
    A = [0.724, 0.328, -0.098;...
        -0.48,  1.37,  0.1276;...
        0,      0,     0.686];
    % eq 26
    E = X + Y + Z;
    M = [E,  - E * X / Y,   X / Y;...
         0,     0,         1;...
         -E,  -E*(Y+Z)/Y    Z/Y];
    % eq 27
    C = [C11, C12, C13;...
         C21, C22, C23;...
         C31, C32, C33];
     % eq 24
     g = M' * A' * C * A * M;
end