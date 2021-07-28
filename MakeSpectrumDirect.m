%% MakeSpectrumDirect
% 
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp; 
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp;
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp; 
% <a href="GroupedList.html"> Grouped list</a> &nbsp; | &nbsp; 
% Source code: <a href = "file:../MakeSpectrumDirect.m"> MakeSpectrumDirect.m</a>
% </p>
% </html>
%
% Creates a spectrum struct from fields lam and val without any checks, optionally adding CIE 1931 XYZ. This function
% is faster than <MakeSpectrum.html MakeSpectrum>, but should be used only in a run time sensitive context where you are sure that no
% sanity checks are necessary.
%% Syntax
% |rv = MakeSpectrumDirect(lam, val, opts)|
%% Input Arguments
% * |lam|: vector of double. The wavelength array, should be strictly positive and strictly ascending, with length > 1
%           (no single line spectra in this library)
% * |val|: vector of double, of same length as |lam|. The values of the spectrum
% * |opts|: Optional name-value pair: |'XYZ'| -> logical scalar. Default: |false|
%% Output Arguments
% * |rv|: A struct with fields |lam| and |val|, containing copies of the input arguments. If optional name-value pair is
% |'XYZ', true|, then a field |XYZ| is added, a struct which in turn contains fields |x, y, z, cw, X, Y, Z| (the value
% returned from calling |CIE1931_XYZ(rv)|). 
%% Algorithm
% Creates the spectrum struct with no checks, and calls |CIE1931_XYZ| to add field |XYZ| when requested. This 
%% See also
% <MakeSpectrum.html MakeSpectrum>, <CIE1931_XYZ.html CIE1931_XYZ>, <SpectrumSanityCheck.html SpectrumSanityCheck>
%% Usage Example
% <include>Examples/ExampleMakeSpectrumDirect.m</include>

% publish with publishWithStandardExample('filename.m') in PublishDocumentation.m

% JMO Spectrum Library, 2021. See https://github.com/JuliusMuschaweck/JMO_Spectrum
% I dedicate the JMO_Spectrum library to the public domain under Creative Commons Zero 
% (https://creativecommons.org/publicdomain/zero/1.0/legalcode)
%
function rv = MakeSpectrumDirect(lam, val, opts)
    arguments
        lam (:,1) double
        val (:,1) double
        opts.XYZ (1,1) logical = false
    end
    rv = struct('lam',lam(:),'val',val(:));
    if opts.XYZ
        rv.XYZ = CIE1931_XYZ(rv);
    end
end