function ExampleCIE1964_Data()
    XYZ = CIE1964_Data();
    figure();
    hold on;
    plot(XYZ.lam,XYZ.x,'r');
    plot(XYZ.lam,XYZ.y,'g');    
    plot(XYZ.lam,XYZ.z,'b');
    xlabel('\lambda (nm)');
    legend({'x_{10}(\lambda)','y_{10}(\lambda)','z_{10}(\lambda)'});
    figure();
    plot(XYZ.xBorder,XYZ.yBorder,'k');
    axis equal;
    axis([0 0.8 0 0.9]);
    xlabel('CIE x_{10}');
    ylabel('CIE y_{10}');
    title('incomplete CIE color shoe, see PlotCIExyBorder');
end