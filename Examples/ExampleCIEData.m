function ExampleCIEData()
    % constructor
    ciedata = CIEData();

    % DataList returns a table
    datalist = ciedata.DataList();
    fprintf("entry # 33 of datalist:\n");
    fprintf("ShortName: ""%s"" | Description: ""%s"" | ColumnHeaders: ""%s""\n",...
        datalist.ShortName(33),datalist.Description(33), datalist.ColumnHeaders(33));

    % retrieve single array by short name and index:
    D65lam = ciedata.Column_by_Idx("D65",1); % first column contains wavelength
    D65val = ciedata.Column_by_Idx("D65",2); % second column contains values
    D65 = MakeSpectrum(D65lam, D65val);
    % retrieve single array by short name and index:
    D65lam = ciedata.Column_by_Idx("D65",1); % first column contains wavelength
    D65val = ciedata.Column_by_Idx("D65",2); % second column contains values
    D65_by_idx = MakeSpectrum(D65lam, D65val);
    % do same by short name and column header:
    D65lam = ciedata.Column_by_Header("D65","lam"); % first column contains wavelength
    D65val = ciedata.Column_by_Header("D65","D65"); % second column contains values
    D65_by_header = MakeSpectrum(D65lam, D65val);
    % test equality
    if isequal(D65_by_idx, D65_by_header)
        fprintf("Column_by_Idx and Column_by_Header work\n");
    else
        error("this should not happen");
    end

    % But you don't need to assemble such spectra yourself.
    % Spectra can be retrieved by just short name if there is only one value array
    % and this function decorates the spectrum with name, description and data source
    D65 = ciedata.Spectrum("D65")
    % When there is more than one value array, the column header xor value index 
    % must be specified:
    LED_B1 = ciedata.Spectrum("LEDs_1nm",columnHeader = "LED-B1");
    figure(); clf; hold on; grid on;
    PlotSpectrum(D65);
    PlotSpectrum(LED_B1);
    legend({D65.name, LED_B1.name});
end