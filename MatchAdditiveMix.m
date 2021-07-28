%% MatchAdditiveMix
% 
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp; 
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp;
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp; 
% <a href="GroupedList.html"> Grouped list</a> &nbsp; | &nbsp; 
% Source code: <a href = "file:../MatchAdditiveMix.m"> MatchAdditiveMix.m</a>
% </p>
% </html>
%
% Computes weights of three XYZ tristimuli to match a target XYZ tristimulus, with an optional fixed contribution
%% Syntax
% |[rv, Acond] = MatchAdditiveMix(XYZ1, XYZ2, XYZ3, XYZ_target, opts)|
%% Input Arguments
% * |XYZ1, XYZ2, XYZ3|: |struct| s with scalar double fields |X|, |Y| and |Z|: the three input tristimuli
% * |XYZ_target|: |struct| with scalar double fields |X|, |Y| and |Z|: the target tristimulus
% * |opts|: Name-Value pair: |'XYZ_fix'|, another |struct| with scalar double fields |X|, |Y| and |Z|: a fixed
% contribution, such that the sum of |XYZ_fix| and the weighted three |XYZi| tristimuli yield |XYZ_target|.
%
%% Output Arguments
% * |rv|: (3,1) double column vector: the weights such that |[XYZ1.X,XYZ2.X,XYZ3.X] * rv + XYZ_fixed.X == XYZ_target.X|,
% likewise for |Y| and |Z|, within numerical accuracy.
% * |Acond|: scalar double. The condition number of the 3x3 matrix of the equation system: diagnostic information
%% Algorithm
% Sets up the 3x3 linear equation system, and solves it.
%% See also
% <AddWeightedSpectra.html AddWeightedSpectra>, <CIE1931_XYZ.html CIE1931_XYZ>,
% <MatchWhiteLEDSpectrum.html MatchWhiteLEDSpectrum>, <OptimalAdditiveMix.html OptimalAdditiveMix>,
% <XYZ_from_xyY.html XYZ_from_xyY>
%% Usage Example
% <include>Examples/ExampleMatchAdditiveMix.m</include>

% publish with publishWithStandardExample('filename.m') in PublishDocumentation.m

% JMO Spectrum Library, 2021. See https://github.com/JuliusMuschaweck/JMO_Spectrum
% I dedicate the JMO_Spectrum library to the public domain under Creative Commons Zero 
% (https://creativecommons.org/publicdomain/zero/1.0/legalcode)
%

function [rv, Acond] = MatchAdditiveMix(XYZ1, XYZ2, XYZ3, XYZ_target, opts)
    arguments
        XYZ1 (1,1) struct
        XYZ2 (1,1) struct
        XYZ3 (1,1) struct
        XYZ_target (1,1) struct
        opts.XYZ_fix = struct('X', 0, 'Y', 0, 'Z', 0);
    end
    XYZ_fix =  opts.XYZ_fix;
    
    A = [XYZ1.X, XYZ2.X, XYZ3.X;...
         XYZ1.Y, XYZ2.Y, XYZ3.Y;...
         XYZ1.Z, XYZ2.Z, XYZ3.Z];
    b = [XYZ_target.X; XYZ_target.Y; XYZ_target.Z] ...
            - [XYZ_fix.X; XYZ_fix.Y; XYZ_fix.Z];
    rv = A\b;

    Acond = cond(A);
end