%% JMO Spectrum Library Documentation
% Version 1.0, Sept. 13th, 2019
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
% # |lam|_ _is a 1D vector of numeric values which are not complex, > 0, and 
% strictly ascending
% # |val| is a 1D vector of numeric values which are not complex.
% # |lam |and |val |are of same length and have at least two elements
%% 
% It is desirable for |lam |and |val |to be column vectors.
% 
% There is a function |rv = SpectrumSanityCheck(rhs)|, which tests all these 
% requirements and, if met, returns the same struct except that |lam |and |val 
% |are converted to column vectors if necessary.
% 
% A _spectrum_ models the function _S(lambda)_ which represents a physical scalar 
% function of wavelength. Like spectral radiant flux, spectral irradiance, spectral 
% radiant intensity, spectral radiance, spectral transmission, spectral absorption, 
% spectral efficiency. The tabulated values in |val |are linearly interpolated. 
% Outside the range given by |lam|_, _ _S(lambda)_ == 0.
% 
% |lam |is considered to have units of nanometers in all library functions that 
% make use of this unit, e.g. color calculations.
% 
% Why structs and not classes? Classes are nice to guarantee that properties 
% like |lam |and |val |always are present, and would allow methods which operate 
% directly on spectra. However, structs are simpler and more versatile. I, as 
% the library designer, cannot know which additional information a user (I myself, 
% for example), wants to attach to a given spectrum. Name, date, name of LED, 
% color coordinates and more. To make a spectrum s, I can simply say

clear s
nfig = 0; %figure number to be used in examples
s.lam = [360 830];
s.val = [1 1];
s.name = "CIE standard illuminant E";
s.hopp = "topp"
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
% |rv|_ _is my name for the return value of a function
% 
% |spec |is my name for a single spectrum argument of a function.
% 
% |lhs |and |rhs  |are short for 'left hand side' and 'right hand side', the 
% arguments of a binary function.
% 
% Proper library function names start with capital letters, e.g. |MakeSpectrum|. 
% Internal helper functions start with a small "i", e.g. |iLinInterpolProto|.
% 
% A spectrum struct is valid if it has fields lam and |val |which fulfill the 
% requirements above. In addition, I assume a spectrum may have the following 
% fields:
% 
% |name|_: _ A short character string with a name. 
% 
% |description|_: _A longer character string with a description.
% 
% |XYZ|_: _ A struct with tristimulus and color coordinate fields |X, Y, Z, 
% x, y, z|, typically created by code like |s.XYZ = CIE1931_XYZ(s)|
%% Function reference
% |AddSpectra|
% Adds two spectra without weights. Convenience function with simpler interface 
% than <internal:H_8F93BC09 AddWeightedSpectra>

% function rv = AddSpectra(lhs, rhs)
%% 
% *Input:* |lhs, rhs|_: _Both must be valid spectra.
% 
% *Output:* |rv|_: _Sum of |rhs + lhs|. When both spectra do not overlap, the 
% wavelength ranges are concatenated, and the range in between is padded with 
% zero. If they do overlap, then |rv.lam| contains all values from both input 
% spectra, with duplicate values removed, and what is added are the linearly interpolated 
% values from both input spectra. Thus, the sum spectrum is a perfect model of 
% the underlying continuous function which is the sum of the continuous, linearly 
% interpolated input spectra.
% 
% Additional fields present in |lhs |or |rhs |will be stripped, |rv |will have 
% only fields |lam |and |val.|
% 
% *Usage Example:*

clear s1 s2 sumspec
s1 = MakeSpectrum([400,500,600],[1, 2, 4]);
s2 = MakeSpectrum([400,560,600],[4, 4, 1]);
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
% |spectra|:_ _Nonempty _c_ell array of spectra
% 
% |weights|_: _Vector of numeric non-complex values, same length as |spectra|_._
% 
% *Output:* |rv|_: _Weighted sum of input spectra. When spectra do not overlap, 
% the wavelength ranges are concatenated, and the range in between is padded with 
% zero. If they do overlap, then |rv.lam| contains all values from all input spectra, 
% with duplicate values removed, and sorted, and what is added are the linearly 
% interpolated values from all input spectra. Thus, the sum spectrum is a perfect 
% model of the function which is the sum of the continuous, linearly interpolated 
% input spectra.
% 
% Additional fields present in |spectra| will be stripped, |rv |will have only 
% fields |lam |and |val|_._
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
% |CIE1931_XYZ|
% Computes CIE 1931 color coordinates.

