function q = BilinearInverse(p,p1,p2,p3,p4,iter)
% public domain from https://stackoverflow.com/questions/808441/inverse-bilinear-interpolation#812077
% Computes the inverse of the bilinear map from [0,1]^2 to the convex
%   quadrilateral defined by the ordered points p1 -> p2 -> p3 -> p4 -> p1.
% Uses Newton's method. Inputs must be column vectors.
    q = [0.5; 0.5]; %initial guess
    for k=1:iter
        s = q(1);
        t = q(2);
        r = p1*(1-s)*(1-t) + p2*s*(1-t) + p3*s*t + p4*(1-s)*t - p;%residual
        Js = -p1*(1-t) + p2*(1-t) + p3*t - p4*t; %dr/ds
        Jt = -p1*(1-s) - p2*s + p3*s + p4*(1-s); %dr/dt
        J = [Js,Jt];
        q = q - J\r;
        q = max(min(q,1),0);
    end
end