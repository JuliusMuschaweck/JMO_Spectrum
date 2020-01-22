%% JMO Spectrum Library Documentation
% Version 1.2, Jan 22, 2020
% 
% Julius Muschaweck, JMO GmbH, Zugspitzstr. 66, 82131 Gauting, Germany. julius@jmoptics.de
%% Rationale
% We deal routinely with spectra in illumination optics. We need to analyze 
% LED spectra, compute color coordinates and color rendering values from spectra, 
% integrate them, add spectra, multiply spectra with scalar weights and with other 
% spectra (like transmission spectra), interpolate a given measured spectrum with 
% non-equidistant wavelength values to a regular 1 nm array, and so on.
% 
% In practice, this is tedious: spectra come in various formats, and the problem 
% of dealing with two spectra als tabulated values which have two different sets 
% of wavelengths is annoying.
% 
% This open source Matlab library is designed to make these engineering tasks 
% easy and transparent. It is compatible with GNU Octave, and with Matlab for 
% Mac and Linux. 
%% License -- public domain
% I release this software into the public domain under <https://creativecommons.org/publicdomain/zero/1.0/legalcode 
% CC0>
%% Version history
% Version 1.2, Jan. 22, 2020
% 
% Added <internal:EAF319A5 CIE standard illuminants>
% 
% Added <internal:H_B18B3F0A CRI> (color rendering index) computations
% 
% Added <internal:H_79735AFE AssignNewWavelength> function
% 
% Version 1.01, Oct. 13:
% 
% Added <internal:H_E49609D5 WriteLightToolsSpectrumFile>
% 
% Version 1.0, Sept. 9, 2019: Initial version
%% Getting started
% To define a spectrum and compute its CIE xy color coordinates, simply say

clear s;
s.lam = [360 830];
s.val = [1 1];
% this is a flat spectrum, known as CIE standard illuminant E. 
% By definition, it should have color coordinates x == y == 1/3-
s.XYZ = CIE1931_XYZ(s);
% This is a common pattern: Compute information from a spectrum, and then
% add this information to the same spectrum as an additional field
s
s.XYZ
%% Design decisions
% Spectrum
% In this library, a _spectrum_ is a struct with at least two fields named |lam| 
% and |val|, which meet the following requirements:
%% 
% # |lam| is a 1D vector of numeric values which are not complex, > 0, and strictly 
% ascending
% # |val| is a 1D vector of numeric values which are not complex.
% # |lam| and |val| are of same length and have at least two elements
%% 
% It is desirable for |lam| and |val| to be column vectors.
% 
% There is a function |rv = SpectrumSanityCheck(rhs)|, which tests all these 
% requirements and, if met, returns the same struct except that |lam| and |val| 
% are converted to column vectors if necessary.
% 
% A _spectrum_ models the function _S(lambda)_ which represents a physical scalar 
% function of wavelength. Like spectral radiant flux, spectral irradiance, spectral 
% radiant intensity, spectral radiance, spectral transmission, spectral absorption, 
% spectral efficiency. The tabulated values in |val| are linearly interpolated. 
% Outside the range given by |lam|_,_  _S(lambda)_ == 0.
% 
% |lam| is considered to have units of nanometers in all library functions that 
% make use of this unit, e.g. color calculations.
% 
% Why structs and not classes? Classes are nice to guarantee that properties 
% like |lam| and |val| always are present, and would allow methods which operate 
% directly on spectra. However, structs are simpler and more versatile. I, as 
% the library designer, cannot know which additional information a user (I myself, 
% for example), wants to attach to a given spectrum. Name, date, name of LED, 
% color coordinates and more. To make a spectrum s, I can simply say

