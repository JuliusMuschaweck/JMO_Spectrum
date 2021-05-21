clear;
load('CIEDE2000TestData_Sharma.mat');
n = length(CIEDE2000TestData_Sharma);
for i = 1:n
    s = CIEDE2000TestData_Sharma{i};
    dE = CIEDE2000_Lab(s.Lab1,s.Lab2);
    diff(i) = dE - s.dE;
end
figure(1);
clf;
scatter(1:n,diff);
xlabel('item number');
ylabel('difference of CIEDE\_2000Lab and Sharma test data');
title('CIEDE2000\_Lab test');

if max(diff) < 5e-5 % test data given with four digits after decimal point
    fprintf('CIEDE2000_Lab works well, max. diff = %g\n',max(diff));
else
    error('CIEDE2000_Lab failed test, max. diff = %g\n',max(diff));
end
