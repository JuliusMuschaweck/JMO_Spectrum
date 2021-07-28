%% LDomPurity
% 
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp; 
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp;
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp; 
% <a href="GroupedList.html"> Grouped list</a> &nbsp; | &nbsp; 
% Source code: <a href = "file:../LDomPurity.m"> LDomPurity.m</a>
% </p>
% </html>
%
% Computes dominant wavelength and purity
%% Syntax
% |[ldom, purity] = LDomPurity(rhs)|
%% Input Arguments
% * |rhs|: A valid spectrum (see <IsSpectrum.html IsSpectrum> for what that is), or
% * |rhs|: alternatively, a struct with fieldy |x| and |y| (a CIE 1931 color point), or
% * |rhs|: alternatively, a double vector of length 2, interpreted as an x-y CIE 1931 color point
%% Output Arguments
% * |ldom|: scalar double: the dominant wavelength in nm. Negative when color point lies towards magenta line. 555 nm
% when color point coincides with white point within roundoff.
% * |purity|: scalar double: the relative distance from the |[1/3, 1/3]| white point to the monochromatic border. 
%    Negative when colorpoint lies towards magenta line. Zero when color point coincides with white point within roundoff.
%% Algorithm
% First, computes the angle of the line from white point to border, to see if that is towards the monochromatic border
% or towards magenta line. Then, finds that monochromatic wavelength whose border point leads to the same angle, by iterative root finding. The
% monochromatic border points are taken from the CIE standard in 1 nm steps. In between a 1 nm interval, linear
% interpolation is used.
%% See also
% <CIE1931_Data.html CIE1931_Data>, <ShiftToLdom.html ShiftToLdom>
%% Usage Example
% <include>Examples/ExampleLDomPurity.m</include>

% publish with publishWithStandardExample('filename.m') in PublishDocumentation.m

% JMO Spectrum Library, 2021. See https://github.com/JuliusMuschaweck/JMO_Spectrum
% I dedicate the JMO_Spectrum library to the public domain under Creative Commons Zero 
% (https://creativecommons.org/publicdomain/zero/1.0/legalcode)
%
function [ldom, purity] = LDomPurity(rhs)
    % Computes dominant wavelength in nm and purity, from E = (1/3,1/3). 
    % Ldom and purity negative if E -> x/y intersects magenta line, not the monochromatic border.
    % Returns [555,0] for x/y == E within circle of radius eps = 2.2e-16. 
    % Parameters: 
    %   rhs: may be spectrum (struct with lam and val), or XYZ (struct with x and y), or vector w length 2
    persistent CIE1931XYZ;
    if isempty(CIE1931XYZ)
        load('CIE1931_lam_x_y_z.mat','CIE1931XYZ');
    end
    xb = @(lambda) interp1(CIE1931XYZ.lam, CIE1931XYZ.xBorder, lambda);
    yb = @(lambda) interp1(CIE1931XYZ.lam, CIE1931XYZ.yBorder, lambda);
    % atan2(y,x), not x,y(!), goes from -pi to pi, x axis is 0 y axis is pi/2
    % so atan2 jumps at the -x axis.
    % we rotate left by pi/2 such that the -x axis becomes the -y axis in CIE xy
    % and angle is continuous through the xy border  
    angle = @(lambda) atan2(- xb(lambda) + 1/3, - 1/3 + yb(lambda));
    if isfield(rhs, 'lam')
        if isfield(rhs, 'XYZ')
            x0 = rhs.XYZ.x;
            y0 = rhs.XYZ.y;
        else
            XYZ=CIE1931_XYZ(rhs);
            x0 = XYZ.x;
            y0 = XYZ.y;
        end
    elseif isfield(rhs,'x')
        x0 = rhs.x;
        y0 = rhs.y;
    elseif isvector(rhs) && numel(rhs) == 2
        x0 = rhs(1);
        y0 = rhs(2);
    else
        error('LDomPurity: unknown rhs type (class %s)',class(rhs));
    end
    dx0 = x0 - 1/3.0;
    dy0 = y0 - 1/3.0;
    if (abs(dx0) < eps && abs(dy0) < eps)
        % x/y at white point
        ldom = 555; %arbitrary
        purity = 0;
        return;
    end
    % compute angle a0 of line from white point to x/y
    a0 = atan2(-dx0, dy0);
    % see if the line crosses the border or the magenta line. If it does, rotate by pi
    amax = angle(360);
    amin = angle(830);
    plusminus = +1.0;
    if (a0 > amax)
        a0 = a0 - pi;
        plusminus = -1.0;
    end
    if (a0 < amin)
        a0 = a0 + pi;
        plusminus = -1.0;
    end
    zerofun = @(lambda) angle(lambda) - a0;
    % sanity check
    if (zerofun(360) * zerofun(830)) >= 0
        error('LDomPurity: angle not bracketed');
    end
    [ldom,~,exitflag,~] = fzero( zerofun, [360, 830]);
    if exitflag ~= 1
        % this cannot happen...
        error('LDomPurity: Root finding failed, fzero exitflag = %g',exitflag);
    end
    xbldom   = xb(ldom);
    ybldom = yb(ldom);
    ldom = ldom  * plusminus;
    purity = plusminus * norm([dx0,dy0]) / norm ([xbldom - 1/3.0, ybldom - 1/3.0]);
end