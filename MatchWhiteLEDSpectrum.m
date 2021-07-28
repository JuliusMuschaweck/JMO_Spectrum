%% MatchWhiteLEDSpectrum
% 
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp; 
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp;
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp; 
% <a href="GroupedList.html"> Grouped list</a> &nbsp; | &nbsp; 
% Source code: <a href = "file:../MatchWhiteLEDSpectrum.m"> MatchWhiteLEDSpectrum.m</a>
% </p>
% </html>
%
% Given a white LED spectrum, modifies it to match a desired CIE XYZ target (e.g. for LEDs from a different white bin, or at different operating conditions)
%% Syntax
% |rv = MatchWhiteLEDSpectrum(whiteLEDspectrum, XYZ_target)|
%% Input Arguments
% * |whiteLEDspectrum|: A white LED spectrum, with a blue peak and a yellow peak, with a minimum near 480 nm in between
% * |XYZ_target|: A struct with fields |x,y,Y|, i.e. the desired x-y white point and the Y tristimulus value. % Note that you need to multiply the tristimulus Y value with Km = 683 lm/W
% to get photometric units (lm, cd, lux).
%% Output Arguments
% * |rv|: A struct with fields |spec|: A white LED spectrum, i.e. a struct with fields |lam| and |val|, 
% which has the desired x-y white point and the desired tristimulus Y value, |blue|, the shifted blue part of the spectrum,
% |yellow|, the shifted yellow part of the spectrum, and |target|, a copy of the |XYZ_target| input parameter.
%% Algorithm
% # Determines the location of the minimum near 480 nm. 
% # Splits the input spectrum smoothly, using a |tanh| weighting function with a width of 10 nm, into a blue part
% and a yellow part, which overlap around the white spectrum's minimum.
% # The desired white point will generally not lie on the line in the CIRE xy diagram which connects the 
% color coordinates of the blue and the yellow part. If the desired white point is above/below this line, the blue part is 
% shifted towards longer/shorter wavelenghts and the yellow part by the same shift towards shorter/longer wavelengths, such that 
% the desired white point lies on the line connecting the shifted blue and yellow spectra. 
% # The shifted blue and yellow spectra are scaled to match the desired whited point and the desired tristimulus Y
% value.
%
% When it would be necessary to shift the blue/yellow parts by more than 10 nm, the routine emits an error.
%
% In practice, the actual white spectrum of a LED of the same type, but from a different white bin, will not exactly be
% what this function returns. However, it would be wrong to shift only the blue part, or only the yellow part.
% Binning variations are caused by varying phosphor amounts (which do not require shifting, just rebalancing blue and
% yellow), by variations/shifts in the underlying blue LED spectrum, and by variations of the phosphor spectrum.
% Similar considerations apply to flux and white point variations due to current/temperature changes. This routine 
% uses a heuristic approach to modify the original white spectrum in a reasonable way, such that a given color and flux
% shift is achieved.
%
% With this routine, it is possible to implement a white LED model, which returns the actual spectrum under operating 
% conditions for a white LED, given only data sheet information.
%% See also
% <CIE1931_XYZ.html CIE1931_XYZ>, <ResampleSpectrum.html ResampleSpectrum>, <ShiftToLdom.html ShiftToLdom>
%% Usage Example
% <include>Examples/ExampleMatchWhiteLEDSpectrum.m</include>

% publish with publishWithStandardExample('filename.m') in PublishDocumentation.m

% JMO Spectrum Library, 2021. See https://github.com/JuliusMuschaweck/JMO_Spectrum
% I dedicate the JMO_Spectrum library to the public domain under Creative Commons Zero 
% (https://creativecommons.org/publicdomain/zero/1.0/legalcode)
%

function rv = MatchWhiteLEDSpectrum(whiteLEDspectrum, XYZ_target)
    
    % abbreviations
    xt = XYZ_target.x;
    yt = XYZ_target.y;
    xyt = [xt, yt];
    Yt = XYZ_target.Y;
    
    % find near 480nm minimum
    lam_overlap = 450:500;
    spec_overlap = ResampleSpectrum(whiteLEDspectrum, lam_overlap);
    [~,imin] = min(spec_overlap.val);
    lam_min = lam_overlap(imin);
    % split spectrum there with tanh weight, sigma = 10 nm
    sig = 10;
    ww = 0.5 * (1 + tanh( (whiteLEDspectrum.lam - lam_min) / sig ));
    ww( (1-ww) < 1e-4) = 1;
    ww( ww < 1e-4) = 0;
    iww = 1 - ww;
    
    blue = MakeSpectrumDirect(whiteLEDspectrum.lam, whiteLEDspectrum.val .* iww, 'XYZ', true);
    yellow = MakeSpectrumDirect(whiteLEDspectrum.lam, whiteLEDspectrum.val .* ww, 'XYZ', true);
    
    testshift = @(dlam) TestShift(dlam, blue, yellow, xyt);
    dlam_max = 10;
    if testshift(dlam_max) * testshift(-dlam_max) >= 0
        error('MatchWhiteLEDSpectrum: shift more than 10 nm needed');
    end
    % bracket established -- find shift to bring target between blue and yellow
    [dlam, fb, nfe, ok, msg]= FindRoot1D(testshift, -dlam_max, dlam_max);
    blue_shifted = MakeSpectrumDirect(blue.lam + dlam,  blue.val, 'XYZ',true);
    yellow_shifted = MakeSpectrumDirect(yellow.lam - dlam,  yellow.val, 'XYZ',true);
    
    % compute weights
    blue_dist = norm([blue_shifted.XYZ.x, blue_shifted.XYZ.y] - xyt);
    yellow_dist = norm([yellow_shifted.XYZ.x, yellow_shifted.XYZ.y] - xyt);
    
    yfac1 = blue_dist * blue_shifted.XYZ.cw / (yellow_dist * yellow_shifted.XYZ.cw);
    fac2 = Yt / (blue_shifted.XYZ.Y + yfac1 * yellow_shifted.XYZ.Y);
    
    blue_shifted = MakeSpectrumDirect(blue_shifted.lam, blue_shifted.val * fac2, 'XYZ',true);
    yellow_shifted = MakeSpectrumDirect(yellow_shifted.lam, yellow_shifted.val * yfac1 * fac2, 'XYZ',true);
    
    matched_white = AddSpectra(blue_shifted, yellow_shifted);
    % test
    matched_white.XYZ = CIE1931_XYZ(matched_white);
    dY = matched_white.XYZ.Y - Yt;
    dxy = [matched_white.XYZ.x, matched_white.XYZ.y] - xyt;
    
    rv.spec = matched_white;
    rv.blue = blue_shifted;
    rv.yellow = yellow_shifted;
    rv.target = XYZ_target;
end

function rv = TestShift(dlam, blue, yellow, xyt)
    b = CIE1931_XYZ(struct('lam',blue.lam + dlam, 'val', blue.val));
    y = CIE1931_XYZ(struct('lam',yellow.lam - dlam, 'val', yellow.val));
    cross2 =@(lhs, rhs) lhs(1) * rhs(2) - lhs(2) * rhs(1);
    rv = cross2([y.x,y.y] - [b.x, b.y], xyt - [b.x, b.y]); %
end