clear s
nfig = 0; %figure number to be used in examples
s.lam = [360 830];
s.val = [1 1];
s.name = "CIE standard illuminant E";
s.hopp = "topp";
s
%% 
% to give it an appropriate name and an arbitrary value in an arbitrary additional 
% field. Of course, a user can always create a subclass to add properties to a 
% given class, but it is just so much simpler to assign to an additional struct 
% field in a single line. In my experience, these conventions for spectra are 
% simple and few enough to be easily remembered and adhered to.
% Conventions
% In my code, I like to have long unabbreviated variable and function names. 
% Except for a few standards:
% 
% |rv| is my name for the return value of a function
% 
% |spec| is my name for a single spectrum argument of a function.
% 
% |lhs| and |rhs|  are short for 'left hand side' and 'right hand side', the 
% arguments of a binary function.
% 
% Proper library function names start with capital letters, e.g. |MakeSpectrum|. 
% Internal helper functions start with a small "i", e.g. |iLinInterpolProto|.
% 
% A spectrum struct is valid if it has fields lam and |val| which fulfill the 
% requirements above. In addition, I assume a spectrum may have the following 
% fields:
% 
% |name|_:_  A short character string with a name. 
% 
% |description|_:_ A longer character string with a description.
% 
% |XYZ|_:_  A struct with tristimulus and color coordinate fields |X, Y, Z, 
% x, y, z|, typically created by code like |s.XYZ = CIE1931_XYZ(s)|
%% Function reference
% Alphabetic list
% <internal:H_C9DC0B6A AddSpectra> adds two spectra
% 
% <internal:H_8F93BC09 AddWeightedSpectra> adds multiple spectra with weights
% 
% <internal:H_79735AFE AssignNewWavelength> replaces the wavelength of a spectrum, 
% interpolating the values correctly
% 
% <internal:H_1B8563B5 CCT_from_xy> computes correlated color temperature and 
% uv-distance to Planck locus from spectrum
% 
% <internal:H_8ADDABD0 CIE1931_lam_x_y_z.mat> contains CIE 1931 data for color 
% matching functions, monochromatic border and Planck locus
% 
% <internal:H_255A8B5A CIE1931_XYZ> computes CIE 1931 XYZ color coordinates 
% and tristimulus values from spectrum
% 
% <internal:H_0FA30A6E CIE_Illuminant> returns a large selection of CIE standard 
% illuminants
% 
% <internal:H_493C3BEA CIE_Illuminant_D> computes the CIE standard daylight 
% spectrum as function of color temperature
% 
% <internal:H_B18B3F0A CRI> is a class for computing color rendering index values
% 
% <internal:H_8C73749A CODATA2018> returns a struct with CODATA 2018 values 
% for relevant physical constants (speed of light, Boltzmann constant etc.)
% 
% <internal:H_7F410E14 GaussSpectrum> creates a Gaussian spectrum for given 
% mean and standard deviation
% 
% <internal:H_7FEE43E1 IsOctave> determines if running on GNU Octave or Matlab
% 
% <internal:H_7062F614 LinInterpol> computes linear interpolation like |interp1,| 
% but about five times faster on Matlab on Windows
% 
% <internal:H_ED93D168 LinInterpolAdd4Async> computes linear interpolation of 
% the sum of four functions
% 
% <internal:H_1844A91E MakeSpectrum> creates a valid spectrum from wavelength 
% and value data
% 
% <internal:H_D5BEA816 MultiplySpectra> multiplies two spectra, e.g. an LED 
% spectrum with a transmission spectrum
% 
% <internal:H_719369C9 PlanckLocus> returns a wealth of information about the 
% Planck locus, including interpolation function objects and Judd lines of equal 
% CCT
% 
% <internal:H_57625957 PlanckSpectrum> creates a blackbody spectrum with various 
% normalizations to choose from
% 
% <internal:H_D6BB9ECF SpectrumSanityCheck> checks if a spectrum fulfills the 
% <internal:H_EC1C6D0E requirements>
% 
% <internal:H_2128175D TestLinInterpol> tests the <internal:H_7062F614 LinInterpol> 
% function
% 
% <internal:H_E49609D5 WriteLightToolsSpectrumFile> writes a spectrum to an 
% ASCII file in LightTools® format.
% 
% 
% |AddSpectra|
% Adds two spectra without weights. Convenience function with simpler interface 
% than <internal:H_8F93BC09 AddWeightedSpectra>

% function rv = AddSpectra(lhs, rhs)
%% 
% *Input:* |lhs, rhs|_:_ Both must be valid spectra.
% 
% *Output:* |rv|_:_ Sum of |rhs + lhs|. When both spectra do not overlap, the 
% wavelength ranges are concatenated, and the range in between is padded with 
% zero. If they do overlap, then |rv.lam| contains all values from both input 
% spectra, with duplicate values removed, and what is added are the linearly interpolated 
% values from both input spectra. Thus, the sum spectrum is a perfect model of 
% the underlying continuous function which is the sum of the continuous, linearly 
% interpolated input spectra.
% 
% Additional fields present in |lhs| or |rhs| will be stripped, |rv| will have 
% only fields |lam| and |val.|
% 
% *Usage Example:*

