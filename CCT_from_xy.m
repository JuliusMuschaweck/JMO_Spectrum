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
            errmsg = 'CCT error: out of 1000K ... infty range'; 
            return;
        else
            error('CCT: out of 1000K ... infty range');
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

