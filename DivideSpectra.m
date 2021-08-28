%% DivideSpectra
% 
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp; 
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp;
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp; 
% <a href="GroupedList.html"> Grouped list</a>
% </p>
% </html>
%
% Divide two spectra, with divide by zero treatment
%% Syntax
% rv = |DivideSpectra(lhs, rhs, opts)|
%% Input Arguments
% * |lhs|: A valid spectrum, i.e. a struct with two array fields, |lam| and |val| (see <SpectrumSanityCheck.html SpectrumSanityCheck> for detailed requirements)
% * |rhs|: Likewise
% * |opts|: Name-Value pair. |'tiny'| must be a positive double scalar. Default is |eps|, i.e. |2.2204e-16|. 
% Relative threshold to avoid division by (near) zero.
% Those rhs values whose magnitude is less than
% |tiny * max(abs(rhs.val))| are effectively set to |Inf|, i.e. the division returns zero instead of some huge value.
%% Output Arguments
% * |rv|: A spectrum modeling the division.
%% Algorithm
% <MultiplySpectra.html MultiplySpectra> is called, with the inverse of |rhs.val| and the near zero division threshold
% properly applied. When the spectra have finite overlap, then the resulting wavelength range is that overlap. When the
% spectra only share a single wavelength, i.e. the only overlap at one point, or when the spectra don't overlap, the
% resulting spectrum has two wavelength values covering the full range, i.e.
% |min(min(lhs.lam),min(rhs.lam)),max(max(lhs.lam),max(rhs.lam))| with |rv.val == [0,0]|.
%% See also
% <AddSpectra.html AddSpectra>, <AddWeightedSpectra.html AddWeightedSpectra>, <IntegrateSpectrum.html
% IntegrateSpectrum>, <MultiplySpectra.html MultiplySpectra>, <ResampleSpectrum.html ResampleSpectrum>
%% Usage Example
% <include>Examples/ExampleDivideSpectra.m</include>

% publish with publishWithStandardExample('filename.m') in PublishDocumentation.m

% JMO Spectrum Library, 2021. See https://github.com/JuliusMuschaweck/JMO_Spectrum
% I dedicate the JMO_Spectrum library to the public domain under Creative Commons Zero 
% (https://creativecommons.org/publicdomain/zero/1.0/legalcode)
%

function rv = DivideSpectra(lhs, rhs, opts)
    arguments
        lhs
        rhs
        opts.tiny (1,1) double = eps;
    end
    tiny = abs(rhs.val) <  opts.tiny * max(abs(rhs.val));
    rhs_ival = 1./rhs.val;
    rhs_ival(tiny) = 0;
    rhs.val = rhs_ival;
    rv = MultiplySpectra(lhs, rhs);
end