clear s1 s2 sumspec
s1 = MakeSpectrum([400,500,600],[1, 2, 4]);
s2 = MakeSpectrum([400,560,610],[4, 4, 1]);
sumspec = AddSpectra(s1,s2);
nfig = nfig + 1;
figure(nfig);
clf;
hold on;
plot(s1.lam, s1.val,'Marker','x');
plot(s2.lam, s2.val,'Marker','x');
plot(sumspec.lam, sumspec.val,'Marker','x');
legend({'s1','s2','sumspec'},'Location','NorthWest');
axis([390 610 0 8]);
grid on;
xlabel('lam');
ylabel('val');
title('AddSpectra demo');
% |AddWeightedSpectra|
% Computes weighted sum of several spectra.

% function rv = AddWeightedSpectra(spectra,weights)
%% 
% *Input:*
% 
% |spectra|: Nonempty _c_ell array of spectra
% 
% |weights|_:_ Vector of numeric non-complex values, same length as |spectra|_._
% 
% *Output:* |rv|_:_ Weighted sum of input spectra. When spectra do not overlap, 
% the wavelength ranges are concatenated, and the range in between is padded with 
% zero. If they do overlap, then |rv.lam| contains all values from all input spectra, 
% with duplicate values removed, and sorted, and what is added are the linearly 
% interpolated values from all input spectra. Thus, the sum spectrum is a perfect 
% model of the function which is the sum of the continuous, linearly interpolated 
% input spectra.
% 
% Additional fields present in |spectra| will be stripped, |rv| will have only 
% fields |lam| and |val|_._
% 
% *Usage Example:*
% 
% Add a red, a green, and a blue spectrum created by <internal:H_7F410E14 GaussSpectrum>

clear red green blue sumspec
red = GaussSpectrum(linspace(550,700),620,15);
green = GaussSpectrum(linspace(430,730),530,20);
blue = GaussSpectrum(linspace(400,500),450,8);
sumspec = AddWeightedSpectra({red, green, blue},[2, 5, 1.5]);
nfig = nfig + 1;
figure(nfig);
clf;
hold on;
plot(red.lam, red.val,'r');
plot(green.lam, green.val,'g');
plot(blue.lam, blue.val,'b');
plot(sumspec.lam, sumspec.val,'k');
legend({'red','green','blue','sumspec'},'Location','NorthWest');
grid on;
xlabel('lam');
ylabel('val');
title('AddWeightedSpectra demo');
%% |AssignNewWavelength|
% Assign a new wavelength vector to a spectrum, interpolating the old values.

% function rv = AssignNewWavelength(spectrum, lam_new)
%% 
% *Input:*
% 
% |spectrum:| a spectrum
% 
% |lam_new:| the new wavelength array, ascending doubles.
% 
% *Output:*
% 
% |rv:| A copy of the old spectrum with all fields, but |lam| is replaced and 
% |val| is interpolated. For |lam_new| values outside the old interval, |val(i) 
% == 0|
% 
% *Usage Example:*

s_old = MakeSpectrum([400 500], [0 100]);
s_new = AssignNewWavelength(s_old, [450 451 452])
%% |CCT_from_xy|
% Compute correlated color temperature of an xy color point. Uses parabolic 
% interpolation between nearest <internal:H_719369C9 Planck locus >points

% function [CCT, dist_uv] = CCT_from_xy(x,y)
%% 
% *Input:* |x, y| scalar numbers, x/y color coordinates
% 
% *Output:* 
% 
% |CCT:|  Correlated color temperature in Kelvin
% 
% |dist_uv:| Distance to Planck locus in u/v color space. When |dist_uv>0.05,| 
% a warning is issued, when |dist_uv| > 0.09, an error. Positive when x/y is above 
% Planck locus (on the "green" side), negative when below.
% 
% *Usage Example:*

clear T pl jl uv den x y CCT dist_uv
T = 3456; 
pl = PlanckLocus;
jl = pl.JuddLine_func(T);
% compute uv coordinates for color point with CCT == T,
% 0.04 away from Planck
uv = [jl.u, jl.v] + 0.04 * [jl.du, jl.dv];
% compute xy coordinates by standard transformation 
den = 2*uv(1) - 8*uv(2) + 4;
x = 3*uv(1)/den;
y = 2 * uv(2) / den;
% compute CCT 
[CCT, dist_uv] = CCT_from_xy(x,y);
CCT - T % should be zero, is about 1.3 mK
dist_uv - 0.04 % should be zero
%% |CIE1931_lam_x_y_z.mat|
% A .mat file which contains a struct named |'CIE1931XYZ'| with CIE 1931 data: 
% x/y/z color matching functions, monochromatic border x/y coordinates with corresponding 
% wavelengths, and coordinates of the Planck locus with corresponding absolute 
% temperatures.
% 
% *Usage Example:*

