%% Design decisions
% 
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp; 
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp; 
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp; 
% <a href="GroupedList.html"> Grouped list</a>
% </p>
% </html>
%
%% Spectrum
% In this library, a spectrum is a struct with at least two fields named |lam| and |val|, which meet the following requirements:
%
% * |lam| is a 1D vector of real numbers, all > 0, and strictly ascending.
% * |val| is a 1D vector of real numbers.
% * |lam| and |val| are of same length and have at least two elements.
% 
% It is desirable, but not necessary, for |lam| and |val| to be column vectors.
% 
% There is a function |rv = SpectrumSanityCheck(rhs)| (see <SpectrumSanityCheck.html here>), which tests all these requirements 
% and, if met, returns the same struct except that |lam| and |val| are converted to column vectors if necessary.
% 
% A spectrum models the function S(lambda) which represents a physical scalar function of wavelength. Like spectral radiant flux, spectral irradiance, 
% spectral radiant intensity, spectral radiance, spectral transmission, spectral absorption, spectral efficiency. The tabulated values in |val| are 
% linearly interpolated. Outside the range given by |lam|,  S(lambda) == 0. 
% 
% Accordingly, there are no spectra consisting of truly monochromatic lines in this library. If you want to approximate line spectra, 
% make very narrow triangles. Spectra are continuous, except at the wavelength boundaries, where they jump to zero. If
% you want to avoid this discontinuity at the boundary, let |val(1) == 0| and |val(end) == 0|.
% 
% |lam| is considered to have units of nanometers in all library functions that make use of this unit, e.g. color calculations.
%
% Why structs and not classes? Classes are nice to guarantee that properties like |lam| and |val| always are present, and would allow methods which operate directly on spectra. 
% However, structs are simpler and more versatile. I, as the library designer, cannot know which additional information a user (I myself, for example), 
% wants to attach to a given spectrum. Name, date, name of LED, color coordinates and more. To make a spectrum s, I can simply say
%
clear s
s.lam = [360 830];
s.val = [1 1];
s.name = "CIE standard illuminant E";
s.hopp = "topp";
s
%%
% to give it an appropriate name and an arbitrary value in an arbitrary additional field. Of course, a user could always create a subclass to add 
% properties to a given class, but it is just so much simpler to assign to an additional struct field in a single line. 
% In my experience, these conventions for spectra are simple and few enough
% to be easily remembered and adhered to. 
%% Conventions
% In my code, I like to have long unabbreviated variable and function names. Except for a few standards:
% 
% * |rv| is my name for the return value of a function
% * |spec| is my name for a single spectrum argument of a function.
% * |lhs| and |rhs|  are short for 'left hand side' and 'right hand side', the arguments of a binary function.
% 
% Proper library function names start with capital letters, e.g.
% |MakeSpectrum.m|. Internal helper functions start with a small "i", e.g.
% |iLinInterpolProto.m|, and scripts used for generating documentation start
% with a small "doc", e.g. |docDesignDecisions.m| which creates this page.
% 
% A spectrum struct is valid if it has fields |lam| and |val| which fulfill the requirements above. In addition, I assume a spectrum may have the following fields:
%
% * |name|:  A short character string with a name. 
% * |description|: A longer character string with a description.
% * |XYZ|:  A struct with tristimulus and color coordinate fields X, Y, Z, x, y, z, typically created by code like s.XYZ = CIE1931_XYZ(s)