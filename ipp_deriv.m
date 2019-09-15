function rv = pp_deriv(pp)
% Input: pp is piecewise polynomial struct, returned from spline or pchip
% Output: pp struct with derivative coefficients, order - 1

    rv.form = 'pp';
    rv.breaks = pp.breaks;
    rv.pieces = pp.pieces;
    rv.order = pp.order - 1;
    rv.dim = pp.dim;
    if rv.dim ~= 1
        error('pp_deriv: cannot handle multi-dim functions');
    end
    fac = repmat(rv.order:-1:1,rv.pieces,1);
    rv.coefs = pp.coefs(:,1:rv.order) .* fac;
end

