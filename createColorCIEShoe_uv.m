clear;
load('RGBColorShoeImage.mat','rgbimg2'); % x-y from 0..1 in 501 steps

nu = 501;
nv = 501;
iu = linspace(0,1,nu);
iv = linspace(0,1,nv);
[uu,vv] = meshgrid(iu, iv);
xx = uu;
yy = vv;
%%
tmp = CIE_xy_from_uv(struct('u',uu,'v',vv));

ured = interp2(xx, yy, rgbimg2(:,:,1), tmp.x,tmp.y,'linear',1);
ugreen = interp2(xx, yy, rgbimg2(:,:,2), tmp.x,tmp.y,'linear',1);
ublue = interp2(xx, yy, rgbimg2(:,:,3), tmp.x,tmp.y,'linear',1);

rgb_uv_img = cat(3,ured, ugreen, ublue);

%%
figure(11);
clf;
        im = image([0 1],[1 0],flipud(rgb_uv_img));
        alph = 1 - (sum(flipud(rgb_uv_img),3) == 3); % set white to transparent
        im.AlphaData = alph;
        set(gca,'ydir','normal');

%%
load('RGBColorShoeImage.mat','rgb_upvp_img'); 

save('RGBColorShoeImage.mat',"rgbimg2","rgb_uv_img","rgb_upvp_img");

