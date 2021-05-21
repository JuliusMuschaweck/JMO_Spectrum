%% MakeSpectrumDirect
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

function rv = MakeSpectrumDirect(lam, val, opts)
    arguments
        lam (:,1) double
        val (:,1) double
        opts.XYZ (1,1) logical = false
    end
    rv = struct('lam',lam(:),'val',val(:));
    if opts.XYZ
        rv.XYZ = CIE1931_XYZ(rv);
    end
end