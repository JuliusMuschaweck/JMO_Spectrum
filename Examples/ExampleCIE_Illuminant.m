function ExampleCIE_Illuminant()
    names_white = {'A','C','E','D50','D55','D65','D75'};
    names_fluorescent= {'FL1','FL2','FL3','FL4','FL5','FL6','FL7','FL8','FL9','FL10','FL11','FL12',...
        'FL3_1','FL3_2','FL3_3','FL3_4','FL3_5','FL3_6','FL3_7','FL3_8','FL3_9','FL3_10','FL3_11','FL3_12','FL3_13','FL3_14','FL3_15'};
    names_highpressure = {'HP1','HP2','HP3','HP4','HP5'};
    names_LEDs = {'LED_B1','LED_B2','LED_B3','LED_B4','LED_B5','LED_BH1','LED_RGB1','LED_V1','LED_V2'};
    
    plot1(names_white, 'Generic white CIE standard illuminants','NorthEastOutside');
    plot1(names_fluorescent, 'Fluorescent CIE standard illuminants','NorthEastOutside');
    plot1(names_highpressure, 'High pressure lamp CIE standard illuminants','NorthEastOutside');
    plot1(names_LEDs, 'LED CIE standard illuminants','NorthEastOutside');
    
end

function plot1(names, ititle, location)
    figure();
    hold on;
    for i = 1:length(names)
        ni = names{i};
        si = CIE_Illuminant(ni);
        plot(si.lam, si.val / mean(si.val));
    end
    title(ititle);
    for i = 1:length(names)
        % make underscores printable in legend
        names{i} = replace(names{i}, '_','\_');
    end
    legend(names,'Location',location);
end