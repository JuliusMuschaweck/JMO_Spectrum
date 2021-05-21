function ExampleGaussSpectrum()
    lam = 360:830;
    mean = 530;
    sdev = 50;
    g1 = GaussSpectrum(lam, mean, sdev);
    fprintf('g1.name = %s\n',g1.name);
    figure();
    clf;
    plot(g1.lam, g1.val);
    xlabel('\lambda(nm)');
    title(sprintf('Gauss spectrum with \\mu = %g nm, \\sigma = %g nm\n', mean, sdev));
end