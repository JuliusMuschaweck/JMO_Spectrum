function ExampleVlambda()
    vlam = Vlambda();
    figure();
    plot(vlam.lam, vlam.val);
    xlabel('\lambda (m)');
    title('The V(\lambda) eye sensitivity curve');
end