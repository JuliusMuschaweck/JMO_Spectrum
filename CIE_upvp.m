%% CIE_upvp
%
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp;
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp;
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp;
% <a href="GroupedList.html"> Grouped list</a> &nbsp; | &nbsp; 
% Source code: <a href = "file:../CIE_upvp.m"> CIE_upvp.m</a>
% </p>
% </html>
%
% Conputes CIE u, v, u' and v' color coordinates from CIE x, y
%% Syntax
% |rv = CIE_upvp(xy,varargin)|
%% Input Arguments
% * |xy|: May be (i) a struct with scalar real fields |x| and |y| (such as returned from <CIE1931_XYZ.html CIE1931_XYZ>), (ii) a
% real vector of length 2 (row or column), interpreted as x and y, or (iii) a scalar real, interpreted as x. In case
% (iii), there must be a second argument, scalar real, interpreted as y.
% * |varargin|: scalar real, the y value. Only allowed if |xy| is a scalar real (the x value).
%% Output Arguments
% * |rv|: A |struct| with fields |u|, |v|, |up|, |vp|. When |xy| input is struct, |rv| is a copy of |xy| with these
% fields added.
%% Algorithm
% Applies the formulas of the CIE 1960 and CIE 1964 uniform color spaces to perform the projective transformation from
% x,y.
%% See also
% <CIE1931_XYZ.html CIE1931_XYZ> <CIE_xy_from_upvp.html CIE_xy_from_upvp>
%% Usage Example
% <include>Examples/ExampleCIE_upvp.m</include>

% publish with publishWithStandardExample('filename.m') in PublishDocumentation.m

% JMO Spectrum Library, 2021. See https://github.com/JuliusMuschaweck/JMO_Spectrum
% I dedicate the JMO_Spectrum library to the public domain under Creative Commons Zero
% (https://creativecommons.org/publicdomain/zero/1.0/legalcode)
%

function rv = CIE_upvp(xy,varargin)
    if nargin == 1
        if isstruct(xy)
            if isfield(xy,'x') && isfield(xy,'y')
                rv = xy;
            else
                error('CIE_upvp: when xy argument is struct, then must have scalar real fields x and y');
            end
        else
            if isnumeric(xy) && numel(xy) == 2
                rv.x = xy(1);
                rv.y = xy(2);
            else
                error('CIE_upvp: with only xy argument, xy must be struct with scalar real fields x and y, or real vector of length 2');
            end
        end
    else
        if ~(isscalarreal(xy) && isscalarreal(varargin{1}))
            error('CIE_upvp: With two arguments, both must be scalar reals');
        end
        rv.x = xy;
        rv.y = varargin{1};
    end
    den = -2 * rv.x + 12 * rv.y + 3;
    rv.up = 4 * rv.x ./ den;
    rv.vp = 9 * rv.y ./ den;
    rv.u = rv.up;
    rv.v = 6 * rv.y ./ den;
end

function rv = isscalarreal(rhs)
    rv = isscalar(rhs) && isnumeric(rhs) && isreal(rhs);
end