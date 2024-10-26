function ExampleIESTM30()
    rgb = CIE_Illuminant("LED-RGB1");  % warm white mixed from r, g, b LEDs  
    tm30 = IES_TM30( Spectrum = rgb );

    fprintf("Fidelity index Rf: %.1f, Gamut index Rg: %.1f\n",...
        tm30.FidelityIndex(), tm30.GamutIndex());

    % plot the test and reference spectra as required for the report
    spg = tm30.SpectrumGraphics(RelativeScale="peak");
    %   use this to export vector graphics to eps
    % exportgraphics(spg.ax,'SpectrumGraphics.eps','ContentType','vector');
    %   use this to export raster image to png format
    % exportgraphics(spg.ax,'SpectrumGraphics.png');
    %   you can use Width=1000 or Resolution=300 parameters to get higher
    %   resolution if needed. See exportgraphics documentation for details
    
    % plot the color vector graphics circle -> this is the simple report
    cvg = tm30.ColorVectorGraphic(Disclaimer=true,DisclaimerTime=true)

    % plot the local chroma shift, local hue shift and local fidelity graphs
    Rch = tm30.LocalChromaHueShiftFidelityGraphics(xLabels=[false, false, true],...
        relBarWidth=0.9*[1,1,1], mValues=[true,false,false])

    % plot the individual fidelity graph
    ivg = tm30.IndividualFidelityGraphics()

    % % this is how you would create the "full" report 
    % tm30.CreateFullReport(...
    %             Source = "CIE standard illuminant LED-RGB1",...
    %             Manufacturer  = "Simulated spectrum",...
    %             Model  = "n. a.",...
    %             Notes = ("IES TM-30 demonstration using a CIE standard illuminant " + ...
    %                     "with rather bad color rendering properties"),...
    %             ReportFileName = "IES_TM30_CIE_LED-RGB1.pdf");
end