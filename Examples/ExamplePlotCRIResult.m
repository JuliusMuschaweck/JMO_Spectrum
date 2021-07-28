function ExamplePlotCRIResult()
    % a perfect lamps to illuminate: D65
    PlotCRIResult(CIE_Illuminant_D(6500), 'Title',  'Perfect D65', 'Pos_x', 100, 'Pos_y', 10);
    % 3200K Planck
    PlotCRIResult(PlanckSpectrum(360:830,3200),  'Title',  'Planck 3200K', 'Pos_x', 250, 'Pos_y', 10);
    % 4990K Planck
    PlotCRIResult(PlanckSpectrum(360:830,4990),  'Title', 'Planck 4990K', 'Pos_x', 400, 'Pos_y', 10);
    % 5010K Planck: discontinuous
    PlotCRIResult(PlanckSpectrum(360:830,5010),  'Title', 'Planck 5010K', 'Pos_x', 550, 'Background', [0.94 0.94 0.94]);
    % 6500K LED
    PlotCRIResult(ReadLightToolsSpectrumFile('LED_6498K.sre'), 'Title', 'LED 6500K', 'Pos_x', 700);
    % really bad two line spectrum
    baaad = MakeSpectrumDirect([461,462,570,571],[40,0,0,58],'XYZ',true);
    [iCCT, duv] = CCT(baaad);
    PlotCRIResult(baaad, 'Title', 'really bad blue/yellow two line spectrum', 'Pos_x', 850);    
end



