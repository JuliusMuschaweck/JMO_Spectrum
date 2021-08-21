%% CIE_xy_from_upvp
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
% Conputes CIE x, y, u, and v color coordinates from CIE u', v'
%% Syntax
% |rv = CIE_xy_from_upvp(upvp,varargin)|
%% Input Arguments
% * |upvp|: May be (i) a struct with real array fields |up| and |vp|, (ii) a
% real vector of length 2 (row or column), interpreted as u' and v', or (iii) a scalar real, interpreted as u'. In case
% (iii), there must be a second argument, scalar real, interpreted as v'.
% * |varargin|: scalar real, the v' value. Only allowed if |upvp| is a scalar real (the u' value).
%% Output Arguments
% * |rv|: A |struct| with fields |x|, |y|, |u|, |v|, |up|, |vp|. When |upvp| input is struct, |rv| is a copy with the
% other fields added.
%% Algorithm
% Applies the formulas of the CIE 1960 and CIE 1964 uniform color spaces to perform the projective transformation from
% u',v'.
%% See also
% <CIE1931_XYZ.html CIE1931_XYZ>, <CIE_upvp.html CIE_upvp>
%% Usage Example
% <include>Examples/ExampleCIE_xy_from_upvp.m</include>

% publish with publishWithStandardExample('filename.m') in PublishDocumentation.m

% JMO Spectrum Library, 2021. See https://github.com/JuliusMuschaweck/JMO_Spectrum
% I dedicate the JMO_Spectrum library to the public domain under Creative Commons Zero
% (https://creativecommons.org/publicdomain/zero/1.0/legalcode)
%

function rv = CIE_xy_from_upvp(upvp,varargin)
    if nargin == 1
        if isstruct(upvp)
            if isfield(upvp,'up') && isfield(upvp,'vp')
                rv = upvp;
            else
                error('CIE_upvp: when upvp argument is struct, then must have scalar real fields up and vp');
            end
        else
            if isnumeric(upvp) && numel(upvp) == 2
                rv.up = upvp(1);
                rv.vp = upvp(2);
            else
                error('CIE_upvp: with only upvp argument, upvp must be struct with scalar real fields up and vp, or real vector of length 2');
            end
        end
    else
        if ~(isscalarreal(upvp) && isscalarreal(varargin{1}))
            error('CIE_upvp: With two arguments, both must be scalar reals');
        end
        rv.up = upvp;
        rv.vp = varargin{1};
    end
    % python:
    %         from sympy import *
    %         x, y, up, vp = symbols('x y up vp')
    %         eq1 = up - 4 * x / (-2*x + 12*y + 3)
    %         eq2 = vp - 9 * y / (-2*x + 12*y + 3)
    %         solve([eq1,eq2],[x,y])
    %     answer
    %         {x: 9*up/(6*up - 16*vp + 12), y: 2*vp/(3*up - 8*vp + 6)}  
    
    den = 6 * rv.up - 16 * rv.vp + 12;
    rv.x = 9 * rv.up ./ den;
    rv.y = 4 * rv.vp ./ den;
    rv.u = rv.up;
    rv.v = rv.vp * 2 / 3;
end

function rv = isscalarreal(rhs)
    rv = isscalar(rhs) && isnumeric(rhs) && isreal(rhs);
end