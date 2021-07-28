%% LinInterpolAdd4Async
% 
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp; 
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp;
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp; 
% <a href="GroupedList.html"> Grouped list</a> &nbsp; | &nbsp; 
% Source code: <a href = "file:../LinInterpolAdd4Async.m"> LinInterpolAdd4Async.m</a>
% </p>
% </html>
%
% From four tabulated functions |yy0(xx0) ... yy3(xx3)|, compute the sum of the four interpolated functions over the same
% query grid |xq|, using four processors in parallel
%% Syntax
% |yq = LinInterpolAdd4Async(xx0,yy0,xx1,yy1,xx2,yy2,xx3,yy3,xq)|
%% Input Arguments
% * |xx0|: double vector, array of |x| values. Must be strictly ascending and have at least length 2 (unchecked preconditions).
% * |yy0|: double vector, array of function values. Must have at least same length as |xx0| (unchecked precondition); if
% longer, the excess values are ignored.
% * |xx1, xx2, xx3|: same as |xx0| for the other three functions 
% * |yy1, yy2, yy3|: same as |yyx0| for the other three functions 
% * |xq|: double vector, array of query values. Must be strictly ascending if length > 1
%% Output Arguments
% * |yq|: double vector, same length as |xq|, the sum of values the four individual interpolated functions at |xq|
%% Algorithm
% Computes the same result as Matlab's |interp1(xx0, yy0, xq, 'linear', 0) + interp1(xx1, yy1, xq, 'linear', 0) + interp1(xx2, yy2, xq, 'linear', 0)
% + interp1(xx3, yy3, xq, 'linear', 0)|. (In fact, the routine forwards to precisely
% this call if the platform is not a Windows PC or if the routine is used in Gnu Octave). On a Windows PC under Matlab,
% the call is forwarded to a C++ DLL (see the |LinInterpol| subdirectory for the Visual Studio c++ project and source
% code). In the DLL, multithreading is used. This function may be faster than the synchronous call to |LinInterpol(xx0,yy0,xq) + ... + LinInterpol(xx3,yy3,xq)|, depending on hardware.
%% See also
% <LinInterpol.html LinInterpol>
%% Usage Example
% <include>Examples/ExampleLinInterpolAdd4Async.m</include>

% publish with publishWithStandardExample('filename.m') in PublishDocumentation.m

% JMO Spectrum Library, 2021. See https://github.com/JuliusMuschaweck/JMO_Spectrum
% I dedicate the JMO_Spectrum library to the public domain under Creative Commons Zero 
% (https://creativecommons.org/publicdomain/zero/1.0/legalcode)
%

function yq = LinInterpolAdd4Async(xx0,yy0,xx1,yy1,xx2,yy2,xx3,yy3,xq)
    if IsOctave()
         yq = interp1(xx0,yy0,xq,'linear',0) ...
        +interp1(xx1,yy1,xq,'linear',0)...
        +interp1(xx2,yy2,xq,'linear',0)...
        +interp1(xx3,yy3,xq,'linear',0);
        return;
    end
    libname = 'LinInterpol';
    if ~libisloaded(libname)
        PrepareLinInterpol;
    end
    yq = xq;
    [ok,yq] = calllib(libname,'LinInterpolAdd4Async',yq,xq,length(xq),...
        xx0,yy0,length(xx0),...
        xx1,yy1,length(xx1),...
        xx2,yy2,length(xx2),...
        xx3,yy3,length(xx3));
    if ~(ok == 0)
        error(['LinInterpolAdd4Async: Error code:',num2str(ok)]);
    end
end