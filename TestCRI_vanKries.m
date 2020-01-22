% some calculations to better understand the vanKries transfrom in section 5.7 of the standard
clear;

xr = 0.33;
yr = 0.33;

[ur, vr] = uv(xr,yr);
cr = c(ur,vr);
dr = d(ur,vr);

% k more bluish than r
xk = 0.31; 
yk = 0.31;
[uk, vk] = uv(xk,yk);
ck = c(uk,vk);
dk = d(uk,vk);

sel = 1;
switch sel
    case 1 
        % ki = k => uvprime == uvr: when cc==cr and dd=dr, cd and uvprime are inverse
        uki = uk;
        vki = vk;
    case 2
        % yellow, uv_prime_ki should be further towards yellow since uvk is bluish
        xki = 0.4;
        yki = 0.4;
        [uki, vki] = uv(xki, yki);
end

cki = c(uki,vki);
dki = d(uki,vki);

cc = cr * cki / ck;
dd = dr * dki / dk;

den = (16.518 + 1.481*cc - dd);
uprime_ki = (10.872 + 0.404*cc - 4*dd) / den;
vprime_ki = 5.520 / den;


function rv = c(u,v)
    rv = (4- u - 10*v) / v;
end
function rv = d(u,v)
    rv = (1.708*v + 0.404 - 1.481*u) / v;
end

function [u,v] = uv(x,y)
    den = - 2 * x + 12 * y + 3;
    u = 4 * x / den;
    v = 6 * y / den;    
end
