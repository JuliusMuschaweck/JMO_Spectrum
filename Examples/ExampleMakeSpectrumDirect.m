function ExampleMakeSpectrumDirect()
    %%
    lam = 400:600;
    center = 500;
    width = 20;
    val = exp( - 0.5 / width^2 * (lam - center).^2);
    s = MakeSpectrumDirect(lam, val, 'XYZ', true)
    s.XYZ
    figure();
    clf;
    hold on;
    plot(s.lam, s.val);
    xlabel('\lambda (nm)');
    ylabel('normalized spectrum');
    title('A Gauss spectrum');
end