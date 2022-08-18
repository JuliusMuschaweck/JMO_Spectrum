function ExampleVlambda()
    vlam = Vlambda();
    figure();
    plot(vlam.lam, vlam.val);
    xlabel('\lambda (m)');
    title('The V(\lambda) eye sensitivity curve');
    narrow = 520:590;
    sample = Vlambda(narrow);
    figure();
    plot(narrow, sample);
    xlabel('\lambda (m)');
    title('The V(lambda) curve around its peak');
    fprintf('The interpolated value of the V(lambda) curve at 417.56 nm is %g\n', Vlambda(417.56));
end