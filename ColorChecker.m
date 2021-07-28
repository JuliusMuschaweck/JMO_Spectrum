%% ColorChecker
% 
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp; 
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp;
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp; 
% <a href="GroupedList.html"> Grouped list</a>  &nbsp; | &nbsp; 
% Source code: <a href = "file:../ColorChecker.m"> ColorChecker.m</a>
% </p>
% </html>
%
% return selected MacBeth ColorChecker reflectivity spectra
%% Syntax
% |rv = ColorChecker(i)|
%% Input Arguments
% * |i|: scalar or vector double. The index (or index list) of the desired spectra.
%% Output Arguments
% * |rv|: When |i| is scalar: A struct with fields  |name| (the name), |lam| (the wavelength array, 380:5:760), and
% |val| (the corresponding reflectivity values). When |i| is a vector of length > 1, then rv is a cell array of such
% spectrum structs. |i| need not be sorted, and need not be unique.
%% Algorithm
% On first call, reads the spectra from |ColorChecker.mat| and stores them in a persistent variable. Data source: EBU Tech 3355, appendix 4. Subsequent calls
% will not re-read the .mat file and be much faster. ColorChecker spectra are widely used in the movie industry, and
% serve as the basis for the TLCI (Television Lighting Consistency Index).
%% See also
% <CRI.html CRI>
%% Usage Example
% <include>Examples/ExampleColorChecker.m</include>

% publish with publishWithStandardExample('filename.m') in PublishDocumentation.m

% JMO Spectrum Library, 2021. See https://github.com/JuliusMuschaweck/JMO_Spectrum
% I dedicate the JMO_Spectrum library to the public domain under Creative Commons Zero 
% (https://creativecommons.org/publicdomain/zero/1.0/legalcode)
%

function rv = ColorChecker(i)
    %ColorChecker return i'th sample, i in [1,24]
    % i may be array, then return cell array of spectra
    persistent iColorCheckerSpectra;
    if isempty(iColorCheckerSpectra)
        load('ColorCheckerSpectra.mat', 'ColorCheckerSpectra');
        iColorCheckerSpectra = ColorCheckerSpectra;
    end
    if isscalar(i)
        rv = iColorCheckerSpectra{i};
    else
        rv = iColorCheckerSpectra(i);
    end
end

