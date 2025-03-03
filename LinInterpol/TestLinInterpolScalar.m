clc;
try
    LinInterpolScalar();
catch ME
    fprintf("%s\n",ME.message)
end

try
    LinInterpolScalar(1, [2 3], 2, true);
catch ME
    fprintf("%s\n",ME.message)
end

try
    LinInterpolScalar([1 2], [2 3 4], 2, true);
catch ME
    fprintf("%s\n",ME.message)
end

try
    LinInterpolScalar([1 2], [2 3], "s", true);
catch ME
    fprintf("%s\n",ME.message)
end

try
    LinInterpolScalar([1 2], [2 3], [1 2], true);
catch ME
    fprintf("%s\n",ME.message)
end

try
    % xx = [1, 4];
    % yy = [1, 4];
    xx = [1, 2, 4];
    yy = [1, 2, 4];
    tt_in = @(xq) fprintf("%g == %g? delta = %g\n",xq, LinInterpolScalar(xx, yy, xq, true), xq-LinInterpolScalar(xx, yy, xq, true));
    tt_out = @(xq) fprintf("%g == 0? \n",LinInterpolScalar(xx, yy, xq, true));
    tiny = 1e-13;
    xxq_in = [1, 1 + tiny, 1.5, 2 - tiny, 2, 2 + tiny, 3, 4 - tiny, 4,];
    xxq_out = [0, 1-tiny, 4 + tiny, 5 ];
    for i = 1:numel(xxq_in)
        tt_in(xxq_in(i));
    end
    for i = 1:numel(xxq_out)
        tt_out(xxq_out(i));
    end
catch ME
    fprintf("%s\n",ME.message)
end

xx = (linspace(0,1,101)).^2;
yy = xx;

nq = 100000;

xq = rand(nq, 1);

tic;
for i = 1:nq
    yq = interp1(xx,yy,xq(i));
end
toc

% tic;
% for i = 1:nq
%     yq = LinInterpolScalar(xx,yy,xq(i));
% end
% toc

tic;
for i = 1:nq
    yq = LinInterpol(xx,yy,xq(i));
end
toc