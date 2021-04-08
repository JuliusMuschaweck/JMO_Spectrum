function ExampleCIE_Illuminant()
    names = {'A','C','E','D50','D55','D65','D75','FL1','FL2','FL3','FL4','FL5','FL6','FL7','FL8','FL9','FL10','FL11','FL12',...
        'FL3_1','FL3_2','FL3_3','FL3_4','FL3_5','FL3_6','FL3_7','FL3_8','FL3_9','FL3_10','FL3_11','FL3_12','FL3_13','FL3_14','FL3_15',...
        'HP1','HP2','HP3','HP4','HP5'};
    figure();
    clf;
    hold on;
    for i = 1:length(names)
        ni = names{i};
        si = CIE_Illuminant(ni);
        plot(si.lam, si.val / mean(si.val));
    end
    title('CIE standard illuminants');
    
    figure();
    hold on;
    sA = CIE_Illuminant('A','lam',400:2:700);
    plot(sA.lam, sA.val / max(sA.val));
    sD50 = CIE_Illuminant('D50');
    plot(sD50.lam, sD50.val / max(sD50.val));
    sD5600 = CIE_Illuminant('D','T',5600);
    plot(sD5600.lam, sD5600.val / max(sD5600.val));
    legend({'A','D50','D(5600)'});
end