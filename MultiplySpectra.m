%% MultiplySpectra
% 
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp; 
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp;
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp; 
% <a href="GroupedList.html"> Grouped list</a> &nbsp; | &nbsp; 
% Source code: <a href = "file:../MultiplySpectra.m"> MultiplySpectra.m</a>
% </p>
% </html>
%
% Multiply two spectra
%% Syntax
% rv = |MultiplySpectra(lhs, rhs)|
%% Input Arguments
% * |lhs|: A valid spectrum, i.e. a struct with two array fields, |lam| and |val| (see <SpectrumSanityCheck.html SpectrumSanityCheck> for detailed requirements)
% * |rhs|: Likewise
%% Output Arguments
% * |rv|: A spectrum modeling the product.
%% Algorithm
% A spectrum in this library models a continuous, piecewise linear function of wavelength. For a given array of
% wavelenghts, the modeled spectrum is linear between wavelength points, and zero outside the wavelength domain. At the
% ends of the wavelength domain the modeled spectrum may drop discontinously to zero. (If you don't like these discontinuities at the domain boundary, add end
% points with zero values.). The product spectrum's wavelength points consist of the "interweaved" wavelength arrays of
% |lhs| and|rhs|, where they overlap. If they don't overlap at all, a spectrum is returned with two wavelength points
% and both values zero.
%
% At each wavelength point, one value is taken from the corresponding point of one spectrum and the
% linearly interpolated point of the other spectrum, then these two are multiplied. Strictly speaking, the product spectrum would not be piecewise
% linear, it would be piecewise quadratic. However, this is neglected here. If a better approximation to the quadratic
% product spectrum is desired, you may resample |lhs| and/or |rhs| on a finer wavelength array using
% <ResampleSpectrum.html ResampleSpectrum>.
%% See also
% <AddSpectra.html AddSpectra>, <AddWeightedSpectra.html AddWeightedSpectra>, <IntegrateSpectrum.html
% IntegrateSpectrum>, <ResampleSpectrum.html ResampleSpectrum>, <ScaleSpectrum.html ScaleSpectrum>
%% Usage Example
% <include>Examples/ExampleMultiplySpectra.m</include>

% publish with publishWithStandardExample('filename.m') in PublishDocumentation.m

% JMO Spectrum Library, 2021. See https://github.com/JuliusMuschaweck/JMO_Spectrum
% I dedicate the JMO_Spectrum library to the public domain under Creative Commons Zero 
% (https://creativecommons.org/publicdomain/zero/1.0/legalcode)
%

function rv = MultiplySpectra(lhs, rhs)
    % multiply spectra lhs and rhs, checking for overlap
    %
    % Parameters:
    %   lhs: A valid spectrum
    %   rhs: A valid spectrum
    % Results: 
    %   rv: The multiplied spectrum, with the wavelengths interweaved where they overlap
    %
    % Spectra in this library are always continuous, and assumed to be linear between the data points.
    % Now, when multiplying such piecewise linear functions, viewed as functions defined over
    % all reals (zero outside the wavelength range), the product would NOT be piecewise linear: It would be
    % piecewise quadratic. However, we assume piecewise linearity not only for simplicity, but also
    % because we just don't know what the spectrum does between support points. So we apply the same
    % logic to the product of two spectra: When a wavelength point occurs in both spectra, no problem.
    % When a wavelength point occurs only in one spectrum, we interpolate the other spectrum linearly to
    % obtain the data point of the product. Then, this sequence of points is again linearly interpolated,
    % and NOT assumed to be piecewise quadratic.
    [~,~,lhs] = SpectrumSanityCheck(lhs);
    [~,~,rhs] = SpectrumSanityCheck(rhs);
    % treat equal lambda arrays
    if isequal(lhs.lam, rhs.lam)
        rv.lam = lhs.lam;
        rv.val = lhs.val .* rhs.val;
        return;
    end
    % treat no overlap case
    % use <= to avoid single line spectra
    if (lhs.lam(end) <= rhs.lam(1))
        rv.lam = [lhs.lam(1),rhs.lam(end)];
        rv.val = [0,0];
        return;
    end
    if (rhs.lam(end) <= lhs.lam(1))
        rv.lam = [rhs.lam(1),lhs.lam(end)];
        rv.val = [0,0];
        return;
    end
    % treat overlapping, unequal lambdas
    % result nonzero only in [lam0;lam1] interval
    lam0 = max(lhs.lam(1), rhs.lam(1));
    lam1 = min(lhs.lam(end), rhs.lam(end));
    % compute interveawed lam, removing duplicates
    tmplam = unique(sort(cat(1,lhs.lam,rhs.lam)));
    tmpIdx = (tmplam >= lam0) & (tmplam <= lam1);
    rv.lam = tmplam(tmpIdx);
    if isempty(rv.lam)
        error('MultiplySpectra: This cannot happen');
    end
    % Interpolate both lhs and rhs, multiply elementwise
    vl = LinInterpol(lhs.lam,lhs.val,rv.lam);
    vr = LinInterpol(rhs.lam,rhs.val,rv.lam);
    rv.val = vl .* vr;
end