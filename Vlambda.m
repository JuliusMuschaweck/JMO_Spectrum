%% Vlambda
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
function rv = Vlambda()
    % return spectrum (fields lam and val) for Vlambda with lam == 360:830
    persistent iXYZ;
    if isempty(iXYZ)
        load('CIE1931_lam_x_y_z.mat','CIE1931XYZ');
        iXYZ = CIE1931XYZ;
    end
    rv.lam = iXYZ.lam;
    rv.val = iXYZ.y;
    rv.name = 'V(lambda)';
end