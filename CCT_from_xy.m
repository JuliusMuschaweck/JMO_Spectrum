%% CCT_from_xy
% 
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp; 
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp;
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp; 
% <a href="GroupedList.html"> Grouped list</a> &nbsp; | &nbsp; 
% Source code: <a href = "file:../CCT_from_xy.m"> CCT_from_xy.m</a>
% </p>
% </html>
%
% Computes the correlated color temperature (CCT) of a spectrum
%% Syntax
% |[CCT, dist_uv, ok, errmsg] = CCT_from_xy(x,y)|
%% Input Arguments
% * |x|: Scalar double, CIE 1931 x coordinate
% * |y|: Scalar double, CIE 1931 y coordinate
%% Output Arguments
% * |iCCT|: scalar double. The correlated color temperature in Kelvin
% * |dist_uv|: scalar double. The distance to the Planck locus in uv coordinates. Negative when below Planck locus
% (towards magenta).
% * |ok|: When requested, function sets ok to false, sets iCCT and dist_uv to NaN in case of error instead of throwing
% error.
% * |errmsg|: Contains error and warning message(s)
%% Algorithm
% For a CIE 1931 xy color point, transform it to CIE 1960 uv coordinates, and then find the
% closest point on the Planck locus in CIE 1960 uv coordinates. The absolute temperature corresponding to the blackbody
% radiation that yields this point on the Planck locus is the CCT. See also the official CIE definition
% <https://cie.co.at/eilvterm/17-23-068>. 
%
% # Data for the Planck locus is obtained by calling <PlanckLocus.html PlanckLocus>, giving 1001 uv points
% along the Planck locus from 500 K to 1e+11K, equidistant in 1/T, and thus not too non-equidistant in uv.
% # The closest of these 1001 uv points is determined by computing all 1001 distances and then looking for the minimum.
% # If that minimum is > 0.09, there is an error, |CCT = NaN; dist_uv = NaN;|, and the function returns
% # If that minimum is > 0.05, there is a warning (see <https://cie.co.at/eilvterm/17-23-068>), because the color is so
% far away from the Planck locus that it is too green or magenta for a self respecting CCT.
% # If the temperature corresponding to that minimum is < 500.5 or > 500,000, there is an error.
% # At correct CCT, the vector connecting uv and the CCT point on the Planck locus is perpendicular to the Planck locus
% tangent unit vector, i.e. their cross product must be zero. This zero point is determined by treating this cross
% product as a quadratic function of inverse temperature, and computing the root of this quadratic function.
% # The CCT is then the inverse of this root. The uv distance is computed by evaluating a spline interpolation function
% of u and v. 
%% See also
% <CCT.html CCT>
%% Usage Example
% <include>Examples/ExampleCCT_from_xy.m</include>

% publish with publishWithStandardExample('filename.m') in PublishDocumentation.m

% JMO Spectrum Library, 2021. See https://github.com/JuliusMuschaweck/JMO_Spectrum
% I dedicate the JMO_Spectrum library to the public domain under Creative Commons Zero 
% (https://creativecommons.org/publicdomain/zero/1.0/legalcode)
%

function [CCT, dist_uv, ok, errmsg] = CCT_from_xy(x,y)
% function [CCT, dist_uv] = CCT_from_xy(x,y)
% computes CCT in the range of 1000K to 1000.000K with extreme precision
% dist_uv is the distance to the Planck locus in uv coordinates, should be
% less than 0.05 for valid CCT
% There is a warning for duv > 0.05, and an error for duv > 0.09, or CCT out of 1000K..10^6K range.
% However, if nargout >= 3, i.e. the 'ok' return value is queried, no warnings or errors are raised.
% Instead, ok == true (if no error) || false , and errmsg == '' || 'warning: ...' || 'error: ...', and if there is an
% error, then CCT = NaN and dist_uv = NaN
    pl = PlanckLocus();
    den = -2*x + 12*y + 3;
    u = 4 * x / den;
    v = 6 * y / den;
    du = u - pl.u;
    dv = v - pl.v;
    duv = sqrt(du.^2 + dv.^2);
    [minduv, iminduv] = min(duv);
    okcheck = nargout >= 3;
    ok = false; CCT = NaN; dist_uv = NaN; errmsg = '';
    if minduv > 0.09
        if okcheck
            errmsg = 'CCT error: duv > 0.09'; 
            return;
        else
            error('CCT: duv > 0.09');
        end
    end
    if iminduv < 2 || iminduv >= pl.nT
        if okcheck
            errmsg = 'CCT error: out of 500K ... 500,000K range'; 
            return;
        else
            error('CCT: out of 500K ... 500,000K range');
        end
    end
    ok = true;
    if minduv > 0.05
        if okcheck
            errmsg = 'CCT warning: duv > 0.05'; 
        else
            warning('CCT: duv > 0.05');
        end
    end
%     test0 = JuddDistance(invT);
%     testp = JuddDistance(pl.invT(iminduv+1));
%     testm = JuddDistance(pl.invT(iminduv-1));    

    dtest0 = DirectJuddDistance(iminduv);
    dtestp = DirectJuddDistance(iminduv+1);
    dtestm = DirectJuddDistance(iminduv-1);    
    
    y1 = dtestm;
    y2 = dtest0;
    y3 = dtestp;
    
    aa = y3/2 - y2 + y1/2;
    bb = -y3/2 + 2*y2 - 3/2 * y1;
    cc = y1;    
    
    mydet = bb^2 - 4 * aa * cc;
    if mydet < 0
        error('CCT: no parabolic solution');
    end
    x1 = (-bb + sqrt(mydet)) / (2*aa);
    x2 = (-bb - sqrt(mydet)) / (2*aa);
    if (abs(x1) < abs(x2))
        xx = x1;
    else
        xx = x2;
    end
    dinvT = pl.invT(2) - pl.invT(1);
    invrv = pl.invT(iminduv-1) + xx * dinvT;
    CCT = 1/invrv;
    if nargout > 1
        duu = u - ppval(pl.spline_u, invrv);
        dvv = v - ppval(pl.spline_v, invrv);
        dist_uv = norm([duu,dvv]);
        duc = u - 0.35; % uv "center" of planck locus
        dvc = v - 0.25;
        if (duu * duc + dvv * dvc) < 0 % below planck
            dist_uv = dist_uv * (-1);
        end
    end
    
%     function rv2 = JuddDistance(invT)
%         uu = ppval(pl.spline_u, invT);
%         vv = ppval(pl.spline_v, invT);
%         Ju = - ppval(pl.spline_dv_dinvT, invT);
%         Jv = ppval(pl.spline_du_dinvT, invT);
%         J = [Ju, Jv] / sqrt(Ju^2+Jv^2);
%         duuvv = [u-uu,v-vv];
%         rv2 = duuvv(1) * J(2) - duuvv(2) * J(1);
%     end
    
    function rv3 = DirectJuddDistance( idx )
        uu = pl.spline_u.coefs(idx,4);
        vv = pl.spline_v.coefs(idx,4);
        Ju = - pl.spline_dv_dinvT.coefs(idx,3);
        Jv = pl.spline_du_dinvT.coefs(idx,3);
        J = [Ju, Jv] / sqrt(Ju^2+Jv^2);
        duuvv = [u-uu,v-vv];
        rv3 = duuvv(1) * J(2) - duuvv(2) * J(1);
    end
end

