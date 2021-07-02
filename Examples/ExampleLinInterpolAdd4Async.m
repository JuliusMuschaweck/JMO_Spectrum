function ExampleLinInterpolAdd4Async()
    s1 = GaussSpectrum(400:700, 450, 20);
    s2 = GaussSpectrum(400:20:600, 500, 30);
    s3 = PlanckSpectrum(380:5:780, 5600);
    s4 = CIE_Illuminant('D65');

   golden = (1 + sqrt(5)) / 2; % a very irrational number
   xq = 400:golden:700;
   sum = LinInterpolAdd4Async(s1.lam, s1.val, s2.lam, s2.val, s3.lam, s3.val, s4.lam, s4.val, xq);
    
   figure();
   clf;
   hold on;
   plot(s1.lam, s1.val);
   plot(s2.lam, s2.val);
   plot(s3.lam, s3.val);
   plot(s4.lam, s4.val);
   plot(xq, sum);
    
   drawnow;
   % pause(2);
   n = 5000;
   % run some calls to initialize 
   for i = 1:100
       dum = LinInterpolAdd4Async(s1.lam, s1.val, s2.lam, s2.val, s3.lam, s3.val, s4.lam, s4.val, xq);
       dum2 = LinInterpol(s1.lam, s1.val, xq) + LinInterpol(s2.lam, s2.val, xq) + LinInterpol(s3.lam, s3.val, xq) + LinInterpol(s4.lam, s4.val, xq);
   end
   
   tic
   for i = 1:n
       dum2 = LinInterpol(s1.lam, s1.val, xq) + LinInterpol(s2.lam, s2.val, xq) + LinInterpol(s3.lam, s3.val, xq) + LinInterpol(s4.lam, s4.val, xq);
   end
   t_sync = toc;
   fprintf('LinInterpol: %g seconds per call\n',t_sync / n);

   tic
   for i = 1:n
       dum = LinInterpolAdd4Async(s1.lam, s1.val, s2.lam, s2.val, s3.lam, s3.val, s4.lam, s4.val, xq);
   end
   t_async = toc;
   fprintf('LinInterpolAdd4Async: %g seconds per call\n',t_async / n);
   
   
end