names = {'LED_B1','LED_B2','LED_B3','LED_B4','LED_B5','LED_BH1','LED_RGB1','LED_V1','LED_V2'};

for i = 1:9
    clear s;
    s.lam = tmp2(:,1);
    s.val = tmp2(:,i+1);
    s.XYZ = CIE1931_XYZ(s);
    eval(['CIE_Standard.',names{i},' = s;']);
end