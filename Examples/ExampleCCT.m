function ExampleCCT()
    T = 5704;
    s = CIE_Illuminant_D(T);
    testT = CCT(s);
    fprintf('Testing CCT for CIE Illuminant D for %g K.\n',T);
    fprintf('CCT = %g K, difference is %g K\n',testT, testT-T);

    ps = PlanckSpectrum(360:830,T);
    testTp = CCT(ps);
    fprintf('Testing CCT for Planck spectrum at %g K.\n',T);
    fprintf('CCT = %g K, difference is %g K\n',testTp, testTp-T);
    
end