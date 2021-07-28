%% CIEDE2000_Lab
% 
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp; 
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp;
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp; 
% <a href="GroupedList.html"> Grouped list</a> &nbsp; | &nbsp; 
% Source code: <a href = "file:../CIEDE2000_Lab.m"> CIEDE2000_Lab.m</a>
% </p>
% </html>
%
% Compute the CIEDE2000 color difference between two CIELAB L*, a*, b* stimuli.
%% Syntax
% |dE = CIEDE2000_Lab( Lab1, Lab2 )|
%% Input Arguments
% * |Lab1|: A |struct| with scalar real fields |L|, |a| and |b|
% * |Lab1|: A |struct| with scalar real fields |L|, |a| and |b|
%% Output Arguments
% * |dE|: scalar double. The color difference. |dE == 1| is assumed to be just noticeable.
%% Algorithm
% Computes the CIEDE 2000 color difference, following CIE 015:2018 (same as 
% <https://www.iso.org/standard/63731.html ISO/CIE 11664-6:2014>. The computation is somewhat involved. 
% In <https://doi.org/10.1002/col.20070 Sharma et al, “The CIEDE2000 Color-Difference Formula: Implementation Notes, Supplementary Test Data, and Mathematical Observations.”>
% the authors give great guidance and many additional test Lab pairs. I followed their advice; for a test, see usage example below.
%% See also
% <CIEDE2000_XYZ.html CIEDE2000_XYZ> <CIE_Lab.html CIE_Lab>
%% Usage Example
% <include>Examples/ExampleCIEDE2000_Lab.m</include>

% publish with publishWithStandardExample('filename.m') in PublishDocumentation.m

% JMO Spectrum Library, 2021. See https://github.com/JuliusMuschaweck/JMO_Spectrum
% I dedicate the JMO_Spectrum library to the public domain under Creative Commons Zero 
% (https://creativecommons.org/publicdomain/zero/1.0/legalcode)
%

function dE = CIEDE2000_Lab( Lab1, Lab2 )
    kL = 1; % the three weighting factors which are usually 1
    kC = 1;
    kH = 1;
    Cstar1 = sqrt((Lab1.a)^2 + (Lab1.b)^2);
    Cstar2 = sqrt((Lab2.a)^2 + (Lab2.b)^2);
    Cstar = (Cstar1 + Cstar2)/2;
    Cstar7 = sqrt(Cstar^7 / (Cstar^7 + 25^7));
    g = 0.5 * (1 - Cstar7);
    aprime1 = (1+g)*Lab1.a;
    aprime2 = (1+g)*Lab2.a;
    Cprime1 = sqrt(aprime1^2 + (Lab1.b)^2);
    Cprime2 = sqrt(aprime2^2 + (Lab2.b)^2);
    deg = 180 / pi;
    rad = pi / 180;
    % Note: hue is measured in degrees, [0;360[
    h1 = atan2_0_360(Lab1.b, aprime1);
    h2 = atan2_0_360(Lab2.b, aprime2);
    Lprime = 0.5 * (Lab1.L + Lab2.L);
    Cprime = 0.5 * (Cprime1 + Cprime2);
    % for h, see Sharma et al., note 4. on p. 23
    if abs(h1-h2) <= 180
        h = (h1 + h2) * 0.5;
    else % |h1-h2| > 180
        if (h1 + h2) < 360
            h = (h1 + h2 + 360) * 0.5;
        else % >= 360
            h = (h1 + h2 - 360) * 0.5;
        end
    end
    
    dh = h1 - h2;
    % Note: delta h is measured in degrees, [-180;180]
    while dh > 180
        dh = dh - 360;
    end
    while dh < -180
        dh = dh + 360;
    end
    SL = 1 + 0.015 * (Lprime - 50)^2 / ...
        sqrt(20 + (Lprime - 50)^2);
    SC = 1 + 0.045 * Cprime;
    sindeg = @(x) sin (x * rad);
    cosdeg = @(x) cos (x * rad);
    T = 1 - 0.17 * cosdeg(h - 30) + 0.24 * cosdeg(2 * h) + ...
        0.32 * cosdeg(3 * h + 6) - 0.2 * cosdeg(4 * h - 63);
    SH = 1 + 0.015 * Cprime * T;
    RC = 2 * sqrt(Cprime^7 / (Cprime^7 + 25^7));
    dtheta = 30 * exp(-((h-275)/25)^2);
    RT = - RC * sin(2 * dtheta * rad);
    % Finally, calculate the resulting CIEDE2000 difference values
    dL = (Lab1.L - Lab2.L) / (kL * SL);
    dC = (Cprime1 - Cprime2) / (kC * SC);
    dH = 2 * sindeg( dh / 2) * sqrt(Cprime1 * Cprime2)...
        / (kH * SH);
    dE = sqrt( dL^2 + dC^2 + dH^2 + RT * dC * dH );
end

function rv = atan2_0_360(y, x)
    % rv in [0;360[ in degrees
    % built in atan2 returns [-pi;pi] says documentation
    % but in fact it is ]-pi;pi]
    if (y == 0 && x == 0)
        rv = 0;
    else
        rv = atan2(y,x) * 180 / pi;
        if rv < 0
            rv = rv + 360;
        end
        if rv >= 360
            rv = rv - 360;
        end
    end
end