clear CIE1931XYZ;
load('CIE1931_lam_x_y_z.mat','CIE1931XYZ')
CIE1931XYZ
% |CIE1931_XYZ|
% Computes CIE 1931 color coordinates.

% function rv = CIE1931_XYZ(spec)
%% 
% *Input:* |spec| is a _spectrum_ struct, see above for requirements.
% 
% *Output:* A struct with fields |X Y Z x y z|. 
% 
% Capital   |X Y Z| are the CIE tristimulus values, i.e. the result of integrating 
% |spec| with the CIE 1931 standard x y z color matching functions.
% 
% |x y z| are the corresponding color coordinates, |x = X / (X + Y + Z)|  etc.
% 
% *Usage example:*

clear s;
s.lam = [360 830];
s.val = [1 1];
% this is a flat spectrum, known as CIE standard illuminant E. 
% By definition, it should have color coordinates x == y == 1/3-
s.XYZ = CIE1931_XYZ(s);
% This is a common pattern: Compute information from a spectrum, and then
% add this information to the same spectrum as an additional field
s
s.XYZ
%% |CIE_Illuminant|
% Returns CIE standard illuminants.
% 
% Available spectra are: 'A';'D65';'C';'E','D50';'D55';'D75';'FL1';'FL2';'FL3';'FL4';'FL5';'FL6';'FL7';'FL8';'FL9';'FL10';'FL11';'FL12';
% 
% 'FL3_1';'FL3_2';'FL3_3';'FL3_4';'FL3_5';'FL3_6';'FL3_7';'FL3_8';'FL3_9';'FL3_10';'FL3_11';'FL3_12';'FL3_13';'FL3_14';'FL3_15';
% 
% 'HP1';'HP2';'HP3';'HP4';'HP5'

% function rv = CIE_Illuminant(name,varargin)
%% 
% *Input:* name is the desired name, one of the available names listed above
% 
% varargin: Name/Value pair 'lam',lam to define the desired wavelength table 
% to which the illuminant spectrum will be interpolated. Default is 360:830 nm 
% in 1 nm steps
% 
% *Output:* spectrum struct with fields lam (copy of input, or default 360:830), 
% val and name (copy of input name)
% 
% *Usage Example:*

FL4 = CIE_Illuminant('FL4')
clf;plot(FL4.lam,FL4.val);
title('CIE standard FL4 fluorescent spectrum')
%% |CIE_Illuminant_D|
% Returns CIE standard daylight illuminant D as function of CCT.

% function rv = CIE_Illuminant_D(CCT,varargin)
%% 
% *Input:* CCT is the desired color temperature. Must be in [4000, 25000]. 
% 
% varargin: Name/Value pair 'lam',lam to define the desired wavelength table 
% to which the illuminant spectrum will be interpolated. Default is 360:830 nm 
% in 1 nm steps
% 
% *Output:* spectrum struct with fields lam (copy of input, or default 360:830), 
% val and name (copy of input name)
% 
% *Usage Example:*

D6100 = CIE_Illuminant_D(6100,'lam',300:5:830);
clf;plot(D6100.lam,D6100.val);
title('CIE standard D (daylight) spectrum for CCT = 6100');
%% |CODATA2018|
% A struct with the most relevant physical constants for optics, as defined 
% by <http://www.codata.org/ CODATA>

% function cd = CODATA2018()
%% 
% *Input:* None
% 
% *Output:* Struct with fields:
% 
% |b|: Wien's wavelength displacement law constant
% 
% |bprime|: Wien frequency displacement law constant
% 
% |c|: speed of light in vacuum
% 
% |e|: elementary charge
% 
% |h|: Planck constant
% 
% |k|: Boltzmann constant
% 
% |me|: electron mass
% 
% |mn|: neutron mass
% 
% |mp|: proton mass
% 
% |NA|: Avogadro constant
% 
% |R|: molar gas constant
% 
% |Vm|: molar volume of ideal gas
% 
% |sigma|: Stefan-Boltzmann constant
% 
% |c1|: first radiation constant (2 pi h c^2)
% 
% |c1L|: first radiation constant for spectral radiance (2 h c^2)
% 
% |c2|: second radiation constant (h c / k)
% 
% Each field is a struct with fields |name, value, reluncertainty, absuncertainty, 
% unit.| Most uncertainties are zero, since 2018.
% 
% *Usage Example:*

