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
% <GaussSpectrum.html GaussSpectrum> creates a Gaussian spectrum, normalized to peak = 1.0
% 
% <PlanckSpectrum.html PlanckSpectrum> computes Planck blackbody spectra
%% Add, modify, transform spectra
%
% <AddSpectra.html AddSpectra> adds two spectra without weights.
%
% <AddWeightedSpectra.html AddWeightedSpectra> adds several spectra with weights>
%
% <IntegrateSpectrum.html IntegrateSpectrum> computes integral of spectrum over wavelength, with an optional weighting function
% 
% <MatchAdditiveMix.html MatchAdditiveMix> computes weights of three XYZ tristimuli to match a target XYZ tristimulus, with an optional fixed contribution
% 
% <MultiplySpectra.html MultiplySpectra> multiplies two spectra, returning the product spectrum
%
% <ResampleSpectrum.html ResampleSpectrum> replaces the wavelength data points, e.g. to ensure a spectrum is based on
% 360:830 nm in 1 nm steps
%% Modeling LED spectra
% 
% <MatchWhiteLEDSpectrum.html MatchWhiteLEDSpectrum> % Given a white LED spectrum, modifies it to match a desired CIE XYZ target 
% (e.g. for LEDs from a different white bin, or at different operating conditions)
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
% <MakeSpectrum.html MakeSpectrum> creates a spectrum struct out of fields lam and val, with sanity checks
% 
% <MakeSpectrumDirect.html MakeSpectrumDirect> creates a spectrum struct out of fields lam and val, without sanity checks
% 
% <Octave_xyz2rgb.html Octave_xyz2rgb> A GNU Ocvate routine to convert XYZ to sRGB,
% superseded by <XYZ_to_sRGB.html XYZ_to_sRGB>
%% Not Yet Documented
% 
% <OptimalAdditiveMix.html OptimalAdditiveMix>
% 
% <PlanckLocus.html PlanckLocus>
% 
% <PlotCIExyBorder.html PlotCIExyBorder>
% 
% <PlotCRIResult.html PlotCRIResult>
% 
% <ExamplePlotCRIResult.html ExamplePlotCRIResult>
% 
% <RainbowColorMap.html RainbowColorMap>
% 
% <ReadASCIITableFile.html ReadASCIITableFile>
% 
% <ReadASCIITableSpectrumFile.html ReadASCIITableSpectrumFile>
% 
% <ReadLightToolsSpectrumFile.html ReadLightToolsSpectrumFile>
% 
% <RGBLEDSpectrum.html RGBLEDSpectrum>
% 
% <ShiftToLdom.html RGBLEDSpectrum>
% 
% <SolarSpectrum.html SolarSpectrum>
% 
% <SpectrumSanityCheck.html SpectrumSanityCheck>
% 
% <TestCIEDE2000.html TestCIEDE2000>
% 
% <TestCRI_vanKries.html TestCRI_vanKries>
% 
% <TestLinInterpol.html TestLinInterpol>
% 
% <TestMacAdamEllipse.html TestMacAdamEllipse>
% 
% <Vlambda.html Vlambda>
% 
% <WriteLightToolsSpectrumFile.html WriteLightToolsSpectrumFile>
%
% <XYZ_from_xyY.html XYZ_from_xyY>




