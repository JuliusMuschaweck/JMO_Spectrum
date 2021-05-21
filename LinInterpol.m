%% LinInterpol
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