clear cd lambda freq pe c
cd = CODATA2018();
lambda = 500e-9; % in meters
c = cd.c.value % speed of light
freq = c/lambda% frequency of 500 nm light about 600 THz
pe = freq * cd.h.value % energy of a 500 nm photon, in Joule
%% |CRI|
% A class to compute color rendering indices. See <https://en.wikipedia.org/wiki/Color_rendering_index, 
% https://en.wikipedia.org/wiki/Color_rendering_index,> and CIE 13.3-1995 Technical 
% Report

% classdef CRI < handle 
%% 
% *Constructor:*

% function this = CRI()
cri = CRI()
%% 
% loads the CRI reflectivity spectra into the read-only variable <internal:BB7E62A5 
% CRISpectra_>
% 
% *SetStrict_5nm*

% function prev = SetStrict_5nm(this, yesno)
prev = cri.SetStrict_5nm(true)
% do something
cri.SetStrict_5nm(prev); % restore previous state
%% 
% sets the internal wavelength interval to 5 nm or 1 nm
% 
% *Input:* yesno: logical (true -> 5nm, false -> 1nm)
% 
% *Output:* prev: logical, the value before the call
% 
% *SingleRi*
% 
% computes a special Ri value

% function rv = SingleRi(this, spectrum, i)
FL4 = CIE_Illuminant('FL4');
D65 = CIE_Illuminant('D65');
cri.SingleRi(FL4,9) % Really really bad R9, fluorescent and saturated red don't work well
cri.SingleRi(D65,9) % By definition, CIE D should work perfectly for CCT > 5000
%% 
% *Ra*
% 
% computes the general Ra, the by far most used value

% function [rv, Ri_1_8] = Ra(this, spectrum)
cri.Ra(FL4) % CRI is designed to give 51
cri.Ra(D65) % by definition, 100
%% 
% *Input:* a spectrum
% 
% *Output:* rv: double, the Ra value.
% 
% Ri_1_8: array of eight doubles, the individual Ri values of which Ra is the 
% mean
% 
% *FullCRI*
% 
% computes the CRI for all sixteen reflectivity spectra. R1..R14 are defined 
% in the standard, R15 is Asian skin, and R16 (my personal addition) is perfect 
% white

% function rv = FullCRI(this, spectrum)
cri.FullCRI(FL4)
%% 
% *Input:* a spectrum
% 
% *Output:* rv:  a struct with fields Ri (array of 16 doubles, the individual 
% Ri values), and Ra (the general index)
% 
% *PlotCRISpectra*
% 
% plots the 16 reflectivity spectra

% function PlotCRISpectra(this)
cri.PlotCRISpectra();
%% 
% *CRISpectra_*
% 
% a read-only property. An array of 16 structs with fields describing the individual 
% spectra:

cri.CRISpectra_
%% |GaussSpectrum|
% Creates a normalized Gaussian spectrum with given mean and standard deviation

% function rv = GaussSpectrum(lam_vec,mean,sdev,varargin)
%% 
% *Input:* 
% 
% |lam_vec:| A vector of positive reals, strictly ascending
% 
% |mean:| Scalar positive number. Mean value of the distribution. May or may 
% not be in the |lam_vec| range.
% 
% |sdev:| Scalar positive number. Standard deviation
% 
% |varargin:| Optional string argument '|val_only'.|
% 
% *Output:* 
% 
% |rv:| Spectrum struct, with additional |name| field. Except if optional argument 
% '|val_only|' is present: Then, rv is a column vector of the values.
% 
% *Usage Example:*
% 
% see also example for |AddWeightedSpectra.|

GaussSpectrum(400:500,450,10)
%% |IsOctave|
% Determines if code is running under GNU Octave (or Matlab)

% function rv = IsOctave()
%% 
% *Output:* Returns logical 1 when running under GNU Octave, else returns logical 
% 0
% 
% *Usage Example:*

IsOctave()
%% |LinInterpol|
% Computes linearly interpolated values of scalar tabulated function. Very similar 
% to built in |interp1|, but uses faster C++ DLL under Matlab (on my machine, 
% a factor of five faster).
% 
% Used internally as a helper function for higher level library functions, but 
% exposed as a proper library function because it may well be useful to speed 
% up computation in another context.

