%% Vlambda
% 
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp; 
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp;
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp; 
% <a href="GroupedList.html"> Grouped list</a> &nbsp; | &nbsp; 
% Source code: <a href = "file:../Vlambda.m"> Vlambda.m</a>
% </p>
% </html>
%
% returns spectrum (fields lam and val) for Vlambda with |lam == 360:830|
%% Syntax
% |rv = Vlambda( optional_lam )|
%
%% Input Arguments
%
% |optional_lam|: Optional, vector of double. The idea is that these are wavelengths, but unlike the wavelengths in a spectrum, these
% values don't need to be ascending or positive.
%
%% Output Arguments
% * |rv|: When there is no |optional_lam| argument, |rv| is a spectrum struct, with |rv.lam == 360:830| and |rv.val| the standardized
% V(lambda) values, and an appropriate |rv.name| field. When |optional_lam| is present, rv is a vector of double, same length as |lam|. The interpolated values.
%% Algorithm
% With no input argument: Calls <CIE1931_Data.html CIE1931_Data> to retrieve V(lambda) as the y color matching
% function and returns it, as a valid spectrum struct. When there is an input argument, effectively calls |EvalSpectrum|
% to obtain the interpolated values and returns those.
%% See also
% <CIE1931_Data.html CIE1931_Data> <CIE1931_XYZ.html CIE1931_XYZ>
%% Usage Example
% <include>Examples/ExampleVlambda.m</include>

% publish with publishWithStandardExample('filename.m') in PublishDocumentation.m

% JMO Spectrum Library, 2021. See https://github.com/JuliusMuschaweck/JMO_Spectrum
% I dedicate the JMO_Spectrum library to the public domain under Creative Commons Zero 
% (https://creativecommons.org/publicdomain/zero/1.0/legalcode)
%
function rv = Vlambda( varargin )
    if nargin > 0
        if nargin ~= 1 
            error('Vlambda: call with zero or one parameters');
        end
        lam = varargin{1};
        if isreal(lam) && (isscalar(lam) || isvector(lam))
            vl = Vlambda();
            rv = EvalSpectrum(vl, lam);
        else
            error('Vlambda: call with real array');
        end
    else
        iXYZ = CIE1931_Data();
        rv.lam = iXYZ.lam;
        rv.val = iXYZ.y;
        rv.name = 'V(lambda)';
    end
end