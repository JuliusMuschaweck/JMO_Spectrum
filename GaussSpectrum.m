%% GaussSpectrum
% 
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp; 
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp;
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp; 
% <a href="GroupedList.html"> Grouped list</a> &nbsp; | &nbsp; 
% Source code: <a href = "file:../GaussSpectrum.m"> GaussSpectrum.m</a>
% </p>
% </html>
%
% Creates a Gaussian spectrum, normalized to peak = 1.0
%% Syntax
% |rv = GaussSpectrum(lam_vec,mean,sdev,varargin)|
%% Input Arguments
% * |lam_vec|: double vector, positive, strictly ascending. The wavelengths
% * |mean|: scalar double. Mean value around which the spectrum is centered
% * |sdev|: scalar double. Standard deviation of spectrum around |mean|
% * |varargin|: character string. When |'val_only'| returns only the value array, not a spectrum
%% Output Arguments
% * |rv|: |struct|. A valid spectrum
%% Algorithm
% Computes the values as |exp(- (lam_vec-mean).^2 / (2 * sdev^2))|. Note that the actual maximum of the value array may
% be |max(rv.val) < 1|, and is only |max(rv.val) == 1| if |lam_vec| contains |mean| as one of the wavelengths.
%% See also
% <PlanckSpectrum.html PlanckSpectrum>, <CIE_Illuminant.html CIE_Illuminant>, <CIE_Illuminant_D.html CIE_Illuminant_D>
%% Usage Example
% <include>Examples/ExampleGaussSpectrum.m</include>

% publish with publishWithStandardExample('filename.m') in PublishDocumentation.m

% JMO Spectrum Library, 2021. See https://github.com/JuliusMuschaweck/JMO_Spectrum
% I dedicate the JMO_Spectrum library to the public domain under Creative Commons Zero 
% (https://creativecommons.org/publicdomain/zero/1.0/legalcode)
%


function rv = GaussSpectrum(lam_vec,mean,sdev,varargin)
% function rv = GaussSpectrum(lam_vec,mean,sdev,varargin)
% Creates a Gaussian spectrum, normalized to peak = 1.0
% Input: lam_vec: Vector of ascending positive numbers
% mean, sdev are mean and standard deviation 
% optional argument 'val_only'
% Output: rv is spectrum with fields lam, val and name
% 
    oneval = @(lam) exp(- (lam-mean).^2 / (2 * sdev^2));
    rv.val = oneval(lam_vec);
    rv.lam = lam_vec;
    
    if (nargin == 4) && strcmp(  varargin{1}, 'val_only' )
        rv = reshape(rv.val,numel(rv.val),1);
    else 
        [~,~,rv] = SpectrumSanityCheck(rv);
        rv.name = ['Gauss spectrum for mean ',num2str(mean),' nm and sdev ',...
            num2str(sdev),' nm, normalized to peak = 1'];
    end
end