% function yq = LinInterpol(xx,yy,xq)
%% 
% *Input:* 
% 
% |xx| is a 1D vector of numeric values which are not complex, and strictly 
% ascending
% 
% |yy| is a 1D vector of numeric values which are not complex.
% 
% |xx| and |_yy_| are of same length and have at least two elements
% 
% |xq| is a 1D vector of numeric values which are not complex, and strictly 
% ascending (the latter is NOT a requirement for |interp1|)
% 
% These preconditions are not checked.
% 
% *Output:*
% 
% |yq| is a vector of same length as |xq|_,_ with linearly interpolated values. 
% Zero if outside the |xx| range. 
% 
% *Usage Example:*

LinInterpol([1 2],[3 4],[-100,1,2,1.7])
%% |LinInterpolAdd4Async|
% Computes linearly interpolated values of the sum of four input functions. 
% Uses C++ DLL with multithreading under Matlab. On my machine, a factor of five 
% faster than summing the result of |interp1| calls, but not faster than summing 
% the results of four |LinInterpol| calls. I still leave the function in place, 
% there may be a difference for other input values and/or on another machine.

% function yq = LinInterpolAdd4Async(xx0,yy0,xx1,yy1,xx2,yy2,xx3,yy3,xq)
%% 
% *Input:* 
% 
% |xx0| is a 1D vector of numeric values which are not complex, and strictly 
% ascending
% 
% |yy0| is a 1D vector of numeric values which are not complex.
% 
% |xx0| and |yy0| are of same length and have at least two elements.
% 
% Same applies to the |xx1/yy1, xx2/yy2, xx3/yy3| pairs, but the |xx_| arrays 
% may all be different.
% 
% |xq| is a 1D vector of numeric values which are not complex, and strictly 
% ascending (the latter is NOT a requirement for |interp1|!!)
% 
% *Output:* |yq| is a vector of same length as |xq|_,_ with the sum of the four 
% linearly interpolated values.
% 
% *Usage Example:*

LinInterpolAdd4Async([0 1],[1 1.1], [0 1],[2 2], [0 1],[3 3], [0 2],[4 4], [0, 1, 0.5])
%% |MakeSpectrum|
% Creates a spectrum struct out of arrays |lam| and |val| and checks if they 
% meet the <internal:H_EC1C6D0E requirements>

% function rv = MakeSpectrum(lam, val)
%% 
% *Input:* 
% 
% |lam| is a 1D vector of numeric values which are not complex, > 0, and strictly 
% ascending
% 
% |val| is a 1D vector of numeric values which are not complex.
% 
% |lam| and |val| are of same length and have at least two elements.
% 
% The <internal:H_EC1C6D0E requirements> are checked, an error thrown if violated
% 
% *Output:* 
% 
% |rv| is a spectrum struct with column vector fields |lam| and |val|_._
% 
% *Usage Example:*

clear s
s = MakeSpectrum([400 700], [1 1])
%% |MultiplySpectra|
% Multiply two spectra, e.g. an LED spectrum with a transmission spectrum

% function rv = MultiplySpectra(lhs, rhs)
%% 
% *Input:* |lhs, rhs:|  Valid spectrum structs. May or may not overlap.
% 
% *Output:* |rv:| Spectrum struct, modeling the product of _lhs(lambda) * rhs(lambda)_. 
% The |rv.lam| field covers the overlap region, if any, where it contains all 
% wavelengths from both inputs. The |rv.val| field contains the product of the 
% respective interpolated values. There is no need to have zero values outside 
% the overlap range, as zero is always assumed outside anyway. When there is no 
% overlap, |rv| contains a single interval as the overall min/max wavelength range, 
% with zero value.
% 
% *Usage Example:*

clear s1 s2 prodspec;
s1 = GaussSpectrum(400:500, 450,10);
s2 = MakeSpectrum([430 470],[0 2]);
prodspec = MultiplySpectra(s1, s2);
nfig = nfig + 1;
figure(nfig);
clf;
hold on;
plot(s1.lam, s1.val);
plot(s2.lam, s2.val);
plot(prodspec.lam, prodspec.val);
legend({'s1','s2','prodspec = s1*s2'},'Location','northwest');
%% |PlanckLocus|
% Compute the x/y, u/v, u'/v' coordinates of the Planck locus, as well as interpolation 
% function objects for x/y, u/v, and the Judd lines (lines of equal correlated 
% color temperature) in u/v.