% function rv = CIE1931_XYZ(spec)
%% 
% *Input: *|spec|_ _is a _spectrum _struct, see above for requirements.
% 
% *Output:* A struct with fields |X Y Z x y z|. 
% 
% Capital _  _|X Y Z |are the CIE tristimulus values, i.e. the result of integrating 
% |spec| with the CIE 1931 standard x y z color matching functions.
% 
% |x y z|_ _are the corresponding color coordinates, |x = X / (X + Y + Z)|_ 
% _ etc.
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
% unit. |Most uncertainties are zero, since 2018.
% 
% *Usage Example:*

clear cd lambda freq pe c
cd = CODATA2018();
lambda = 500e-9; % in meters
c = cd.c.value % speed of light
freq = c/lambda% frequency of 500 nm light about 600 THz
pe = freq * cd.h.value % energy of a 500 nm photon, in Joule
%% |GaussSpectrum|
% Creates a normalized Gaussian spectrum with given mean and standard deviation

% function rv = GaussSpectrum(lam_vec,mean,sdev,varargin)
%% 
% *Input:* 
% 
% |lam_vec: |A vector of positive reals, strictly ascending
% 
% |mean: |Scalar positive number. Mean value of the distribution. May or may 
% not be in the |lam_vec |range.
% 
% |sdev: |Scalar positive number. Standard deviation
% 
% |varargin: |Optional string argument '|val_only'.|
% 
% *Output:* 
% 
% |rv: |Spectrum struct, with additional |name |field. Except if optional argument 
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
% |xx|_ _is a 1D vector of numeric values which are not complex, and strictly 
% ascending
% 
% |yy| is a 1D vector of numeric values which are not complex.
% 
% |xx|_ _and |_yy _|are of same length and have at least two elements
% 
% |xq|_ _is a 1D vector of numeric values which are not complex, and strictly 
% ascending (the latter is NOT a requirement for |interp1|)
% 
% These preconditions are not checked.
% 
% *Output:*
% 
% |yq|_ _is a vector of same length as |xq|_,_ with linearly interpolated values. 
% Zero if outside the |xx|_ _range. 
% 
% *Usage Example:*

LinInterpol([1 2],[3 4],[-100,1,2,1.7])
%% |LinInterpolAdd4Async|
% Computes linearly interpolated values of the sum of four input functions. 
% Uses C++ DLL with multithreading under Matlab. On my machine, a factor of five 
% faster than summing the result of |interp1 |calls, but not faster than summing 
% the results of four |LinInterpol |calls. I still leave the function in place, 
% there may be a difference for other input values and/or on another machine.

% function yq = LinInterpolAdd4Async(xx0,yy0,xx1,yy1,xx2,yy2,xx3,yy3,xq)
%% 
% *Input:* 
% 
% |xx0 |is a 1D vector of numeric values which are not complex, and strictly 
% ascending
% 
% |yy0 |is a 1D vector of numeric values which are not complex.
% 
% |xx0 |and |yy0 |are of same length and have at least two elements.
% 
% Same applies to the |xx1/yy1, xx2/yy2, xx3/yy3| pairs, but the |xx_ |arrays 
% may all be different.
% 
% |xq |is a 1D vector of numeric values which are not complex, and strictly 
% ascending (the latter is NOT a requirement for |interp1|!!)
% 
% *Output: *|yq|_ _is a vector of same length as |xq|_,_ with the sum of the 
% four linearly interpolated values.
% 
% *Usage Example:*

LinInterpolAdd4Async([0 1],[1 1.1], [0 1],[2 2], [0 1],[3 3], [0 2],[4 4], [0, 1, 0.5])
%% |MakeSpectrum|
% Creates a spectrum struct out of arrays |lam |and |val |and checks if they 
% meet the <internal:H_EC1C6D0E requirements>

% function rv = MakeSpectrum(lam, val)
%% 
% *Input:* 
% 
% |lam |is a 1D vector of numeric values which are not complex, > 0, and strictly 
% ascending
% 
% |val |is a 1D vector of numeric values which are not complex.
% 
% |lam |and |val |are of same length and have at least two elements.
% 
% The <internal:H_EC1C6D0E requirements> are checked, an error thrown if violated
% 
% *Output:* 
% 
% |rv |is a spectrum struct with column vector fields |lam |and |val|_._
% 
% *Usage Example:*

s = MakeSpectrum([400 700], [1 1])
%% |MultiplySpectra|
% Multiply two spectra, e.g. an LED spectrum with a transmission spectrum

