function [ell, g, a, b, theta_deg] = MacAdamEllipse(x, y, nstep, npoints)
% Compute points and parameters of a MacAdamEllipse
% Input:
%       x, y : center coordinates
%       nstep: number of MacAdam Steps (1 = just noticeable)
%       npoints: number of points to sample ellipse
% Output:
%       ell:    (2 x nPoints) array of double, ellipse points
%       g:      the 3 x 3 X-Y-Z tristimulus ellipsoid; only 2x2 are meaningful
%       a:      first half axis of 1-step ellipse
%       b:      second half axis of 1-step ellipse
%       theta_deg: tilt angle of a
%       
% Algorithm follows Chickering, K. D. „Optimization of the MacAdam-Modified 1965 Friele 
%   Color-Difference Formula“. JOSA 57, Nr. 4 (1. April 1967): https://doi.org/10.1364/JOSA.57.000537.
% and Chickering, K. D. „FMC Color-Difference Formulas: Clarification Concerning Usage“.
%   JOSA 61, Nr. 1 (1. Januar 1971): 118. https://doi.org/10.1364/JOSA.61.000118.

    Y = 10.79; % can be any number as long as K1 and K2 are not used in MacAdamEllipse_g
    % Y = 100;
    X = Y * x / y;
    Z = Y * (1-x-y) / y;
    g = MacAdamEllipse_g(X, Y, Z); % the inverse covariance matrix, 
        % DeltaXYZ' * g * DeltaXYZ = distance in MacAdam step units
    g = g(1:2,1:2); % only color, not lightness
    ig = inv(g); % the x-y part of the covariance matrix
    [V,D] = eig(ig); % the eigenvalues are the squared lengths of the ellipse half axes
    e1 = sqrt(D(1,1)); % and the columns of V are the ellipse axis unit directions
    e2 = sqrt(D(2,2));
    t = linspace(0, 2*pi, npoints+1); % t = 0..2 pi
    t = t(1:(end-1));
    ell = NaN(2,npoints);
    for i = 1:npoints
        ell(:,i) = [x;y] + nstep * V * [e1 * cos(t(i)); e2 * sin(t(i))];
    end
    a = e2; % OSRAM ColorChecker convention: a is sqrt of second eigenvalue, b of first
    b = e1;
    theta_deg = atan2(V(2,2),V(1,2)) * 180 / pi; % the angle of the second eigenvector
    while(theta_deg > 180)
        theta_deg = theta_deg - 180;
    end
    while(theta_deg < 0)
        theta_deg = theta_deg + 180;
    end
    
end