%% CIE1931_XYZ
% 
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp; 
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp;
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp; 
% <a href="GroupedList.html"> Grouped list</a> &nbsp; | &nbsp; 
% Source code: <a href = "file:../CIE1931_XYZ.m"> CIE1931_XYZ.m</a>
% </p>
% </html>
%
% Computes CIE1931 X, Y, Z tristimulus values and x, y, z color coordinates of a spectrum, and its color weight X+Y+Z
%% Syntax
% |rv = CIE1931_XYZ(spec)|
%% Input Arguments
% * |spec|: A valid spectrum (see <SpectrumSanityCheck.html SpectrumSanityCheck>)
%% Output Arguments
% * |rv|: A struct with fields |X, Y, Z, x, y, z, cw|, all scalar double
%% Algorithm
% The integrals of the spectrum, weighted with the color matching functions, are computed using
% <IntegrateSpectrum.html IntegrateSpectrum>. There the wavelength arrays are properly interweaved, both the spectrum
% and the color matching functions are linearly interpolated for all occurring wavelenghts, multiplied and integrated
% using the trapezoidal rule. Thus, even spectra with extremely narrow spikes and/or steep slopes within a single
% nanometer range are treated correctly. There are two exceptions: 
% When |spec.lam| has no overlap with 360:830, returns |0,0,0,NaN,NaN,Nan|. When |spec.lam| is a scalar (a single line
% spectrum, which is actually not considered a proper spectrum in this library), the color matching functions are
% evaluated at that single wavelength.
%% See also
% <CIE_Lab.html CIE_Lab>, <CIE_Luv.html CIE_Luv>, <CIE_upvp.html CIE_upvp>, <IntegrateSpectrum.html IntegrateSpectrum>, 
% <LDomPurity.html LDomPurity>, <LinInterpol.html LinInterpol>, <MultiplySpectra.html MultiplySpectra>
%% Usage Example
% <include>Examples/ExampleCIE1931_XYZ.m</include>

% publish with publishWithStandardExample('filename.m') in PublishDocumentation.m

% JMO Spectrum Library, 2021. See https://github.com/JuliusMuschaweck/JMO_Spectrum
% I dedicate the JMO_Spectrum library to the public domain under Creative Commons Zero 
% (https://creativecommons.org/publicdomain/zero/1.0/legalcode)
%
function rv = CIE1931_XYZ(spec)
    % function rv = CIE1931_XYZ(spec)
    % compute CIE 1931 XYZ tristimulus and xy coords from spec.lam, spec.val
    % spec is struct with spec.lam and spec.val arrays
    % rv is struct with tristimulus values rv.X, rv.Y, rv.Z, and color coordinates rv.x and rv.y
    % also returns rv.z = 1 - rv.x-rv.y
    persistent iXYZ;
    if isempty(iXYZ)
        load('CIE1931_lam_x_y_z.mat','CIE1931XYZ');
        iXYZ = CIE1931XYZ;
    end
    if (iXYZ.lam(2) - iXYZ.lam(1)) ~= 1
        error('CIE1931_XYZ: no unit spacing in CIE1931XYZ.lam');
    end
    if spec.lam(1) >= iXYZ.lam(end) || spec.lam(end) <= iXYZ.lam(1)
        % no overlap
        rv.X = 0;
        rv.Y = 0;
        rv.Z = 0;
        rv.cw = 0;
        rv.x = NaN;
        rv.y = NaN;
        rv.z = NaN;
        return;
    end
    if numel(spec.lam) == 1
        % 6.4.2021 JM: change to LinInterpol, include multiplication with (scalar) spec.val
        rv.X = LinInterpol(iXYZ.lam,iXYZ.x,spec.lam) * spec.val;
        rv.Y = LinInterpol(iXYZ.lam,iXYZ.y,spec.lam) * spec.val;
        rv.Z = LinInterpol(iXYZ.lam,iXYZ.z,spec.lam) * spec.val;
        rv.cw = rv.X + rv.Y + rv.Z;
        rv.x = rv.X / (rv.X+rv.Y+rv.Z);
        rv.y = rv.Y / (rv.X+rv.Y+rv.Z);
        rv.z = 1 - rv.x - rv.y;
        return;
    end
    % 6.4.21 JM: it's wrong to interpolate spec in 1 nm steps! Think of a near delta spectrum around Helium d
    %     lam0 = floor(max(spec.lam(1), iXYZ.lam(1)));
    %     lam1 = ceil(min(spec.lam(end), iXYZ.lam(end)));
    %     ispecval = LinInterpol(spec.lam,spec.val,(lam0:lam1)');
    %     idxlam0 = lam0 - iXYZ.lam(1) + 1;
    %     idxlam1 = lam1 - iXYZ.lam(1) + 1;
    %     rv.X = trapz(ispecval .* iXYZ.x(idxlam0:idxlam1)); % ok since iXYZ.x,y,z have unit spacing
    %     rv.Y = trapz(ispecval .* iXYZ.y(idxlam0:idxlam1));
    %     rv.Z = trapz(ispecval .* iXYZ.z(idxlam0:idxlam1));
    rv.X = IntegrateSpectrum(spec,MakeSpectrum(iXYZ.lam, iXYZ.x));
    rv.Y = IntegrateSpectrum(spec,MakeSpectrum(iXYZ.lam, iXYZ.y));
    rv.Z = IntegrateSpectrum(spec,MakeSpectrum(iXYZ.lam, iXYZ.z));
    rv.cw = rv.X + rv.Y + rv.Z;
    rv.x = rv.X / (rv.X+rv.Y+rv.Z);
    rv.y = rv.Y / (rv.X+rv.Y+rv.Z);
    rv.z = 1 - rv.x - rv.y;
end