% function rv = PlanckLocus()
%% 
% *Input:* None
% 
% *Output:* Struct with fields:
% 
% |nT|: Number of temperature points (1001)
% 
% |invT|: Inverse absolute temperature values, from near zero (1e-11) to 0.002 
% (1/K), in equidistant steps. (The Planck locus points are approximately equidistant 
% in 1/T, and not at all equidistant in T)
% 
% |T|: Absolute temperature values, from 1e11 K down to 500 K
% 
% |x|: CIE 1931 x color coordinate values of the Planck locus curve
% 
% y: CIE 1931 y color coordinate values of the Planck locus curve
% 
% u: CIE u color coordinate values of the Planck locus curve (to be used only 
% for CCT computation purposes)
% 
% v: CIE v color coordinate values of the Planck locus curve (to be used only 
% for CCT computation purposes)
% 
% up: CIE u' (u_prime) color coordinate values of the Planck locus curve 
% 
% vp: CIE v' (v_prime) color coordinate values of the Planck locus curve 
% 
% |xy_func|: A function object to compute interpolated values of the x/y color 
% coordinates of the Planck locus. To be called like |xy = rv.xy_func(T)| where 
% T is a scalar of vector of absolute temperatures, and returns an array of size 
% |[2, length(T)]| with the interpolated x values as first column and the interpolated 
% y values as second column. Returns |NaN| when |T| is out of range 500 .. 1e11
% 
% |uv_func|: Same as |xy_func|, except it returns u/v values.
% 
% |JuddLine_func|: A function object to compute interpolated values of the Judd 
% line parameters. To be called like |jl = rv.JuddLine_func(T)| where T is a scalar, 
% absolute temperature. Returns a struct with fields |u, v, du, dv| where [|u,v]| 
% are the u/v coordinates of the Planck locus point for |T|, and |[du,dv]| is 
% the Judd line direction, normalized to length 1. By definition, the Judd line 
% is perpendicular to the Planck locus in u/v color space, and all color points 
% on a Judd line are deemed to have same CCT (correlated color temperature). Note 
% that the "allowed" meaningful range is +/- 0.05 u/v length units away from the 
% Planck locus.
% 
% *Usage Example:*

clear pl xb yb T xy
pl = PlanckLocus();
load('CIE1931_lam_x_y_z.mat','CIE1931XYZ');
nfig = nfig + 1;
figure(nfig);
clf;
hold on;
xb = CIE1931XYZ.xBorder;
yb = CIE1931XYZ.yBorder;
xb(end+1)=xb(1); % close loop
yb(end+1)=yb(1);
plot(xb,yb,'k');
plot(pl.x,pl.y);
T = [1000 2000 3000 4000 5000 6000];
xy = pl.xy_func(T);
scatter(xy(:,1),xy(:,2));
axis equal;
grid on;
axis([0 0.8 0 0.9]);
xlabel('CIE x');
ylabel('CIE y');
title('CIE xy border and Planck locus demo')
%% |PlanckSpectrum|
% Generate blackbody spectrum for some absolute temperature.

% function rv = PlanckSpectrum(lam_vec, T, varargin)
%% 
% *Input:* 
% 
% |lam_vec:| A wavelength vector, numeric, non-complex, positive, strictly ascending
% 
% |T:| Scalar real number, absolute temperature in K. May be |inf|, then returns 
% |lam_vec.^(-4),| scaled to |localpeak1| (this is the high temperature limit 
% of the shape of the long wavelength tail).
% 
% |varargin:| Name/Value pairs.
% 
% |'normalize'| -> string, default |'globalpeak1'.| Allowed values:
% 
% |'globalpeak1'|: scaled such that global peak would be 1.0 even if outside 
% lambda range
% 
% |'localpeak1'|: scaled such that the peak value is 1.0 for the given |lam_vec.| 
% Not exactly identical if global peak is in range, due to discretization
% 
% |'localflux1'|: scaled such that integral over |lam_vec| is 1.0
% 
% |'radiance'|: scaled such |rv| is blackbody spectral radiance, W/(wlu m²sr). 
% wlu is wavelengthUnit, see below
% 
% |'exitance'|: scaled such that rv is blackbody spectral exitance, W/(wlu m²). 
% wlu is wavelengthUnit, see belo
% 
% |'wavelengthUnit'| -> positive real, wavelength unit in meters, default 1e-9 
% (nanometers). 
% 
% |1e-9| : |lam_vec| given in nm, returned spectrum is W / (nm m² sr) or W / 
% (nm m²) for radiance/exitance scaling. |rv.XYZ| will be CIE XYZ values X, Y, 
% Z, x, y
% 
% *Output:* Spectrum struct with fields
% 
% |lam:| Same as |lam_vec,| but column vector.
% 
% |val:| The spectral values, column vector of same length, normalized according 
% to |'normalize'| (default: global peak 1.0).
% 
% |name:| string, an appropriate name
% 
% *Usage Example:*

