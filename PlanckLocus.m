%% PlanckLocus
% 
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp; 
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp;
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp; 
% <a href="GroupedList.html"> Grouped list</a> &nbsp; | &nbsp; 
% Source code: <a href = "file:../PlanckLocus.m"> PlanckLocus.m</a>
% </p>
% </html>
%
% Computes the Planck locus (i.e. the color points of blackbody radiators) in various color
% spaces, and provides helper functions to compute Judd lines.
%
%% Syntax
% |rv = PlanckLocus()|
%% Input Arguments
% none

%% Output Arguments
% * |rv|: A struct with fields
%
% # |nT|: scalar integer: the number of data points (1001)
% # |T|: Array of double, length |nT|: the absolute temperatures
% # |invT|: Array of double, length |nT|: the inverse absolute temperatures. Data points
% range from 500 K to 1e+11 K, equidistant in 1/T. 
% # |x|: Array of double, length |nT|: The CIE 1931 x coordinates.
% # |y|: Array of double, length |nT|: The CIE 1931 y coordinates.
% # |u|: Array of double, length |nT|: The CIE 1960 u coordinates.
% # |v|: Array of double, length |nT|: The CIE 1960 v coordinates.
% # |up|: Array of double, length |nT|: The CIE 1976 u' coordinates.
% # |vp|: Array of double, length |nT|: The CIE 1976 v' coordinates.
% # |xy_func|: Handle to function with signature |rv2 = rv.xy_func(T)|, Input |T|: Vector of
% double: the absolute temperatures for which color coordinates shall be computed. Output
% |rv2|: Matrix of double, size |[length/T),2]|. The first/second column contains the CIE x/y coordinates 
% corresponding to the values in T.
% # |uv_func|: Handle to function with signature |rv3 = rv.xy_func(T)|, Input |T|: Vector of
% double: the absolute temperatures for which color coordinates shall be computed. Output
% |rv3|: Matrix of double, size |[length/T),2]|. The first/second column contains the CIE 1960 u/v coordinates 
% corresponding to the values in T.
% # |spline_u|: Struct containing the interpolating spline interpolation data for CIE 1960 u
% as function of inverse absolute temperature. See Matlab's |spline| function for details on
% the fields and properties of this spline object, and Matlab's |ppval| function on how to
% use it.
% # |spline_v|: Same for CIE 1960 v.
% # |spline_du_dinvT|: Interpolating spline struct for the derivative of CIE 1906 u as
% function of inverse absolute temperature. This is the analytical derivative of the spline
% interpolating function modeling CIE 1960 u.
% # |spline_dv_dinvT|: Same for CIE 1960 v. Together with |spline_du_dinvT|, this
% interpolating spline struct allows to compute tangents and normals to the Planck locus in
% CIE 1960 uv.
% # |JuddLine_func|: Handle to function with signature |rv4 = rv.JuddLine_func(T)|. Input
% |T|: Scalar real. Output |rv4|: struct with fields |u|, |v| (the CIE 1960 uv coordinates
% corresponding to |T|), and |du|, |dv|, the coordinates of the Judd line direction unit
% vector, towards green.
%% Algorithm
% Computes the Planck blackbody spectra for all 1001 absolute temperatures, with their CIE
% 1931 XYZ values, and computes the other data fields. The Judd lines, along which the
% distance to the Planck locus is computed for correlated color temperature, are defined as
% the normal vectors to the Planck locus curve in the otherwise deprecated CIE 1960 color
% coordinate system. 
% The function handles forward their
% arguments to Matlab's |interp1| function. The spline interpolation data structures are
% computed using Matlab's |spline| function, and the analytical derivates using the
% |ipp_deriv| helper function of this library.
% 
% The time intensive computations are done only once per Matlab session. The results are
% stored in a persistent variable; subsequent calls will not incur the overhead. 
%% See also
% <PlanckSpectrum.html PlanckSpectrum>, <CIE1931_XYZ.html CIE1931_XYZ>, <CCT.html CCT>
%% Usage Example
% <include>Examples/ExamplePlanckLocus.m</include>

% publish with publishWithStandardExample('filename.m') in PublishDocumentation.m

% JMO Spectrum Library, 2021. See https://github.com/JuliusMuschaweck/JMO_Spectrum
% I dedicate the JMO_Spectrum library to the public domain under Creative Commons Zero 
% (https://creativecommons.org/publicdomain/zero/1.0/legalcode)
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

