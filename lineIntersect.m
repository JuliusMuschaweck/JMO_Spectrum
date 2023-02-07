function [rv, alpha, beta] = lineIntersect(p0, p1, q0, q1) 
    % input: 2D points, lines from p0 to p1 and from q0 to q1
    % output: rv: 2D intersection point, 
    % alpha: such that rv == p0 + alpha * (p1-p0)
    % beta:  such that rv == q0 + beta * (q1-q0)
    hp0 = [p0(1), p0(2), 1]; % homogeneous coordinates
    hp1 = [p1(1), p1(2), 1];
    hq0 = [q0(1), q0(2), 1];
    hq1 = [q1(1), q1(2), 1];
    % https://math.stackexchange.com/questions/3371561/given-coordinates-of-two-lines-which-intersect-when-one-line-is-extended-how-to
    hx = cross(cross(hp0,hp1),cross(hq0,hq1));
    if hx(3) == 0
        rv = nan(1,2);
        alpha = nan(1);
        beta = nan(1);
    else
        rv = [hx(1),hx(2)] / hx(3); %de-homogenize
        if (rv == p0)
            alpha = 0;
        else
            alpha = (p1-p0) * (rv-p0)' / ((p1-p0) * (p1-p0)');
        end
        if (rv == q0)
            beta = 0;
        else
            beta = (q1-q0) * (rv-q0)' / ((q1-q0) * (q1-q0)');
        end
    end
end

%% test
function test()
    [rv3,alpha3,beta3] = lineIntersect([0,10],[10,0],[-5,-5],[10,10])
    [rv,alpha,beta] = lineIntersect([0,0],[0,1],[0,0],[1,0])
    [rv2,alpha2,beta2] = lineIntersect([0,0],[0,1],[-1,0],[0,0])
end
