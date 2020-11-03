function rv = RainbowColorMap(nn)
% RainbowColorMap(nn) returns a rainbow colormap with nn columns (256 is good)
% nn = 256;
mymap = zeros(nn,3);
ww = round(0.56*nn);
ww2 = round(ww/2);
gamma = 3;
for i = 1:ww
    cB = round(0.25 * nn);
    cG = round(nn/2);
    cR = round(0.75 * nn);
    iR = i + cR - ww2;
    iG = i + cG - ww2;
    iB = i + cB - ww2;
    vv = (sin(i * pi/ww))^2;
    vv = vv ^(1/gamma);
    if iR > 0 && iR <= nn
        mymap(iR,1) = vv;
    end
    if iG > 0 && iG <= nn
        mymap(iG,2) = vv;
    end
    if iB > 0 && iB <= nn
        mymap(iB,3) = vv;
    end
end

rv = mymap;

end