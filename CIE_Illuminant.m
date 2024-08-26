%% CIE_Illuminant
% 
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp; 
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp;
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp; 
% <a href="GroupedList.html"> Grouped list</a> &nbsp; | &nbsp; 
% Source code: <a href = "file:../CIE_Illuminant.m"> CIE_Illuminant.m</a>
% </p>
% </html>
%
% Returns spectrum for CIE standard illuminants, based on official CIE data from <https://cie.co.at/data-tables> .
%% Syntax
% |rv = CIE_Illuminant(name,opts)|
%% Input Arguments
% * |name|: character string. Any of
% |'A';'C';'E','D','D50';'D55';'D65';'D75';'ID50';'ID65';'FL1';'FL2';'FL3';'FL4';'FL5';'FL6';'FL7';'FL8';'FL9';'FL10';'FL11';'FL12';|
% |'FL3.1';'FL3.2';'FL3.3';'FL3.4';'FL3.5';'FL3.6';'FL3.7';'FL3.8';'FL3.9';'FL3.10';'FL3.11';'FL3.12';'FL3.13';'FL3.14';'FL3.15';|
% |'HP1';'HP2';'HP3';'HP4';'HP5'|
% |'LED-B1';'LED-B2';'LED-B3';'LED-B4';'LED-B5';'LED-BH1';'LED-RGB1';'LED-V1';'LED-V2'|. 
% For the |'FL3.x'| spectra, also |'FL3_x'| is accepted (underscore instead of point). 
% For the |'LED-xx'| spectra, also |'LED_xx'| is accepted (underscore instead of dash).   
% * |opts|: name-value pairs. 
%
% <html>
% <p style="margin-left: 25px">
% <table border=1>
% <tr><td> <b>Name</b> </td>      <td><b>Type</b></td>      <td><b>Value</b></td>                <td><b>Default</b></td>   <td><b>Meaning</b></td></tr>
% <tr><td> 'lam' </td>            <td> real vector </td>    <td> valid wavelength array in nm</td>  <td> from CIE data </td> <td> The wavelengths over which the offical illuminant will be interpolated
% <tr><td> 'T'   </td>            <td> real scalar </td>    <td> 4000 <= T <= 25000          </td>  <td> none </td> <td> When |name == 'D'|, this is the CCT for illuminant D (daylight) 
% </table></p>
% </html>

%% Output Arguments
% * |rv|: A spectrum with fields |lam| (a copy of the input argument), |val| (the spectrum values), |name| (an
% appropriate name), and |description|, (a description).
%% Algorithm
% For all except |'D'| or |'E'|, retrieves the data from |CIE_Standard_Illuminants.mat|, searches the appropriate
% standardized spectrum, and interpolates it over input argument |lam|. For illuminant |'D'|, calls
% <CIE_Illuminant_D.html CIE_Illuminant_D>. For |'E'|, creates a flat, all |val(i) == 1| spectrum over input argument
% |lam| (or |[360;830]| if not given).
%
% The wavelength ranges in the standard are 300 nm to 780 nm in 5 nm steps for
% |'A';'C';'E','D','D50';'D55';'D65';'D75'|, and 380 nm to 780 nm in 5 nm steps for all |FLxx| and |HPx| and |LEDx| spectra. For
% |'D'|, the wavelength range of the standard is 300 nm to 830 nm in 5 nm steps. 
%
%% See also
% <CIE_Illuminant_D.html CIE_Illuminant_D>
%% Usage Example
% <include>Examples/ExampleCIE_Illuminant.m</include>

% publish with publishWithStandardExample('filename.m') in PublishDocumentation.m

