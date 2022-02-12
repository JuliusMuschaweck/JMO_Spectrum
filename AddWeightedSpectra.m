%% AddWeightedSpectra
% 
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp; 
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp; 
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp; 
% <a href="GroupedList.html"> Grouped list</a> &nbsp; | &nbsp; 
% Source code: <a href = "file:../AddWeightedSpectra.m"> AddWeightedSpectra.m</a>
% </p>
% </html>
%
% Adds several spectra with weights, properly interweaving the wavelengths
%% Syntax
% |function rv = AddWeightedSpectra(spectra,weights)|
%% Input Arguments
% * |spectra|: scalar, 1-D vector or 1-D cell array of valid spectra (see <SpectrumSanityCheck.html SpectrumSanityCheck>)
% * |weights|: scalar or 1-D vector of double
%% Output Arguments
% * |rv|: Spectrum containing the merged wavelengths in field |rv.lam|, and the weighted sum of all input spectra in field |rv.val|
%% Algorithm
% Computes the weighted sum of all spectra. When spectra do not overlap, the wavelength ranges are concatenated, 
% and the range in between is padded with zero. If they do overlap, then |rv.lam| contains all values from all input spectra, 
% with duplicate values removed, and what is added are the weighted sum of linearly interpolated values from all input spectra. Thus, the sum spectrum is a 
% perfect model of the underlying continuous function which is the weighted sum of the continuous, linearly interpolated input spectra.
%% See also
% <AddSpectra.html AddSpectra>, <MultiplySpectra.html MultiplySpectra>, <ScaleSpectrum.html ScaleSpectrum>
%% Usage Example
% <include>Examples/ExampleAddWeightedSpectra.m</include>

% publish with publish('AddWeightedSpectra.m','evalCode',true,'showCode',false,'codeToEvaluate','ExampleAddWeightedSpectra();');

% JMO Spectrum Library, 2021. See https://github.com/JuliusMuschaweck/JMO_Spectrum
% I dedicate the JMO_Spectrum library to the public domain under Creative Commons Zero 
% (https://creativecommons.org/publicdomain/zero/1.0/legalcode)

function rv = AddWeightedSpectra(spectra,weights)
% function rv = AddWeightedSpectra(spectra,weights)
% vectors of spectra and scalar weights
    if ~isvector(spectra)
        error('AddWeightedSpectra: spectra must be size [1 n] or [n 1]');
    end
    if ~isvector(weights)
        error('AddWeightedSpectra: weights must be size [1 n] or [n 1]');
    end
    if ~isreal(weights)
        error('AddWeightedSpectra: weights must be real array');
    end
    nS = length(weights);
    if length(spectra) ~= nS
        error('AddWeightedSpectra: weights and spectra must be same length');
    end
    function rv = NoCell(s)
        if iscell(s)
            rv = s{1};
        else
            rv = s;
        end
    end
    [~,~,rv] = SpectrumSanityCheck(NoCell(spectra(1)),'doStrip',true);
    rv.val = rv.val * weights(1);
    for i = 2:nS
        [~,~,si] = SpectrumSanityCheck(NoCell(spectra(i)),'doStrip',true);
        si.val = si.val * weights(i);
        if isequal(rv.lam, si.lam)
            % same lam, just add val
            rv.val = rv.val + si.val;
            continue;
        end
        if (rv.lam(end) < si.lam(1) || rv.lam(1) > si.lam(end))
            % no overlap, concatenate, but val = 0 between spectra
            if rv.lam(end) < si.lam(1)
                slo = rv;
                shi = si;
            else
                slo = si;
                shi = rv;
            end
            dl = (shi.lam(1) - slo.lam(end)) * 1e-6;
            lam0 = slo.lam(end) + dl;
            lam1 = shi.lam(1) - dl;
            % check for very small non overlap
            if slo.lam(end) < lam0 && lam0 < lam1 && lam1 < shi.lam(1)
                rv.lam = cat(1,slo.lam, lam0, lam1, shi.lam);
                rv.val = cat(1,slo.val, 0, 0, shi.val);
            else % gap smaller than roundoff error
                rv.lam = cat(1,slo.lam, shi.lam);
                rv.val = cat(1,slo.val, shi.val);
            end
            continue;
        end % no overlap
        % treat overlapping, unequal lambdas
        tmplam = unique(sort(cat(1,rv.lam,si.lam)));
        vl = LinInterpol(rv.lam,rv.val,tmplam);
        vr = LinInterpol(si.lam,si.val,tmplam);
        rv.lam = tmplam;
        rv.val = vl + vr;
    end
end

function Test()
%%
    clear sp;
    clear spc;
    sp(1) = MakeSpectrum([400 410 420], [1,2,3]);
    spc{1} = sp(1);
    sp(2) = MakeSpectrum([400 410 420], [3,2,1]);
    spc{2} = sp(2);
    test1 = AddWeightedSpectra(sp,[1,2]);
    test1c = AddWeightedSpectra(spc,[1,2]);

%%    
    sp(3) = MakeSpectrum([420+1e-12, 430 440], [4,4,4]);
    test1 = AddWeightedSpectra(sp,[1,2,3]);

%%
    sp(4) = MakeSpectrum([450 460 470], [4,4,4]);
    test1 = AddWeightedSpectra(sp,[1,2,3,4]);
    
%%
    sp(5) = MakeSpectrum([350 360 370], [4,4,4]);
    test1 = AddWeightedSpectra(sp,[1,2,3,4,5]);

%%
    sp(6) = MakeSpectrum([350 360 470], [100 100 100]);
    test1 = AddWeightedSpectra(sp,[1,2,3,4,5,100]);
    
end