function ExampleRainbowColorMap()
    
    rcm = RainbowColorMap(256);
    
    figure();
    hold on;
    plot(1:256,rcm(:,1),'r');
    plot(1:256,rcm(:,2),'g');
    plot(1:256,rcm(:,3),'b');
    legend({'Red','Green','Blue'});
    title('RainbowColorMap color channels');
    
    figure();
    zz = peaks;
    surf(zz);
    colormap(rcm);
    colorbar;
    title('RainbowColorMap example');
end