% Test the MacAdamEllipse algorithm by comparing to OSRAM ColorChecker results

clear;
testitem1.x = 0.2;
testitem1.y = 0.4;
testitem1.nSteps = 10;
testitem1.nPoints = 32;
testitem1.OSRAM_x = [0.2176,0.2178,0.2174,0.2163,0.2145,0.2122,0.2094,0.2063,0.2029,...
    0.1994,0.1960,0.1926,0.1896,0.1870,0.1848,0.1833,0.1824,0.1822,0.1826,0.1837,...
    0.1855,0.1878,0.1906,0.1937,0.1971,0.2006,0.2040,0.2074,0.2104,0.2130,0.2152,0.2167];
testitem1.OSRAM_y = [0.3988,0.4069,0.4147,0.4220,0.4284,0.4338,0.4378,0.4404,0.4415,...
    0.4409,0.4388,0.4352,0.4302,0.4241,0.4170,0.4093,0.4012,0.3931,0.3853,0.3780,0.3716,...
    0.3662,0.3622,0.3596,0.3585,0.3591,0.3612,0.3648,0.3698,0.3759,0.3830,0.3907];
testitem1.OSRAM_a = 4.156803215e-03;
testitem1.OSRAM_b = 1.766008956e-03;
testitem1.OSRAM_theta_deg = 85.975;
testitem1.OSRAM_g11 = 3.193426921e+05;
testitem1.OSRAM_g12 = - 3.679834504e+04 / 2;
testitem1.OSRAM_g22 = 5.916839758e+04;

testitem2.x = 0.3333;
testitem2.y = 0.3333;
testitem2.nSteps = 10;
testitem2.nPoints = 32;
testitem2.OSRAM_x = [0.3433,0.3460,0.3483,0.3499,0.3510,0.3513,0.3510,0.3500,0.3483,...
    0.3460,0.3433,0.3402,0.3368,0.3333,0.3298,0.3264,0.3233,0.3206,0.3183,0.3167,...
    0.3156,0.3153,0.3156,0.3166,0.3183,0.3206,0.3233,0.3264,0.3298,0.3333,0.3368,0.3402];
testitem2.OSRAM_y = [0.3281,0.3338,0.3395,0.3450,0.3500,0.3543,0.3579,0.3605,0.3621,...
    0.3626,0.3619,0.3601,0.3573,0.3536,0.3491,0.3440,0.3385,0.3328,0.3271,0.3216,...
    0.3166,0.3123,0.3087,0.3061,0.3045,0.3040,0.3047,0.3065,0.3093,0.3130,0.3175,0.3226];
testitem2.OSRAM_a = 3.246170125e-03;
testitem2.OSRAM_b = 1.127444566e-03;
testitem2.OSRAM_theta_deg = 62.502;
testitem2.OSRAM_g11 = 6.392236813e+05;
testitem2.OSRAM_g12 = -5.666589199e+05 / 2;
testitem2.OSRAM_g22 = 2.423752258e+05;

testitem3.x = 0.15;
testitem3.y = 0.5;
testitem3.nSteps = 10;
testitem3.nPoints = 32;
testitem3.OSRAM_x = [0.1737,0.1720,0.1694,0.1660,0.1621,0.1576,0.1529,0.1481,0.1434,...
    0.1389,0.1348,0.1313,0.1285,0.1266,0.1256,0.1255,0.1263,0.1280,0.1306,0.1340,...
    0.1379,0.1424,0.1471,0.1519,0.1566,0.1611,0.1652,0.1687,0.1715,0.1734,0.1744,0.1745];
testitem3.OSRAM_y = [0.5030,0.5131,0.5227,0.5313,0.5388,0.5448,0.5491,0.5515,0.5519,...
    0.5503,0.5468,0.5415,0.5345,0.5263,0.5170,0.5071,0.4970,0.4869,0.4773,0.4687,...
    0.4612,0.4552,0.4509,0.4485,0.4481,0.4497,0.4532,0.4585,0.4655,0.4737,0.4830,0.4929];
testitem3.OSRAM_a = 5.230503718e-03;
testitem3.OSRAM_b = 2.390276564e-03;
testitem3.OSRAM_theta_deg = 97.297;
testitem3.OSRAM_g11 = 1.727924031e+05;
testitem3.OSRAM_g12 =  3.489226817e+04 / 2;
testitem3.OSRAM_g22 = 3.878620405e+04;



rv = TestItem(testitem1, 1);
rv = TestItem(testitem2, 2);
rv = TestItem(testitem3, 3);


function rv = TestItem(ti, fignum)
    [ell, g, a, b, theta_deg] = MacAdamEllipse(ti.x, ti.y, ti.nSteps, ti.nPoints);
    rv.dg11 = (g(1,1) - ti.OSRAM_g11) / ti.OSRAM_g11;
    rv.dg12 = (g(2,1) - ti.OSRAM_g12) / ti.OSRAM_g12;
    rv.dg22 = (g(2,2) - ti.OSRAM_g22) / ti.OSRAM_g11;
    fprintf('%g Step MacAdam ellipse around (x,y) = (%g, %g), with %g points\n',...
        ti.nSteps, ti.x, ti.y, ti.nPoints);
    fprintf('Compare JMO results vs. OSRAM Color Calculator results\n');
    fprintf('(g11, g12, g22) = (%g, %g, %g)\n',g(1,1), g(1,2), g(2,2));
    fprintf('relative error of (g11, g12, g22) = (%0.6f, %0.6f, %0.6f)\n',rv.dg11, rv.dg12, rv.dg22);
    fprintf('(a,b,theta) = (%g, %g, %g)\n',a, b, theta_deg);
    rv.da = (a - ti.OSRAM_a) / ti.OSRAM_a;
    rv.db = (b - ti.OSRAM_b) / ti.OSRAM_b;
    rv.dtheta_deg = theta_deg - ti.OSRAM_theta_deg;
    fprintf('relative error of (a, b) = (%0.6f, %0.6f)\n',rv.da, rv.db);
    fprintf('error of theta (degree): %g\n',rv.dtheta_deg);
    fprintf('\n');
    
    if fignum > 0
        figure(fignum);
        clf;
        hold on;
        scatter(ti.x,ti.y,'x');
        plot(ell(1,:),ell(2,:),'r');
        plot(ti.OSRAM_x,ti.OSRAM_y,'g--');
        legend({'center','JMO','OSRAM'});
        axis equal;
    end
end



