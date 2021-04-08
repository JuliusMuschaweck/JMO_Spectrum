function ExampleCCT_from_xy()
    T = 5704;
    s = CIE_Illuminant_D(T);
    XYZ = CIE1931_XYZ(s);
    testT = CCT_from_xy(XYZ.x, XYZ.y);
    fprintf('Testing CCT_from_xy for CIE Illuminant D for %g K.\n',T);
    fprintf('CCT = %g K, difference is %g K\n',testT, testT-T);

    ps = PlanckSpectrum(360:830,T);
    XYZp = CIE1931_XYZ(ps);
    testTp = CCT_from_xy(XYZp.x, XYZp.y);
   
    fprintf('Testing CCT_from_xy for Planck spectrum at %g K.\n',T);
    fprintf('CCT = %g K, difference is %g K\n',testTp, testTp-T);
    
end