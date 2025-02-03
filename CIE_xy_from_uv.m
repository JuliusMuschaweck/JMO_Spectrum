%% CIE_xy_from_uv
%
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp;
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp;
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp;
% <a href="GroupedList.html"> Grouped list</a> &nbsp; | &nbsp; 
% Source code: <a href = "file:../CIE_xy_from_upvp.m"> CIE_xy_from_upvp.m</a>
% </p>
% </html>
%
% Conputes CIE x, y, u', and v' color coordinates from CIE u, v (CIE 1960
% UCS, deprecated but still in use for CCT)
%% Syntax
% |rv = CIE_xy_from_uv(uv,varargin)|
%% Input Arguments
% * |uv|: May be (i) a struct with real array fields |u| and |v|, (ii) a
% real vector of length 2 (row or column), interpreted as u and v, 
% or (iii) a scalar real, interpreted as u. In case
% (iii), there must be a second argument, scalar real, interpreted as v.
% * |varargin|: scalar real, the v value. Only allowed if |uv| is a scalar real (the u value).
%% Output Arguments
% * |rv|: A |struct| with fields |x|, |y|, |u|, |v|, |up|, |vp|. When |uv| input is struct, |rv| is a copy with the
% other fields added.
%% Algorithm
% Applies the formulas of the CIE 1960 and CIE 1964 uniform color spaces to perform the projective transformation from
% u,v.
%% See also
% <CIE1931_XYZ.html CIE1931_XYZ>, <CIE_upvp.html CIE_upvp>, 
% <CIE_xy_from_upvp.html CIE_xy_from_upvp>
%% Usage Example
% <include>Examples/ExampleCIE_xy_from_uv.m</include>

% publish with publishWithStandardExample('filename.m') in PublishDocumentation.m

% JMO Spectrum Library, 2025. See https://github.com/JuliusMuschaweck/JMO_Spectrum
% I dedicate the JMO_Spectrum library to the public domain under Creative Commons Zero
% (https://creativecommons.org/publicdomain/zero/1.0/legalcode)
%

function rv = CIE_xy_from_uv(uv,varargin)
    if nargin == 1
        if isstruct(uv)
            if isfield(uv,'u') && isfield(uv,'v')
                rv = uv;
            else
                error('CIE_xy_from_uv: when uv argument is struct, then must have scalar real fields u and v');
            end
        else
            if isnumeric(uv) && numel(uv) == 2
                rv.up = uv(1);
                rv.vp = uv(2);
            else
                error('CIE_xy_from_uv: with only uv argument, uv must be struct with scalar real fields u and v, or real vector of length 2');
            end
        end
    else
        if ~(isscalarreal(uv) && isscalarreal(varargin{1}))
            error('CIE_uv: With two arguments, both must be scalar reals');
        end
        rv.u = uv;
        rv.v = varargin{1};
    end
        % # python:
        % from sympy import *
        % x, y, u, v = symbols('x y u v')
        % eq1 = u - 4 * x / (-2*x + 12*y + 3)
        % eq2 = v - 6 * y / (-2*x + 12*y + 3)
        % solve([eq1,eq2],[x,y])
        % #     answer
        % #         {x: 3*u/(2*u - 8*v + 4), y: v/(u - 4*v + 2)}
    
    den = 2 * rv.u - 8 * rv.v + 4;
    rv.x = 3 * rv.u ./ den;
    rv.y = 2 * rv.v ./ den;
    rv.up = rv.u;
    rv.vp = rv.v * 3 / 2;
end

function rv = isscalarreal(rhs)
    rv = isscalar(rhs) && isnumeric(rhs) && isreal(rhs);
end