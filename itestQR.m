clear;
A = [1 2 3; 4 5 6; 7 11 13];
cond(A)
[Q, R] = qr(A);
b = [2;3;4]
xx= A\b;
xxqr = R \ (Q' * b);
norm(xx-xxqr)
%%

nn = 100;
AA = rand(nn);
bb = rand(nn,1);

n = 10000;
tic;
for i = 1:n
    xx= AA\bb;
end
toc
[QQ, RR] = qr(AA);
tic;
for i = 1:n
    xxqr = RR \ (QQ' * bb);
end
toc
