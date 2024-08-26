%% CIE_Illuminant_D
% 
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp; 
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp;
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp; 
% <a href="GroupedList.html"> Grouped list</a> &nbsp; | &nbsp; 
% Source code: <a href = "file:../CIE_Illuminant_D.m"> CIE_Illuminant_D.m</a>
% </p>
% </html>
%
% Computes CIE standard illuminant D (daylight) for a desired color temperature, based on official CIE data from <https://cie.co.at/data-tables>.
%% Syntax
% |rv = CIE_Illuminant_D(CCT,varargin)|
%% Input Arguments
% * |CCT|: scalar double. Correlated color temperature. |4000 <= CCT <= 25000|, else error (unless |'enforceCCTrange' = false|)
% * |varargin|: Name-value pairs: |'lam',lam| where |lam| is a valid wavelength range (strictly ascending vector of
% positive double| Default is |300:5:830| (the wavelengths that are in the official CIE data). |'enforceCCTrange', yesno| where |yesno| is logical scalar; when |false|, |CCT|
% may be outside the |4000 <= CCT <= 25000|.
%% Output Arguments
% * |rv|: A spectrum, |struct| with fields |lam| (a copy of the input variable when given, else 300:5:830), |val| (the
% spectrum values), |name| (an appropriate name), and |description| (a description). CIE D is defined from 300 nm to 830 nm. The spectrum will be zero
% for values of |lam| outside this range.
%% Algorithm
% Retrieves the S0, S1 and S2 spectra from |CIE_Standard_Illuminants.mat|, computes the M1 and M2 weights according to
% the CIE formulas and assembles the weighted sum of the three spectra. Then, interpolates the resulting spectrum over
% |lam|. See CIE 015:2018 ("Colorimetry, 4th edition") for the definitions. Note that the S0, S1 and S2 functions are given in 10 nm steps, and thus
% the CIE D illuminant is not smooth when interpolated on a finer wavelength resolution. When a smoother spectrum is
% desired, you may consult CIE 204:2013 (“Methods for re-defining CIE D illuminants”) for a smoothing method that does
% only minimally change resulting color coordinates from a wide range of reflective samples. They also do no correctly
% represent the narrow absorption bands of the atmosphere: CIE D is for colorimetric calculations only, with no steep
% slopes in reflection or transmission. When using with sharp dichroic filters, it may be better to use the high resolution AM1.5
% spectrum, see file AM0AM1_5.xls, which is contained in this library distribution.
%% See also
% <CIE_Illuminant.html CIE_Illuminant>, <CCT.html CCT>, <PlanckSpectrum.html PlanckSpectrum>
%% Usage Example
% <include>Examples/ExampleCIE_Illuminant_D.m</include>

% publish with publishWithStandardExample('filename.m') in PublishDocumentation.m

% JMO Spectrum Library, 2021. See https://github.com/JuliusMuschaweck/JMO_Spectrum
% I dedicate the JMO_Spectrum library to the public domain under Creative Commons Zero 
% (https://creativecommons.org/publicdomain/zero/1.0/legalcode)
%

% 23.9.24 JM changed to be based on official CIE data

function rv = CIE_Illuminant_D(CCT,opts)
% Compute CIE standard illuminant D for color temperature CCT, for 360:830 nm. Optional 'lam',lam 
    arguments
        CCT (1,1) double
        opts.lam (:,1) double = []
        opts.enforceCCTrange (1,1) logical = true
    end
    lam = opts.lam;
    if opts.enforceCCTrange && (CCT < 4000 || CCT > 25000)
        error('CIE_Illuminant_D: CCT = %g out of range (4000..25000K)',CCT);
    end
    ciedata = CIEData();
    % % formulas from https://en.wikipedia.org/wiki/Standard_illuminant#Illuminant_series_D
    % double checked with the official standard, CIE 015:218, section 4.1.2
    iT = 1000 / CCT;
    if CCT > 7000
        xD = 0.237040 + 0.24748 * iT + 1.9018 * iT^2 - 2.0064 * iT^3;
    else % CCT in 4000;7000
        xD = 0.244063 + 0.09911 * iT + 2.9678 * iT^2 - 4.6070 * iT^3;
    end
    yD = - 3 * xD^2 + 2.870 * xD - 0.275;
    M = 0.0241 + 0.2562 * xD - 0.7341 * yD;
    M1 =(-1.3515 - 1.7703 * xD + 5.9114 * yD) / M;
    M2 = (0.03000 - 31.4424 * xD + 30.0717 * yD) / M;
    ilam = ciedata.Column_by_Header("Dxx","lam");
    S0 = ciedata.Column_by_Header("Dxx","S0");
    S1 = ciedata.Column_by_Header("Dxx","S1");
    S2 = ciedata.Column_by_Header("Dxx","S2");
    SD = S0 + M1 * S1 + M2 * S2;
    rv = MakeSpectrum(ilam, SD);
    if ~isempty(opts.lam)
        rv = ResampleSpectrum(rv, opts.lam);
    end
    % before 23.8.24
    % ilam = CIE_Standard.DaylightComponents.lam;
    % S0 =  CIE_Standard.DaylightComponents.S0;
    % S1 =  CIE_Standard.DaylightComponents.S1;
    % S2 =  CIE_Standard.DaylightComponents.S2;
    % rv.lam = lam(:); % 26.2.2024 JM to make column vectors, 17.8.24 (:) not '
    % rv.val = LinInterpol(ilam(:), SD, rv.lam); % JM 17.8.24 make val column

    rv.name = sprintf('CIE standard illuminant D for CCT = %g',CCT);
    if isempty(opts.lam)
        desc = " using original wavelengths from CIE data";
    else
        rv = ResampleSpectrum(rv, opts.lam);
        desc = ", resampled to new wavelength values";
    end
    rv.description = "Based on official CIE Data from https://cie.co.at/data-tables"...
        + desc;
end