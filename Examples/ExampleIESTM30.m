function ExampleIESTM30()
    rgb = CIE_Illuminant("LED-RGB1");  % warm white mixed from r, g, b LEDs  
    tm30 = IES_TM30( Spectrum = rgb );

    fprintf("Fidelity index Rf: %.1f, Gamut index Rg: %.1f\n",...
        tm30.FidelityIndex(), tm30.GamutIndex());

    % plot the test and reference spectra as required for the report
    spg = tm30.SpectrumGraphics(RelativeScale="peak");
    % exportgraphics(spg.ax,'SpectrumGraphics.eps','ContentType','vector');
    % exportgraphics(spg.ax,'SpectrumGraphics.png');
    
    % plot the color vector graphics circle -> this is the simple report
    cvg = tm30.ColorVectorGraphic(Disclaimer=true,DisclaimerTime=true);

    % % this is how you would create the full report
    % tm30.CreateFullReport(...
    %             Source = "CIE standard illuminant LED-RGB1",...
    %             Manufacturer  = "Simulated spectrum",...
    %             Model  = "n. a.",...
    %             Notes = ("IES TM-30 demonstration using a CIE standard illuminant " + ...
    %                     "with rather bad color rendering properties"),...
    %             ReportFileName = "IES_TM30_CIE_LED-RGB1.pdf");
end