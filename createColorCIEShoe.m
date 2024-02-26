clear;
close all;
fh = figure(1);
clf;
PlotCIExyBorder('LineSpec','k','PlotOptions',{'LineWidth',1.5},'Figure',fh);
axis equal;

nx = 101;
ny = nx;
ix = linspace(0,1,nx);
iy = linspace(0,1,ny);
[xx,yy] = meshgrid(ix, iy);

%%

clear XYZ;
purity = nan(ny,nx);
lDom = nan(ny,nx);
xyBorder = nan(ny,nx,2);
for i = 1:nx
    fprintf('%g/%g ',i,nx);
    if (mod(i,10)==0)
        fprintf('\n');
    end
    for j = 1:ny
        XYZ.x = xx(j,i);
        XYZ.y = yy(j,i);
        [lDom(j,i),purity(j,i),xyBorder(j,i,:)] = LDomPurity(XYZ);
    end
end
ok = purity < 1;

% magenta line

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
insideShoe = ok & ok2;

magenta = insideShoe & (purity < 0);

%%
rainbow = TrueRainbow('floor',1);
i_fullRGB = rainbow.RGBfunc(lDom(:));
fullRed = reshape(i_fullRGB.R, size(lDom));
fullGreen = reshape(i_fullRGB.G, size(lDom));
fullBlue = reshape(i_fullRGB.B, size(lDom));
myRed = (purity .* fullRed + (1-purity)) .* insideShoe;
myGreen = (purity .* fullGreen + (1-purity)) .* insideShoe;
myBlue = (purity .* fullBlue + (1-purity)) .* insideShoe;

i_fullRGB_magenta = rainbow.RGBfunc_magenta(lDom(:));
fullRed_magenta = reshape(i_fullRGB_magenta.R, size(lDom));
fullGreen_magenta = reshape(i_fullRGB_magenta.G, size(lDom));
fullBlue_magenta = reshape(i_fullRGB_magenta.B, size(lDom));
myRed_magenta = (-purity .* fullRed_magenta + (1+purity)) .* magenta;
myGreen_magenta = (-purity .* fullGreen_magenta + (1+purity)) .* magenta;
myBlue_magenta = (-purity .* fullBlue_magenta + (1+purity)) .* magenta;

myRed(magenta) = myRed_magenta(magenta);
myGreen(magenta) = myGreen_magenta(magenta);
myBlue(magenta) = myBlue_magenta(magenta);
%%
figure(21);
imagesc(myRed_magenta);
colorbar;

%%

figure(12);
imagesc(ix, iy, flipud(cat(3,myRed,myGreen,myBlue)));colorbar;
axis equal;
%%
figure(3);
clf;
contourf(insideShoe);

%%

zz = 1 - xx - yy;

rgb = XYZ_to_sRGB( xx,yy,zz);
% ltz = rgb < 0;
%rgb(ltz) = 0;
rgbimgraw = reshape(rgb.RGB,nx, ny, 3);
for i = 1:nx
    for j = 1:ny
        if ~insideShoe(j,i)
            rgbimgraw(j,i,:) = [1 1 1];
        end
    end
end
rgbimg_range = [min(rgbimgraw(:)), max(rgbimgraw(:))];


%%

%% 
% rgbimg_range is [-1.093821147790881,1.342117118768546]
% scale such that max (RGB) == 1 for each pixel
RGB_image = rgbimgraw;
for i = 1:nx
    for j = 1:ny
       RGB_image(j,i,:) = RGB_image(j,i,:) / max(RGB_image(j,i,:));
    end
end
% then clip negative values in the data. In the Matlab image, they are clipped anyway, but we
% want "legal" values
RGB_image(RGB_image < 0 ) = 0; 
clipok = ~(any(RGB_image(:) > 1) && any(RGB_image(:) < 0)); 
% now all RGB_image values are in [0,1];



rgbimg2 = RGB_image;

nup = nx;
nvp = ny;
iup = linspace(0,1,nup);
ivp = linspace(0,1,nvp);
[uu,vv] = meshgrid(iup, ivp);
xx = uu;
yy = vv;
%%
tmp = CIE_xy_from_upvp(struct('up',uu,'vp',vv));

upred = interp2(xx, yy, rgbimg2(:,:,1), tmp.x,tmp.y,'linear',1);
upgreen = interp2(xx, yy, rgbimg2(:,:,2), tmp.x,tmp.y,'linear',1);
upblue = interp2(xx, yy, rgbimg2(:,:,3), tmp.x,tmp.y,'linear',1);

rgb_upvp_img = cat(3,upred, upgreen, upblue);


save('RGBColorShoeImage_trueRainbow.mat','rgbimg2','rgb_upvp_img','insideShoe'); % use "insideShoe" for alpha channel
fh2 = figure(2);
clf;
image([0 1],[1 0],flipud(RGB_image),'AlphaData',flipud(insideShoe));
axis equal;
hold on;
set(gca,'ydir','normal');
PlotCIExyBorder('LineSpec','k','PlotOptions',{'LineWidth',1.5},'Figure',fh2,'TickFontSize',12);
axis([-0.05 0.8 -0.05  0.9]);
set(gca,'FontSize',14);
xlabel('CIE x','FontSize',14);
ylabel('CIE y','FontSize',14);
D65 = CIE_Illuminant_D(6500);
D65XYZ = CIE1931_XYZ(D65);
scatter(0.3333,0.3333);
scatter(D65XYZ.x, D65XYZ.y);


%%
figure(4);
imagesc(flipud(RGB_image(:,:,1).*(insideShoe)));
colorbar;
%%
function rv = IsBelow(pt, p0, p1)
    dp = pt - p0;
    Cross2D = @(a,b) a(1)*b(2) - a(2)*b(1);
    test = Cross2D(dp,(p1-p0));
    rv = test > 0;
end