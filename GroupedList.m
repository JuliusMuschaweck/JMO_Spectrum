%% Grouped list of JMO Spectrum Library functions
% 
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp; 
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp; 
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp; 
% </p>
% </html>
%
%% Generate spectra
%
% <CIE_Illuminant.html CIE_Illuminant> returns spectra for standard CIE illuminants
%
% <CIE_Illuminant_D.html CIE_Illuminant_D> Computes CIE standard illuminant D (daylight) for a desired color temperature
%
% <ColorChecker.html ColorChecker> returns selected MacBeth ColorChecker reflectivity spectra
% 
% <GaussSpectrum.html GaussSpectrum> creates a Gaussian spectrum, normalized to peak = 1.0
% 
% <MakeSpectrum.html MakeSpectrum> creates a spectrum struct out of fields lam and val, with sanity checks
% 
% <MakeSpectrumDirect.html MakeSpectrumDirect> creates a spectrum struct out of fields lam and val, without sanity checks
% 
% <PlanckSpectrum.html PlanckSpectrum> computes Planck blackbody spectra
%
% <ReadASCIITableFile.html ReadASCIITableFile> Reads a matrix of numbers from an ASCII text file, with optional delimiter control and
% generic comment line handling.
% 
% <ReadASCIITableSpectrumFile.html ReadASCIITableSpectrumFile> Reads an (n x 2) matrix of numbers from an ASCII text file, with optional delimiter control and
% generic comment line handling, and creates a spectrum from these two columns
% 
% <ReadLightToolsSpectrumFile.html ReadLightToolsSpectrumFile>  Reads a spectrum from an ASCII text file in LightTools(R) spectrum format with comment line
% handling.
% 
% <SolarSpectrum.html SolarSpectrum> returns a specific standardized solar spectrum, AM 0 (extraterrestrial) or AM 1.5 (air mass 1.5)
% 
% <Vlambda.html Vlambda> returns spectrum (fields lam and val) for Vlambda, the human eye spectral sensitivity, with |lam == 360:830|
%% Add, modify, transform spectra
%
% <AddSpectra.html AddSpectra> adds two spectra without weights.
%
% <AddWeightedSpectra.html AddWeightedSpectra> adds several spectra with weights>
%
% <DivideSpectra.html, DivideSpectra> Divide two spectra, with divide by zero treatment
%
% <IntegrateSpectrum.html IntegrateSpectrum> computes integral of spectrum over wavelength, with an optional weighting function
% 
% <MatchAdditiveMix.html MatchAdditiveMix> computes weights of three XYZ tristimuli to match a target XYZ tristimulus, with an optional fixed contribution
% 
% <MultiplySpectra.html MultiplySpectra> multiplies two spectra, returning the product spectrum
%
% <ResampleSpectrum.html ResampleSpectrum> replaces the wavelength data points, e.g. to ensure a spectrum is based on
% 360:830 nm in 1 nm steps
% 
% <ScaleSpectrum.html ScaleSpectrum> multiplies a spectrum with a given factor, or normalizes it that
% the peak, or the radiant/luminous flux, or a weighted integral has a certain value
%
% <ShiftToLdom.html ShiftToLdom> shifts the wavelength array of a spectrum such that the desired dominant wavelength
% results.
%% Modeling LED spectra
% 
% <MatchWhiteLEDSpectrum.html MatchWhiteLEDSpectrum> % Given a white LED spectrum, modifies it to match a desired CIE XYZ target 
% (e.g. for LEDs from a different white bin, or at different operating conditions)
% 
% <RGBLEDSpectrum.html RGBLEDSpectrum> is a class that models red/green/blue LED spectra under operating conditions, from data sheet
% information only.
%% Evaluate colorimetric properties
%
% <CCT.html CCT> computes the correlated color temperature of a spectrum
%
% <CCT_from_xy.html CCT_from_xy> computes the correlated color temperature from a CIE 1931 xy color point
%
% <CIE1931_XYZ.html CIE1931_XYZ> computes CIE 1931 tristimulus values X, Y, Z and x, y, z color coordinates for a
% spectrum
% 
% <CIE_Lab.html CIE_Lab> Computes CIELAB L*, a*, b* values from XYZ tristimulus values
%
% <CIE_Luv.html CIE_Luv> Computes CIELUV L*, u*, v* values from XYZ tristimulus values
%
% <CIE_upvp.html CIE_upvp> Computes CIE 1960/1964 u, v, u', v' color coordinates from CIE 1931 x, y
%
% <CIE_xy_from_upvp.html CIE_xy_from_upvp> Computes CIE x,y coordinates from CIE 1960/1964 u', v'
%
% <CIEDE2000_Lab.html CIEDE2000_Lab> Computes the CIEDE2000 color difference between two CIELAB L*, a*, b* stimuli
%
% <CIEDE2000_XYZ.html CIEDE2000_XYZ> Computes the CIEDE2000 color difference between two XYZ stimuli.
%
% <ComputeSpectrumColorimetry.html ComputeSpectrumColorimetry> For a given spectrum, computes a large selection of colorimetric properties
%
% <CRI.html CRI> The CRI class provides what is needed to compute Color Rendering Indices%% LED model
%
% <LDomPurity.html LDomPurity> computes dominant wavelength and purity
% 
% <MacAdamEllipse.html MacAdamEllipse> compute points and parameters of a MacAdam Ellipse
% 
% <MacAdamEllipse_g.html MacAdamEllipse_g> helper function for <MacAdamEllipse.html MacAdamEllipse>
% 
% <PlanckLocus.html PlanckLocus> Computes the Planck locus (i.e. the color points of blackbody radiators) in various color spaces, and provides helper functions to compute Judd lines.
% 
% <sRGB_to_XYZ.html sRGB_to_XYZ> computes XYZ tristimulus value of displayed color on ideal sRGB display
%
% <XYZ_from_xyY.html XYZ_from_xyY> is a simple convenience function to create complete XYZ information from xy color coordinates
% and flux
%
% <XYZ_to_sRGB.html XYZ_to_sRGB> computes sRGB values from desired XYZ tristrimulus values
%% Utility functions
%
% <CauchyFromAbbe.html CauchyFromAbbe> computes A0 and A1 coefficients of the Cauchy dispersion model from reference index and
% Abbe number
%
% <CIE1931_Data.html CIE1931_Data> returns |struct| with CIE 1931 color matching functions, monochromatic border and Planck locus
%
% <CODATA2018.html CODATA2018> Returns a struct with CODATA 2018 constants relevant to illumination, and some more
% 
% <EvalSpectrum.html EvalSpectrum> evaluates the function modeled by a spectrum
% 
% <FindRoot1D.html FindRoot1D> finds root of scalar function of one real variable, without derivatives.
% 
% <FindRootND.html FindRootND> finds multidimensional root of function in N dimensions, without derivatives
% 
% <IsOctave.html IsOctave> determines if program is running under GNU Octave
% 
% <IsSpectrum.html IsSpectrum> checks if a variable is a valid spectrum
% 
% <JMOSpectrumVersion.html JMOSpectrumVersion> returns the version of this library
%
% <LinInterpol.html LinInterpol> from tabulated function |yy(xx)|, compute linearly interpolated values at |xq| query points
% 
% <LinInterpolAdd4Async.html LinInterpolAdd4Async> from four tabulated functions yy0(xx0) ... yy3(xx3), compute the sum of the four interpolated functions over the same query grid xq, using four processors in parallel
% 
% <PlotCIExyBorder.html PlotCIExyBorder> plots the CIE xy monochromatic border, with optional color fill and other options
%
% <PlotCIEupvpBorder.html PlotCIEupvpBorder> plots the CIE u'v' monochromatic border, with optional color fill and other options
% 
% <PlotCRIResult.html PlotCRIResult> plots a chart to compare CRI colors between test and reference lamp
% 
% <RainbowColorMap.html RainbowColorMap> A rainbow color map to be used with Matlab's 'colormap' function
% 
% <SpectrumSanityCheck.html SpectrumSanityCheck>  performs various checks to see if a spectrum complies with the <docDesignDecisions.html requirements>, 
% returns a sanitized spectrum when possible 
% 
% <Vlambda.html Vlambda> returns spectrum (fields lam and val) for Vlambda with |lam == 360:830|
% 
% <WriteLightToolsSpectrumFile.html WriteLightToolsSpectrumFile> writes a spectrum to a text file in LightTools .sre format