% JMO Spectrum Library, 2021. See https://github.com/JuliusMuschaweck/JMO_Spectrum
% I dedicate the JMO_Spectrum library to the public domain under Creative Commons Zero 
% (https://creativecommons.org/publicdomain/zero/1.0/legalcode)
%
function rv = CIE_Illuminant(name,opts)
    % Compute CIE standard illuminant D for color temperature CCT, for 360:830 nm. Optional 'lam',lam
    % 20.8.24: Now from official CIE data
    arguments
        name (1,1) string
        opts.lam (:,1) double = [] % original lam from CIE when empty
        opts.T (1,1) double = NaN % must be given for "D"
    end
    persistent dict;
    if isempty(dict)
        columnHeaders = ["A","C","D50","D55","D65","D75","ID50","ID65",...
            "FL1","FL2","FL3","FL4","FL5","FL6","FL7","FL8","FL9","FL10",...
            "FL11","FL12","FL3.1","FL3.2","FL3.3","FL3.4","FL3.5","FL3.6",...
            "FL3.7","FL3.8","FL3.9","FL3.10","FL3.11","FL3.12","FL3.13",...
            "FL3.14","FL3.15","HP1","HP2","HP3","HP4","HP5","LED-B1",...
            "LED-B2","LED-B3","LED-B4","LED-B5","LED-BH1","LED-RGB1",...
            "LED-V1","LED-V2"];
        shortNames = ["A","C","D50","D55","D65","D75","ID50","ID65",...
            "FLs_1nm","FLs_1nm","FLs_1nm","FLs_1nm","FLs_1nm","FLs_1nm",...
            "FLs_1nm","FLs_1nm","FLs_1nm","FLs_1nm","FLs_1nm","FLs_1nm",...
            "FLs_1nm","FLs_1nm","FLs_1nm","FLs_1nm","FLs_1nm","FLs_1nm",...
            "FLs_1nm","FLs_1nm","FLs_1nm","FLs_1nm","FLs_1nm","FLs_1nm",...
            "FLs_1nm","FLs_1nm","FLs_1nm","HPs","HPs","HPs","HPs","HPs",...
            "LEDs_1nm","LEDs_1nm","LEDs_1nm","LEDs_1nm","LEDs_1nm",...
            "LEDs_1nm","LEDs_1nm","LEDs_1nm","LEDs_1nm"];
        dict = dictionary(columnHeaders,shortNames);
    end
    ciedata = CIEData();
    if name == "E"
        rv = Illuminant_E(opts.lam);
        return;
    end
    if name == "D"
        rv = Illuminant_D(opts);
        return;
    end
    colHeader = Format(name);
    if ~dict.isKey(colHeader)
        error("CIE_Illuminant: there is no %s illuminant",name);
    end
    shortName = dict(colHeader);
    cielam = ciedata.Column_by_Header(shortName, 'lam');
    cieval = ciedata.Column_by_Header(shortName, colHeader);
    rv = MakeSpectrum(cielam,cieval);
    if isempty(opts.lam)
        desc = " using original wavelengths from CIE data";
    else
        rv = ResampleSpectrum(rv, opts.lam);
        desc = ", resampled to new wavelength values";
    end
    rv.name = "CIE Illuminant "+ colHeader;
    rv.description = "Based on official CIE Data from https://cie.co.at/data-tables"...
        + desc;

    function rvE = Illuminant_E(lam)
        if isempty(lam)
            lam = [360, 830];
            val = [1,1];
        else
            val = ones(size(lam));
        end
        rvE = MakeSpectrum(lam, val);
        rvE.name = "CIE Standard Illuminant E";
        rvE.description = "Constant spectrum across all wavelengths";
    end

    function rvD = Illuminant_D(iopts)
        if isnan(iopts.T)
            error("CIE_Illuminant: you must provide optional argument T for illuminant D");
        end
        if isempty(iopts.lam)
            iopts.lam = 360:830;
        end
        rvD = CIE_Illuminant_D(iopts.T,'lam',iopts.lam);
    end

    function rvF = Format(iname)
        tmp = replace(iname,"FL3_","FL3.");
        rvF = replace(tmp,"LED_","LED-");
    end

    
    %%%%%%%%%%%%%%%%%%%%%%%%
    % before 20.8.24 
    % % Available names:
    % % 'A';'D65';'C';'E','D50';'D55';'D75';'FL1';'FL2';'FL3';'FL4';'FL5';'FL6';'FL7';'FL8';'FL9';'FL10';'FL11';'FL12';
    % % 'FL3_1';'FL3_2';'FL3_3';'FL3_4';'FL3_5';'FL3_6';'FL3_7';'FL3_8';'FL3_9';'FL3_10';'FL3_11';'FL3_12';'FL3_13';'FL3_14';'FL3_15';
    % % 'HP1';'HP2';'HP3';'HP4';'HP5'}
    % arguments
    %     name (1,:) char
    %     opts.lam (:,1) double = 360:830
    %     opts.T (1,1) double = 5000
    % end
    % lam = opts.lam;
    % persistent CIE_Standard;
    % if isempty(CIE_Standard)
    %     tmp = load('CIE_Standard_Illuminants.mat','CIE_Standard');
    %     CIE_Standard = tmp.CIE_Standard;
    % end
    % if isfield(CIE_Standard, name)
    %     s = CIE_Standard.(name);
    %     rv.lam = lam;
    %     rv.val = LinInterpol(s.lam, s.val, lam);
    %     rv.name = sprintf('CIE standard illuminant %s',name);
    % elseif strcmp(name,'E')
    %     rv = MakeSpectrum(lam,ones(size(lam)));
    %     rv.name = 'CIE standard illuminant E';
    % elseif strcmp(name,'D')
    %     rv = CIE_Illuminant_D(opts.T, 'lam', lam);
    % else
    %     error('CIE_Illuminant: unknown illuminant name: %s',name);
    % end
end