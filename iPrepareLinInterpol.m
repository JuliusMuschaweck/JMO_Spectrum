function iPrepareLinInterpol()
    libname = 'LinInterpol';
    if libisloaded(libname)
        return;
    end
%    libDLL = 'C:\USERDATA\Software_JM\Matlab\Include\LinInterpol\LinInterpol\x64\Release\LinInterpol.dll';
    libDLL = 'LinInterpol.dll';
    % libheader = 'C:\USERDATA\Software_JM\Matlab\Include\LinInterpol\LinInterpol\LinInterpol.h';
%    loadlibrary(libDLL,libheader);
    loadlibrary(libDLL, @iLinInterpolProto);
    % libfunctions(libname,'-full')
    
    %%
    xx = 1:5;
    yy = 2:6;
    
    xq = 0.9*(0:6)+0.2;
    yq = xq;
    [ok,yyq] = calllib(libname,'LinInterpol',yq,xx,yy,xq,length(xx),length(xq));
    
end
%%
%unloadlibrary(libname);