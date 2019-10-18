
xx = 400:800;
yy = xx+1;

xq = 360:0.5:830;

n = 5000;
tic;
for i = 1:n
    yyq = LinInterpol(xx,yy,xq);
end
disp(['LinInterpol elapsed time:',num2str(toc/n)]);

tic;
for i = 1:n
    yyq2 = interp1(xx,yy,xq,'linear',0);
end
disp(['interp1 elapsed time: ',num2str(toc/n), ', diffnorm = ',num2str(norm(yyq-yyq2))]);

tic;
for i = 1:n
    yyq = LinInterpolAdd4Async(xx,yy,xx,yy,xx,yy,xx,yy,xq);
end
disp(['LinInterpolAdd4Async elapsed time: ',num2str(toc/n)]);

tic;
for i = 1:n
    yyq2 = LinInterpol(xx,yy,xq) ...
        +LinInterpol(xx,yy,xq)...
        +LinInterpol(xx,yy,xq)...
        +LinInterpol(xx,yy,xq);
end
disp(['4 x LinInterpol elapsed time: ',num2str(toc/n), ', diffnorm = ',num2str(norm(yyq-yyq2))]);


tic;
for i = 1:n
      yyq2 = interp1(xx,yy,xq,'linear',0) ...
        +interp1(xx,yy,xq,'linear',0)...
        +interp1(xx,yy,xq,'linear',0)...
        +interp1(xx,yy,xq,'linear',0);
end
disp(['4 x interp1 elapsed time: ',num2str(toc/n), ', diffnorm = ',num2str(norm(yyq-yyq2))]);







