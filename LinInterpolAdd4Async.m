%% LinInterpolAdd4Async
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