% function rv = MultiplySpectra(lhs, rhs)
%% 
% *Input:* |lhs, rhs: | Valid spectrum structs. May or may not overlap.
% 
% *Output:* |rv: |Spectrum struct, modeling the product of _lhs(lambda) * rhs(lambda)_. 
% The |rv.lam| field covers the overlap region, if any, where it contains all 
% wavelengths from both inputs. The |rv.val |field contains the product of the 
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
% coordinates of the Planck locus. To be called like |xy = rv.xy_func(T) |where 
% T is a scalar of vector of absolute temperatures, and returns an array of size 
% |[2, length(T)] |with the interpolated x values as first column and the interpolated 
% y values as second column. Returns |NaN |when |T| is out of range 500 .. 1e11
% 
% |uv_func|: Same as |xy_func|, except it returns u/v values.
% 
% |JuddLine_func|: A function object to compute interpolated values of the Judd 
% line parameters. To be called like |jl = rv.JuddLine_func(T) |where T is a scalar, 
% absolute temperature. Returns a struct with fields |u, v, du, dv |where [|u,v]| 
% are the u/v coordinates of the Planck locus point for |T|, and |[du,dv] |is 
% the Judd line direction, normalized to length 1. By definition, the Judd line 
% is perpendicular to the Planck locus in u/v color space, and all color points 
% on a Judd line are deemed to have same CCT (correlated color temperature). Note 
% that the "allowed" meaningful range is +/- 0.05 u/v length units away from the 
% Planck locus.
% 
% *Usage Example:*

pl = PlanckLocus();
CIEdata = load('CIE1931_lam_x_y_z.mat');
%% |PlanckSpectrum|
% Generate blackbody spectrum for some absolute temperature.

% function rv = PlanckSpectrum(lam_vec, T, varargin)
%% 
% *Input:* 
% 
% |lam_vec: |A wavelength vector, numeric, non-complex, positive, strictly ascending
% 
% |T: |Scalar real number, absolute temperature in K. May be |inf|, then returns 
% |lam_vec.^(-4), |scaled to |localpeak1| (this is the high temperature limit 
% of the shape of the long wavelength tail).
% 
% |varargin: |Name/Value pairs.
% 
% |    'normalize'| -> string, default |'globalpeak1'. |Allowed values:
% 
% |        'globalpeak1'|: scaled such that global peak would be 1.0 even if 
% outside lambda range
% 
% |        'localpeak1'|: scaled such that the peak value is 1.0 for the given 
% |lam_vec.| Not exactly identical if global peak is in range, due to discretization
% 
% |        'localflux1'|: scaled such that integral over |lam_vec| is 1.0
% 
% |        'radiance'|: scaled such |rv| is blackbody spectral radiance, W/(wlu 
% m²sr). wlu is wavelengthUnit, see below
% 
% |        'exitance'|: scaled such that rv is blackbody spectral exitance, 
% W/(wlu m²). wlu is wavelengthUnit, see belo
% 
% |    'wavelengthUnit'| -> positive real, wavelength unit in meters, default 
% 1e-9 (nanometers). 
% 
% |        1e-9 |: |lam_vec |given in nm, returned spectrum is W / (nm m² sr) 
% or W / (nm m²) for radiance/exitance scaling. |rv.XYZ| will be CIE XYZ values 
% X, Y, Z, x, y
% 
% *Output:* Spectrum struct with fields
% 
% |lam: |Same as |lam_vec,| but column vector.
% 
% |val: |The spectral values, column vector of same length, normalized according 
% to |'normalize'| (default: global peak 1.0).
% 
% |name:| string, an appropriate name
% 
% *Usage Example:*

clear lam_vec bb T 
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
% |spec|_ _ is a spectrum which should adhere to the <internal:H_EC1C6D0E requirements> 
% above.
% 
% |varargin |are optional name/value pairs:
% 
% '|doThrow|', logical, default: true. If there is an error: If flag is true, 
% throws error exception, else returns false in |ok| and an error message in _msg_.
% 
% '|doStrip|', logical, default: false: If true returns |rv| with only the |lam| 
% and |val|_ _fields, else returns |rv| with all fields of input |spec|
% 
% *Output:* 
% 
% |ok|: Logical. True if there are no requirement violations, else false
% 
% |msg|_: _Character string. Empty string if there are no requirement violations, 
% else diagnostic message.
% 
% |rv|_: _A spectrum struct where |lam|_ _and |val |are same as in |spec |except 
% that both are always column vectors. When the |doStrip |flag is false, also 
% has all other fields of |spec|_. _At requirement violation, is empty array.
% 
% *Usage Example:*

good = MakeSpectrum([400 700], [1 1]);
[ok, msg, rv] = SpectrumSanityCheck(good)
bad = struct('lam', [1, 2, 1], 'val', [0 0 0]);
[ok, msg, rv] = SpectrumSanityCheck(bad, 'doThrow', false)
%% |TestLinInterpol|
% A script to test the |LinInterpol|_ _and |LinInterpolAdd4Async|_ _functions, 
% also measuring run times.
% 
% *Input:* none
% 
% *Output:* diagnostic text
% 
% *Usage Example:*

TestLinInterpol
%% |Name|
% descr

% 
%% 
% *Input:* x
% 
% *Output:* x
% 
% *Usage Example:*


%%