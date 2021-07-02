function ExampleLinInterpol()
    xx = [1 2 4];
    yy = [2,1,2];
    xq = linspace(0,5,26);
    yq = LinInterpol(xx,yy,xq);
    figure();
    hold on;
    plot(xx,yy);
    scatter(xq, yq);
    title('LinInterpol');
    axis([-1, 6 -1,3]);
    legend({'Underlying function','Interpolated values'});
end