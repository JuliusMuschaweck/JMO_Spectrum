% read background and display
im = imread('CVG_Background.png');
fh = figure(1);clf;
% flipud and YDir = normal to avoid reversed y axis
imshow(flipud(im),'XData',[-1.5,1.5],'YData',[-1.5,1.5]);
axis on;
hold on;
ax = gca;
ax.YDir = 'normal';
fh.Position(3) = 800;
fh.Position(4) = 800;
% center cross
mygray = 128/255 * [1,1,1];
scatter(0,0,36,mygray,'+');
% radial lines
hueAngles = linspace(0,2*pi,17);
hueAngles = hueAngles(1:end-1);
for i = 1:16
    lims = [0.15, 1.5];
    x = cos(hueAngles(i)) * lims;
    y = sin(hueAngles(i)) * lims;
    plot(x,y,'--',Color=mygray);
end
markerAngles = hueAngles + pi/16;
for i = 1:16
    d = 1.43;
    x = d * cos(markerAngles(i))-0.02;
    y = d * sin(markerAngles(i));
    text(x,y,num2str(i),FontSize=16,Color=mygray);
end
% ref circle
angles = linspace(0,2*pi,181);
plot(cos(angles), sin(angles),'k','LineWidth',2);
for fac = [0.8,0.9,1.1,1.2]
    plot(fac*cos(angles), fac*sin(angles),'w','LineWidth',1);
end

% test graph
% sample test values from TM30 xls
xtest = [0.79, 0.68, 0.39, 0.09, -0.26, -0.53, -0.76, -0.87,...
    -0.87, -0.72, -0.47, -0.17, 0.13, 0.45, 0.60, 0.86];
ytest = [0.13, 0.55, 0.86, 1.02, 1.03, 0.87, 0.57, 0.23, ...
    -0.20, -0.60, -0.88, -1.03, -1.06, -0.93, -0.74, -0.27];
% smooth 
xxxtest = cat(2,xtest,xtest,xtest);
yyytest = cat(2,ytest,ytest,ytest);
aaangles = cat(2,markerAngles-2*pi,markerAngles,markerAngles+2*pi);
x_test_smooth = interp1(aaangles,xxxtest,angles,'makima');
y_test_smooth = interp1(aaangles,yyytest,angles,'makima');
plot(x_test_smooth,y_test_smooth,Color=[240,80,70]/255,LineWidth=3);

% arrows
xref = cos(markerAngles);
yref = sin(markerAngles);
dx = xtest - xref;
dy = ytest - yref;
% colors of arrows, copied from xls
arrowColors = ...
    [230 40 40;      231 75 75;     251 129 46;      255 181 41;
     203 202 70;     126 185 76;    65 192 109;     0 156 124;
     22 188 176;     0 164 191;     0 133 195;     59 98 170;
     109 104 174;     106 78 133;     157 105 161;     167 79 129]...
     / 255;
for i = 1:16
    Arrow(xref(i),yref(i),xtest(i),ytest(i),arrowColors(i,:));
end

% Rf etc
Rf = 81;
Rg = 90;
iCCT = 6425;
duv = 0.0072;

text(-1.4,1.37,sprintf('%.0f',Rf),FontSize=24,Color=[0,0,0],FontWeight="bold");
text(-1.4,1.23,'R_f',FontSize=16,Color=[0,0,0],FontAngle='italic');
text(-1.4,-1.37,sprintf('%.0f K',iCCT),FontSize=24,Color=[0,0,0],FontWeight="bold");
text(-1.4,-1.23,'CCT',FontSize=16,Color=[0,0,0]);

text(1.4,1.37,sprintf('%.0f',Rg),FontSize=24,Color=[0,0,0],FontWeight="bold",HorizontalAlignment="right");
text(1.4,1.23,'R_g',FontSize=16,Color=[0,0,0],FontAngle='italic',HorizontalAlignment="right");
text(1.4,-1.37,sprintf('%.4f',duv),FontSize=24,Color=[0,0,0],FontWeight="bold",HorizontalAlignment="right");
text(1.4,-1.23,'D_{uv}',FontSize=16,Color=[0,0,0],FontAngle='italic',HorizontalAlignment="right");
axis equal;
axis tight;
axis off;

% disclaimer
disclaimer = true;
if disclaimer
    text(0,-1.6,'Colors are for visual orientation purposes only',FontSize=14,HorizontalAlignment='center');
    text(0,-1.7,'Created with JMO Spectrum Library',FontSize=14,HorizontalAlignment='center');
    
end

function Arrow(x0, y0, x1, y1, color)
    plot([x0,x1],[y0,y1],Color=color,LineWidth=2);
    aa = 160*pi/180;
    rot = [cos(aa),sin(aa);-sin(aa),cos(aa)];
    dxy = rot * [x1-x0;y1-y0];
    dxy = 0.04 * dxy / norm(dxy);
    plot([x1,x1+dxy(1)],[y1,y1+dxy(2)],Color=color,LineWidth=2);
    rot = rot';
    dxy = rot * [x1-x0;y1-y0];
    dxy = 0.04 * dxy / norm(dxy);
    plot([x1,x1+dxy(1)],[y1,y1+dxy(2)],Color=color,LineWidth=2);
end


