
function ExampleTLCI()
    
    %% Example for TLCI calculation
    %% Define the "ingredients"
    % the TLCI test samples are the first 18 Color Checker fields
    testSamples = ColorCheckerTestSamples(1:18);
    % For white, the TLCI uses 90% reflective white = Color Checker # 19
    whiteSample = ColorCheckerTestSamples(19);
    % the TLCI standard RGB matrix / gamma camera
    camera = TTLCIStdCamera;
    % the standard gamma 2.4 rec709 display
    display = TTLCIDisplay;
    % the standard TLCI way to make a reference spectrum with same CCT
    refSpecGen = TTLCIRefSpectrumGenerator;
    % CIEDE2000 is used to compute color differences
    singleCDC = TCIEDE2000(display);
    % this is the standard TLCI way to use the individual color differences
    aggregateCDC = TTLCIColorDifferenceCalculator;
    
    % The TLIC calculator object
    StandardTLCICalculator = TGenericTLCICalculator(testSamples, whiteSample, camera, ...
        display, refSpecGen, singleCDC, aggregateCDC);
    
    
    %% apply to a really bad two line spectrum
    bad = MakeSpectrum([465 470 475  570 575 580],[0 1 0 0 1.7 0]);
    xy = CIE1931_XYZ(bad);
    [iCCT,iduv] = CCT(bad);
    
    fprintf('Really bad two line spectrum, x/y = %g/%g, CCT = %g, distance to Planck = %g\n',xy.x, xy.y, iCCT, iduv);
    TLCI_result = StandardTLCICalculator.Goodness(bad);
    PlotTLCIResult(TLCI_result, 2, 'really bad two lines')
    
    LEDwhite = ReadLightToolsSpectrumFile('LED_3000K.sre');
    TLCI_result = StandardTLCICalculator.Goodness(LEDwhite);
    PlotTLCIResult(TLCI_result, 3, 'white 3000K LED', 150);
    
    
end