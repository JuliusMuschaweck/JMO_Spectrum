function rv = ipp_deriv(pp)
% Input: pp is piecewise polynomial struct, returned from spline or pchip or makima
% Output: pp struct with derivative coefficients, order - 1
    if strcmp(pp.form,'pp') ~= 1
        error('ipp_deriv: expect piecewise polynomial structure');
    end
    if pp.dim ~= 1
        error('ipp_deriv: expect 1-dim piecewise polynomial structure');
    end
%     breaks: [1 3 4 6 10 11]
%      coefs: [5×4 double]
%     pieces: 5
%      order: 4
%        dim: 1
    rv = pp;
    rv.order = pp.order - 1;
    rv.coefs = pp.coefs(:,1:end-1) .* (rv.order:-1:1);    
end

