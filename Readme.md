# JMO_Spectrum library

We deal routinely with spectra in illumination optics. We need to analyze LED spectra, compute color coordinates and color rendering values from spectra, integrate them, add spectra, multiply spectra with scalar weights and with other spectra (like transmission spectra), interpolate a given measured spectrum with non-equidistant wavelength values to a regular 1 nm array, and so on.
In practice, this is tedious: spectra come in various formats, and the problem of dealing with two spectra als tabulated values which have two different sets of wavelengths is annoying.
This open source Matlab library is designed to make these engineering tasks easy and transparent. It is compatible with GNU Octave, and with Matlab for Mac and Linux. 

For more information, look at the documentation, 
[SpectrumLibrary_Documentation.pdf](https://github.com/JuliusMuschaweck/JMO_Spectrum/blob/master/SpectrumLibrary_Documentation.pdf),
which has been created from a Matlab Live Script, 
[SpectrumLibrary_Documentation.mlx](https://github.com/JuliusMuschaweck/JMO_Spectrum/blob/master/SpectrumLibrary_Documentation.mlx).


September 2019,
Julius Muschaweck (julius@jmoptics.de)
