clear;
load('RGBColorShoeImage.mat','rgbimg2'); % x-y from 0..1 in 501 steps

nup = 501;
nvp = 501;
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

%%
figure(11);
clf;
        im = image([0 1],[1 0],flipud(rgb_upvp_img));
        alph = 1 - (sum(flipud(rgb_upvp_img),3) == 3); % set white to transparent
        im.AlphaData = alph;
        set(gca,'ydir','normal');