clear bb T 
nfig = nfig + 1;
figure(nfig);
clf;
hold on;
for T = [3000 4000 5000 6000]
    bb = PlanckSpectrum(200:2000,T,'normalize','radiance');
    plot(bb.lam,bb.val);
end
xlabel('\lambda (nm)');
ylabel('spectral radiance L_\lambda (W/(m² nm sr)')
legend({'3000K','4000K','5000K','6000K'})
title('Blackbody spectral radiance')
%% |SpectrumSanityCheck|
% Checks <internal:H_EC1C6D0E requirements> for a spectrum variable, and returns 
% a sanitized version of the variable, with column vectors |lam| and |val|.

% function [ok, msg, rv] = SpectrumSanityCheck(spec, varargin)
%% 
% *Input:* 
% 
% |spec|  is a spectrum which should adhere to the <internal:H_EC1C6D0E requirements> 
% above.
% 
% |varargin| are optional name/value pairs:
% 
% '|doThrow|', logical, default: true. If there is an error: If flag is true, 
% throws error exception, else returns false in |ok| and an error message in _msg_.
% 
% '|doStrip|', logical, default: false: If true returns |rv| with only the |lam| 
% and |val| fields, else returns |rv| with all fields of input |spec|
% 
% *Output:* 
% 
% |ok|: Logical. True if there are no requirement violations, else false
% 
% |msg|_:_ Character string. Empty string if there are no requirement violations, 
% else diagnostic message.
% 
% |rv|_:_ A spectrum struct where |lam| and |val| are same as in |spec| except 
% that both are always column vectors. When the |doStrip| flag is false, also 
% has all other fields of |spec|_._ At requirement violation, is empty array.
% 
% *Usage Example:*

clear good bad ok1 msg1 rv1 ok2 msg2 rv2
good = MakeSpectrum([400 700], [1 1]);
[ok1, msg1, rv1] = SpectrumSanityCheck(good)
bad = struct('lam', [1, 2, 1], 'val', [0 0 0]);
[ok2, msg2, rv2] = SpectrumSanityCheck(bad, 'doThrow', false)
%% |TestLinInterpol|
% A script to test the |LinInterpol| and |LinInterpolAdd4Async| functions, also 
% measuring run times.
% 
% *Input:* none
% 
% *Output:* diagnostic text
% 
% *Usage Example:*

TestLinInterpol
%% |WriteLightToolsSpectrumFile|
% Write LightTools .sre spectrum file, to assign to a source

% function WriteLightToolsSptrumFile(spectrum, filename, varargin)
%% 
% *Input:*
% 
% |spectrum|: A valid spectrum with .lam and .val fields. See <internal:H_EC1C6D0E 
% Spectrum requirements>.
% 
% If spectrum has other fields which are simple strings or numeric values, they 
% will be written as named comments. E.g. if spectrum.name == 'My LED' then '# 
% name: My LED' will be written.
% 
% |filename|: name of the spectrum file. |'.sre'| is appended if necessary
% 
% optional arguments: Name-Value pairs
% 
% |'mode'|: string, only allowed value is |'discrete'.| Default spectrum mode 
% is continuous.
% 
% |'comment'| : string or cell array of strings, will be written as comment(s)
% 
% *Output:* none
% 
% *Usage Example:*

s = PlanckSpectrum(400:700,5600);
WriteLightToolsSpectrumFile(s,'Planck5600.sre');
%% 
% will write |Planck5600.sre|, with the first lines being
% 
% |# LightTools spectrum file, created 13-Oct-2019 15:16:16|
% 
% |# name: Planck blackbody spectrum for T = 5600 K, normalized to global peak 
% = 1|
% 
% |dfat 1.0|
% 
% |dataname: Planck blackbody spectrum for T = 5600 K, normalized to global 
% peak = 1|
% 
% |continuous|
% 
% |radiometric|
% 
% |400	0.838583|
% 
% |401	0.841573|
% 
% 
%% |template for copy paste|
% descr

% 
%% 
% *Input:*
% 
% |rhs:| the right hand side
% 
% *Output:*
% 
% |lhs:| the left hand side
% 
% *Usage Example:*


%%