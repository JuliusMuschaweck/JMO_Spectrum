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

