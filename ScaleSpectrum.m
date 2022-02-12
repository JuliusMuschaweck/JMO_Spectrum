%% ScaleSpectrum
% 
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp; 
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp; 
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp; 
% <a href="GroupedList.html"> Grouped list</a> &nbsp; | &nbsp;  
% Source code: <a href = "file:../ScaleSpectrum.m"> ScaleSpectrum.m</a>
% </p>
% </html>
%
% Scales a spectrum by multiplying all values with a constant factor. The factor can be set by
% different modes: a simple number, or normalized such that the resulting spectrum will have a certain
% (weighted) integral, or such that the resulting peak will have a certain value
%% Syntax
% |function rv = ScaleSpectrum(rhs, opts)|
%% Input Arguments
% * |rhs|: A valid spectrum (see <SpectrumSanityCheck.html SpectrumSanityCheck>)
% * |opts|: Optional name-value pairs: Name |'mode'| can be |'multiply'| (default), |'normalize_peak'|, 
% |'normalize_radiant_flux'|, |'normalize_luminous_flux'|, or
% |'normalize_integral'|. Name |'value'| must be a real scalar, default is |1.0|. Name |'weight'| must be a valid spectrum.
%% Output Arguments
% * |rv|: Spectrum containing the identical, inherited wavelength array in field |rv.lam|, and
% the scaled inherited values in field |rv.val|
%% Algorithm
% * For mode |'multiply'|, the spectrum values are simply multiplied with the number from the |'value'| parameter.
% * For mode |'normalize_peak'|, the spectrum is scaled such that the resulting peak equals the |'value'| parameter.
% * For mode |'normalize_radiant_flux'|, the spectrum is scaled such that |IntegrateSpectrum(rv)| yields the |'value'| parameter. 
% * For mode |'normalize_luminous_flux'|, the spectrum is scaled such that |683 * IntegrateSpectrum(rv, Vlambda())| 
%      yields the |'value'| parameter. 
% * For mode |'normalize_integral'|, the spectrum is scaled such that |IntegrateSpectrum(rv, weight)| 
%      with |weight| taken from the optional |'weight'| parameter, yields the |'value'|
%      parameter. If no |'weight'| is specified, the result is the same as mode
%      |'normalize_radiant_flux'|
%% See also
% <AddWeightedSpectra.html AddWeightedSpectra>, <IntegrateSpectrum.html IntegrateSpectrum>,
% <MultiplySpectra.html MultiplySpectra>
%% Usage Example
% <include>Examples\ExampleScaleSpectrum.m</include>

% publish with publish('ScaleSpectrum.m','evalCode',true,'showCode',false,'codeToEvaluate','runExample(''ExampleScaleSpectrum'')');

% JMO Spectrum Library, 2021. See https://github.com/JuliusMuschaweck/JMO_Spectrum
% I dedicate the JMO_Spectrum library to the public domain under Creative Commons Zero 
% (https://creativecommons.org/publicdomain/zero/1.0/legalcode)

function rv = ScaleSpectrum(rhs, opts)
    arguments
        rhs (1,1) struct
        opts.mode (1,1) string = "multiply"
        opts.value (1,1) double = 1.0
        opts.weight struct = struct([])
    end
    [~,~,rhs] = SpectrumSanityCheck( rhs );
    if opts.mode == "multiply"
        fac = opts.value;
    elseif opts.mode == "normalize_peak"
        fac = opts.value / max(rhs.val);
    elseif opts.mode == "normalize_radiant_flux"
        fac = opts.value / IntegrateSpectrum(rhs);
    elseif opts.mode == "normalize_luminous_flux"
        fac = opts.value / (683 * IntegrateSpectrum(rhs, Vlambda()));
    elseif opts.mode == "normalize_integral"
        if isempty(opts.weight)
            fac = opts.value / IntegrateSpectrum(rhs);
        else
            [~,~,w] = SpectrumSanityCheck(opts.weight);
            fac = opts.value / IntegrateSpectrum(rhs, w);
        end
    else
        error('ScaleSpectrum: unknown mode %s',opts.mode);
    end
    rv = MakeSpectrumDirect(rhs.lam, rhs.val * fac);
end