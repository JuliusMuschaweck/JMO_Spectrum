fh = figure(1);
clf;
PlotCIExyBorder('LineSpec','k','PlotOptions',{'LineWidth',1.5},'Figure',fh);
axis equal;

nx = 501;
ny = 501;
ix = linspace(0,1,nx);
iy = linspace(0,1,ny);
[xx,yy] = meshgrid(ix, iy);

%%

clear XYZ;
purity = nan(ny,nx);
for i = 1:nx
    for j = 1:ny
        XYZ.x = xx(j,i);
        XYZ.y = yy(j,i);
        [~,purity(j,i)] = LDomPurity(XYZ);
    end
end
ok = purity < 1;
%% magenta line
load('CIE1931_lam_x_y_z.mat','CIE1931XYZ');
m360 = [CIE1931XYZ.xBorder(1);CIE1931XYZ.yBorder(1)];
m830 = [CIE1931XYZ.xBorder(end);CIE1931XYZ.yBorder(end)];
ok2 = false(size(ok));

%IsBelow([0.5;1],m360,m830)
for i = 1:nx
    for j = 1:ny
        xy = [xx(j,i);yy(j,i)];
        ok2(j,i) = ~IsBelow(xy,m360,m830);
    end
end
oktot = ok & ok2;


%%
figure(3);
clf;
contour(oktot);

%%

zz = 1 - xx - yy;

xyzarg = cat(2,xx(:),yy(:),zz(:));

rgb = xyz2rgb(xyzarg);
ltz = rgb < 0;
%rgb(ltz) = 0;
rgbimg = reshape(rgb,nx, ny, 3);
for i = 1:nx
    for j = 1:ny
        if ~oktot(j,i)
            rgbimg(j,i,:) = [1 1 1];
        end
    end
end

%%

rgbimg2 = rgbimg;
for i = 1:nx
    for j = 1:ny
       rgbimg2(j,i,:) = rgbimg2(j,i,:) / max(rgbimg2(j,i,:));
    end
end

% save('RGBColorShoeImage.mat','rgbimg2');
fh2 = figure(2);
clf;
image([0 1],[1 0],flipud(rgbimg2));
axis equal;
hold on;
set(gca,'ydir','normal');
PlotCIExyBorder('LineSpec','k','PlotOptions',{'LineWidth',1.5},'Figure',fh2,'TickFontSize',12);
axis([-0.05 0.8 -0.05  0.9]);
set(gca,'FontSize',14);
xlabel('CIE x','FontSize',14);
ylabel('CIE y','FontSize',14);
scatter(0.3333,0.3333);


%%
xyz2rgb([0.7,0.3,0])

%%
function rv = IsBelow(pt, p0, p1)
    dp = pt - p0;
    Cross2D = @(a,b) a(1)*b(2) - a(2)*b(1);
    test = Cross2D(dp,(p1-p0));
    rv = test > 0;
end