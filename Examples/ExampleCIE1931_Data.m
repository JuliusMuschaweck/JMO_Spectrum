function ExampleCIE1931_Data()
    XYZ = CIE1931_Data();
    figure();
    hold on;
    plot(XYZ.lam,XYZ.x,'r');
    plot(XYZ.lam,XYZ.y,'g');    
    plot(XYZ.lam,XYZ.z,'b');
    xlabel('\lambda (nm)');
    legend({'x(\lambda)','y(\lambda)','z(\lambda)'});
    figure();
    plot(XYZ.xBorder,XYZ.yBorder,'k');
    hold on;
    plot(XYZ.Planckx,XYZ.Plancky,'m');
    axis equal;
    axis([0 0.8 0 0.9]);
    xlabel('CIE x');
    ylabel('CIE y');
    title('incomplete CIE color shoe, see PlotCIExyBorder');
end