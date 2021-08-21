function ExampleShiftToLdom()
    blue = ReadLightToolsSpectrumFile('blue.sre');
    blueLdom = LDomPurity(blue);
    newLdom = 460;
    delta_ldom = newLdom - blueLdom;
    [shiftedBlue, delta_lam] = ShiftToLdom(blue, newLdom);
    fprintf('original ldom = %g, new ldom = %g\n',blueLdom, newLdom);
    fprintf('ldom shift = %g achieved by wavelength shift = %g\n',delta_ldom, delta_lam);
    figure();
    hold on;
    plot(blue.lam, blue.val,'b','LineWidth',2);
    plot(shiftedBlue.lam, shiftedBlue.val,'b--','LineWidth',2);
    plot([blueLdom, blueLdom],[0,1],'b');
    plot([newLdom, newLdom],[0,1],'b--');    
    legend({'original blue','shifted blue','original ldom', 'shifted ldom'});
    xlabel('\lambda (nm)');
    title('ShiftToLdom example');
end