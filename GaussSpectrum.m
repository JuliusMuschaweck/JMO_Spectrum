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