%% PlanckLocus
% 
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp; 
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp;
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp; 
% <a href="GroupedList.html"> Grouped list</a>
% </p>
% </html>
%
% documentation to be completed
%
function rv = PlanckLocus()
    % Output: struct with size 1000 vectors T, invT, x, y, u, v, up, vp
    % equidistant in 1/T from 500K to 1e11K
    % plus: field xy_func(T) which accepts also row vector T
    %       xy_func(T) returns matrix size (length(T),2) with x,y values
    % plus: field uv_func(T) which accepts also row vector T
    %       uv_func(T) returns matrix size (length(T),2) with u,v values
    % plus: field JuddLine_func(T) which accepts scalar T
    %       returns struct with fields u,v,du,dv. norm([du dv]) == 1
    % plus: piecewise cubic polynomial objects (see help for spline and pchip)
    %   spline_u, spline_v, spline_du_invT, spline_dv_invT to be used e.g for CCT
    
    persistent PlanckLocus_;
    if ~isempty(PlanckLocus_)
        rv = PlanckLocus_;
        return;
    end
    nT = 1001;
    PlanckLocus_.nT = nT;
    
    Tmin = 500;
    Tmax = 1e11;
    PlanckLocus_.invT = linspace(1/Tmax,1/Tmin,nT);
    PlanckLocus_.T = (1 ./ PlanckLocus_.invT);
    
    PlanckLocus_.x = zeros(1,nT);
    PlanckLocus_.y = zeros(1,nT);
    PlanckLocus_.u = zeros(1,nT);
    PlanckLocus_.v = zeros(1,nT);
    PlanckLocus_.up = zeros(1,nT);
    PlanckLocus_.vp = zeros(1,nT);
    
    for i = 1:nT
        ps = PlanckSpectrum(360:830,PlanckLocus_.T(i));
        x = ps.XYZ.x;
        y = ps.XYZ.y;
        PlanckLocus_.x(i) = x;
        PlanckLocus_.y(i) = y;
        den = -2*x + 12*y + 3;
        PlanckLocus_.u(i) = 4 * x / den;
        PlanckLocus_.up(i) = PlanckLocus_.u(i);
        PlanckLocus_.v(i) = 6 * y / den;
        PlanckLocus_.vp(i) = 9 * y / den;
    end
    PlanckLocus_.xy_func = @(T) interp1(PlanckLocus_.invT',cat(2,(PlanckLocus_.x)',(PlanckLocus_.y)'),1./T);
    PlanckLocus_.uv_func = @(T) interp1(PlanckLocus_.invT',cat(2,(PlanckLocus_.u)',(PlanckLocus_.v)'),1./T);
    
    PlanckLocus_.spline_u = spline(PlanckLocus_.invT,PlanckLocus_.u);
    PlanckLocus_.spline_v = spline(PlanckLocus_.invT,PlanckLocus_.v);
    
    PlanckLocus_.spline_du_dinvT = ipp_deriv(PlanckLocus_.spline_u);
    PlanckLocus_.spline_dv_dinvT = ipp_deriv(PlanckLocus_.spline_v);

    PlanckLocus_.JuddLine_func = @(T) JuddLine(T, PlanckLocus_);
    
    rv = PlanckLocus_;
end
%%

function Juv = JuddLine(T, pl)
    tmp =  pl.uv_func(T);
    Juv.u = tmp(1);
    Juv.v = tmp(2);
    invT = 1/T;
    tangent_u = ppval(pl.spline_du_dinvT,invT); % in invT direction
    tangent_v = ppval(pl.spline_dv_dinvT,invT);
    len = norm([tangent_u,tangent_v]);
    Juv.du = - tangent_v/len;
    Juv.dv = tangent_u/len;
end

