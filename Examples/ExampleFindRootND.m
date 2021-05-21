function ExampleFindRootND()
    figure();
    clf;
    [xx,yy] = meshgrid((-2):0.05:3, (-4):0.05:1);
    zz1 = arrayfun(@(x,y) ff(x,y,1), xx, yy);
    zz2 = arrayfun(@(x,y) ff(x,y,2), xx, yy);
    hold on;
    contour(xx,yy,zz1,[-2, 0, 2],'r','ShowText','on');
    contour(xx,yy,zz2,[-2, 0, 2],'b','ShowText','on');
    
    x0 = [2;-3];
    scatter(x0(1), x0(2),'x');
   
    [rv, ok, info] = FindRootND(@f, x0);
    plot(info.history.x(1,:), info.history.x(2,:), '-x','LineWidth',2)
    plot(info.history.xRestart(1,:), info.history.xRestart(2,:), 'o')

    x0 = [0;0];
    scatter(x0(1), x0(2),'x');
   
    [rv, ok, info] = FindRootND(@f, x0);
    plot(info.history.x(1,:), info.history.x(2,:), '-x','LineWidth',2)
    plot(info.history.xRestart(1,:), info.history.xRestart(2,:), 'o')

    x0 = [-1;0.5];
    scatter(x0(1), x0(2),'x');
   
    [rv, ok, info] = FindRootND(@f, x0);
    plot(info.history.x(1,:), info.history.x(2,:), '-x','LineWidth',2)
    plot(info.history.xRestart(1,:), info.history.xRestart(2,:), 'o')
end

function rv = ff(x, y, i)
    tmp = f([x;y]);
    rv = tmp(i);
end

function rv = f(x)
    xx = x(1);
    yy = x(2);
    rv = [exp(xx) + yy; 2 + yy - xx^2];
end