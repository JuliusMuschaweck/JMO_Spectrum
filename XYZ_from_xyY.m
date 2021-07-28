%% XYZ_from_xyY
% 
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp; 
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp;
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp; 
% <a href="GroupedList.html"> Grouped list</a> &nbsp; | &nbsp; 
% Source code: <a href = "file:../XYZ_from_xyY.m"> XYZ_from_xyY.m</a>
% </p>
% </html>
%
% documentation to be completed
%
function rv = XYZ_from_xyY(x, y, Y)
    rv.cw = Y/y;
    rv.x = x;
    rv.y = y;
    rv.z = 1 - x - y;
    rv.X = x * rv.cw;
    rv.Y = Y;
    rv.Z = rv.z * rv.cw;
end