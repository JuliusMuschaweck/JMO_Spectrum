function ExampleCIE_Illuminant_D()
    % plot some CIE D spectra
    figure();
    hold on;
    leg = {};
    for T = [4000, 6000, 10000, 25000]
        s = CIE_Illuminant_D(T,'lam',300:5:830);
        plot(s.lam, s.val)
        leg{end+1} = sprintf('T = %g',T);
    end
    xlabel('\lambda (nm)');
    title('Various CIE D spectra');
    legend(leg);
    
    % compare Planck locus with CIE D color coordinates
    figure()
    hold on;
    pl = PlanckLocus();
    n = 30;
    % inverse temperature is approx. equidistant
    invT = linspace( 1/4000, 1/25000, n);
    T = 1 ./ invT;
    plxy = pl.xy_func(T);
    plot(plxy(:,1), plxy(:,2));
    Dxy = zeros(n,2);
    for i = 1:n
        s = CIE_Illuminant_D(T(i));
        XYZ = CIE1931_XYZ(s);
        Dxy(i,1) = XYZ.x;
        Dxy(i,2) = XYZ.y;
    end 
    plot(Dxy(:,1), Dxy(:,2));
    axis equal;
    grid on;
    xlabel('CIE x');
    xlabel('CIE y');
    title('CIE D is above Planck locus');
    legend('Planck locus', 'CIE D','Location','southeast');
end