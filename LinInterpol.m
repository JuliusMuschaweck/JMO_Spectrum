%% LinInterpol
% 
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp; 
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp;
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp; 
% <a href="GroupedList.html"> Grouped list</a> &nbsp; | &nbsp; 
% Source code: <a href = "file:../LinInterpol.m"> LinInterpol.m</a>
% </p>
% </html>
%
% From tabulated function |yy(xx)|, compute linearly interpolated values at |xq| query points
%% Syntax
% |yq = LinInterpol(xx,yy,xq)|
%% Input Arguments
% * |xx|: double vector, array of |x| values. Must be strictly ascending and have at least length 2 (unchecked preconditions).
% * |yy|: double vector, array of function values. Must have at least same length as |xx| (unchecked precondition); if
% longer, the excess values are ignored.
% * |xq|: double vector, array of query values. Must be strictly ascending if length > 1.
%% Output Arguments
% * |yq|: double vector, same length as |xq|, with linearly interpolated function values for |xq| values inside the |xx|
% range, zero for |xq| values strictly outside the |xx| range.
%% Algorithm
% Computes the same result as Matlab's |interp1(xx, yy, xq, 'linear', 0)|. (In fact, the routine forwards to precisely
% this call if the platform is not a Windows PC or if the routine is used in Gnu Octave). On a Windows PC under Matlab,
% the call is forwarded to a C++ DLL (see the |LinInterpol| subdirectory for the Visual Studio c++ project and source
% code). Using this function is much faster, and much less safe than |interp1|, but within well tested library routines,
% speed is important, because linear interpolation is at the core of many library routines: Whenever two spectra, or a
% spectrum and a weighting function, are used in a routine, linear interpolation is used to "interweave" the wavelength
% arrays.
%% See also
% <LinInterpolAdd4Async.html LinInterpolAdd4Async>
%% Usage Example
% <include>Examples/ExampleLinInterpol.m</include>

% publish with publishWithStandardExample('filename.m') in PublishDocumentation.m

% JMO Spectrum Library, 2021. See https://github.com/JuliusMuschaweck/JMO_Spectrum
% I dedicate the JMO_Spectrum library to the public domain under Creative Commons Zero 
% (https://creativecommons.org/publicdomain/zero/1.0/legalcode)
%
%
function yq = LinInterpol(xx,yy,xq)
    % function yq = LinInterpol(xx,yy,xq)
    % from tabulated function yy(xx), compute linearly interpolated values
    % at query points xq. Return 0 for extrapolation
    % Just like builtin function interp1(xx, yy, xq, 'linear', 0) except
    % that a C++ DLL routine is called which is much faster and much less safe
    % GNU Octave: simply forwards to the interp1 call.
    if (~ispc) || IsOctave()
        yq = interp1(xx, yy, xq, 'linear', 0);
        return;
    end
    iPrepareLinInterpol();
    yq = xq;
    [ok,yq] = calllib('LinInterpol','LinInterpol',yq,xx,yy,xq,length(xx),length(xq));
    if ~(ok == 0)
        code = num2str(ok);
        % try Matlab routine
        try
            yq = interp1(xx,yy,xq,'linear',0);
        catch ME
            error('LinInterpol: C++ routine failed with error code %g, Matlab''s interp1 failed with error %s:%s',code, ME.identifier, ME.message);
        end
    end
end