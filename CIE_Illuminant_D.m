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
% Computes CIE standard illuminant D (daylight) for a desired color temperature
%% Syntax
% |rv = CIE_Illuminant_D(CCT,varargin)|
%% Input Arguments
% * |CCT|: scalar double. Correlated color temperature. |4000 <= CCT <= 25000|, else error
% * |varargin|: Name-value pairs: |'lam',lam| where |lam| is a valid wavelength range (strictly ascending vector of
% positive double| Default is |360:830|. |'enforceCCTrange', yesno| where |yesno| is logical scalar; when |false|, |CCT|
% may be outside the |4000 <= CCT <= 25000|.
%% Output Arguments
% * |rv|: A spectrum, |struct| with fields |lam| (a copy of the input variable when given, else 360:830), |val| (the
% spectrum values), and |name| (an appropriate name). CIE D is defined from 300 nm to 830 nm. The spectrum will be zero
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

function rv = CIE_Illuminant_D(CCT,varargin)
% Compute CIE standard illuminant D for color temperature CCT, for 360:830 nm. Optional 'lam',lam 
    p = inputParser;
    p.addRequired('CCT');
    p.addParameter('lam',360:830);
    p.addParameter('enforceCCTrange',true);
    parse(p, CCT, varargin{:});
    lam = p.Results.lam;
    if p.Results.enforceCCTrange && (CCT < 4000 || CCT > 25000)
        error('CIE_Illuminant_D: CCT = %g out of range (4000..25000K)',CCT);
    end
    persistent CIE_Standard;
    if isempty(CIE_Standard)
        tmp = load('CIE_Standard_Illuminants.mat','CIE_Standard');
        CIE_Standard = tmp.CIE_Standard;
    end
    % formulas from https://en.wikipedia.org/wiki/Standard_illuminant#Illuminant_series_D
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
    ilam = CIE_Standard.DaylightComponents.lam;
    S0 =  CIE_Standard.DaylightComponents.S0;
    S1 =  CIE_Standard.DaylightComponents.S1;
    S2 =  CIE_Standard.DaylightComponents.S2;
    SD = S0 + M1 * S1 + M2 * S2;
    rv.lam = lam;
    rv.val = LinInterpol(ilam, SD, lam);
    rv.name = sprintf('CIE standard illuminant D for CCT = %g',CCT);        
end