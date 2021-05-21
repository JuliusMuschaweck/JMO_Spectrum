% the perfect lamps to illuminate: D65
PlotCRIResult(CIE_Illuminant_D(6500), 1, 'Perfect D65', 100);
% 3200K Planck
PlotCRIResult(PlanckSpectrum(360:830,3200), 2, 'Planck 3200K', 130);
% 4990K Planck
PlotCRIResult(PlanckSpectrum(360:830,4990), 3, 'Planck 4990K', 160);

% 5010K Planck: discontinuous
PlotCRIResult(PlanckSpectrum(360:830,5010), 4, 'Planck 5010K', 190);

% 6500K Planck
PlotCRIResult(PlanckSpectrum(360:830,6500), 5, 'Planck 6500K', 220);

% 6500K LED
PlotCRIResult(ReadLightToolsSpectrumFile('LED_6498K.sre'), 6, 'LED 6500K', 250);

baaad = MakeSpectrumDirect([461,462,570,571],[40,0,0,58],'XYZ',true);
[iCCT, duv] = CCT(baaad);
PlotCRIResult(baaad, 7, 'really bad blue/yellow two line spectrum', 280);





