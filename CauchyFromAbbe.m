%% CauchyFromAbbe
% 
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp; 
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp;
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp; 
% <a href="GroupedList.html"> Grouped list</a> &nbsp; | &nbsp; 
% Source code: <a href = "file:../CauchyFromAbbe.m"> CauchyFromAbbe.m</a>
% </p>
% </html>
%
% Computes the first two Cauchy dispersion coefficients from index and Abbe number
%% Syntax
% function rv = CauchyFromAbbe(n, v, opts)
%% Input Arguments
% * |nd|: scalar double. Refractive index at lambda_d = 587.56 nm
% * |vd|: scalar double. Abbe number, (nd-1) / (nF-nC)
% * |opts|: Optional name-value pairs:
%
% <html>
% <p style="margin-left: 25px">
% <table border=1>
% <tr><td> <b>Name</b> </td>      <td><b>Type</b></td>      <td><b>Value</b></td>                <td><b>Default</b></td>   <td><b>Meaning</b></td></tr>
% <tr><td> 'lambda_n_nm' </td>    <td> real or char </td>   <td> real > 0, 'd' , 'D', 'e' </td>  <td>'d'           </td>   <td> reference wavelength for index n in nanometers </td></tr>
% <tr><td> 'lambda_v_nm' </td>    <td> real or char </td>   <td> real > 0, 'd' , 'D', 'e' </td>  <td>'d'           </td>   <td> reference wavelength for Abbe number v in nanometers </td></tr>
% <tr><td> 'Cauchy_wlu' </td>     <td> real </td>           <td> real > 0                 </td>  <td>1e-6          </td>   <td> wavelength unit for Cauchy A1. Default 1e-6 (microns). Use 1e-9 for nanometer </td></tr>
% <tr><td> 'lam' </td>            <td> real vector </td>    <td> valid wavelength array in nm</td>  <td> NaN       </td>   <td> When present, rv contains field nSpectrum: a spectrum which is the Cauchy model evaluated over lam </td></tr>
% </table></p>
% </html>

%% Output Arguments
% |rv| is a struct with fields 
% * |A0| and |A1|: both scalar double, the two Cauchy coefficients. |A0| is dimensionless, |A1| has unit |Cauchy_wlu^2|, which defaults to |µm^2|. 
% * |CauchyFunc|: An anonymous function handle to a function with signature |n = func(lam)|. Evaluates the index as
% function of |lam| in nanometers, relieving the user from worrying about wavelength unit conversion when adhering to
% the "all wavelengths are nanometers" convention.
% * |nSpectrum|: A spectrum, i.e. a struct with fields |lam| and |val|, where |lam| is a copy of the |'lam'| optional
% argument in nanometers, and |val| is the refractive index evaluated over this array.
%% Algorithm
% The Cauchy dispersion model assumes n = A0 + A1/lambda^2 + A2/lambda^4 + ... When only index nD and Abbe number are
% given, only A0 and A1 can be computed. See <docCauchyFromAbbe.html docCauchyFromAbbe> for details.
%% See also
% 
%% Usage Example
% <include>Examples/ExampleCauchyFromAbbe.m</include>

% publish with publishWithStandardExample('filename.m') in PublishDocumentation.m

% JMO Spectrum Library, 2021. See https://github.com/JuliusMuschaweck/JMO_Spectrum
% I dedicate the JMO_Spectrum library to the public domain under Creative Commons Zero 
% (https://creativecommons.org/publicdomain/zero/1.0/legalcode)
%
function rv = CauchyFromAbbe(n, v, opts)
    arguments
        n (1,1) double
        v (1,1) double
        opts.lambda_n_nm (:,1) {mustBeReferenceWavelength} = 'd'
        opts.lambda_v_nm (:,1) {mustBeReferenceWavelength} = 'd'
        opts.Cauchy_wlu (1,1) double = 1e-6
        opts.lam (:,1) double = NaN
    end
% Input: 
%   n: refractive index at lambda_d = 587.6 nm
%   v: Abbe number
% Output:
%   A0, A1: First two Cauchy dispersion coefficients, n = A0 + A1 / lambda^2.
%   A0: dimensionless, A1: micron^2

% solve A0, A1 in microns
    ln = GetReferenceWavelengthInMicrons(opts.lambda_n_nm);
    lv = GetReferenceWavelengthInMicrons(opts.lambda_v_nm);
    lF = 0.486134;
    lC = 0.656281;
    c0 = 1 / ln^2;
    c1 = 1 / lv^2;
    c2 = 1/lF^2 - 1/lC^2;
    c3 = c1 - c2 * v;
    iM = [c3, -c0; -1, 1] / (c3-c0);
    A = iM * [n; 1]; % A == [A0, A1]
    rv.A0 = A(1);
    fac = (1e-6 / opts.Cauchy_wlu)^2; % adjust for different Cauchy_wlu
    rv.A1 = A(2) * fac;
    rv.CauchyFunc = @(ll) A(1) + A(2) ./ ((ll * 0.001).^2);
    if ~isnan(opts.lam(1))
        s.lam = opts.lam; % in nanometers! But A1 in microns^-2
        s.val = rv.CauchyFunc(s.lam);
        s.name = 'CauchyIndex';
        s.description = sprintf('Refractive index according to Cauchy model, with A0 = %g, A1 = %g µm^-2, for material with n = %g at %g nm, and v = %g with reference %g nm', rv.A0, rv.A1, n, ln*1000, v, lv*1000);
        rv.nSpectrum = s;
    end
end

function mustBeReferenceWavelength(a)
    if ~(isnumeric(a) || (ischar(a) && length(a) == 1))
        eidType = 'mustBeReferenceWavelength:notStringOrDouble';
        msgType = 'Input must be a string, ''d'', ''D'' or ''e'', or a positive real number';
        throwAsCaller(MException(eidType,msgType))
    end
    if isnumeric(a) && (a<=0)
        eidType = 'mustBeReferenceWavelength:notPositive';
        msgType = 'Real input must be positive';
        throwAsCaller(MException(eidType,msgType))
    end
    if ischar(a)
        if ~(strcmp(a,'d') || strcmp(a,'D') || strcmp(a,'e'))
            eidType = 'mustBeReferenceWavelength:invalidLine';
            msgType = 'For char input, only ''d'', ''D'' or ''e'' are allowed';
            throwAsCaller(MException(eidType,msgType))
        end
    end
end

function rv = GetReferenceWavelengthInMicrons(a)
    if isnumeric(a)
        rv = 0.001 * a;
    else % must be valid char
        if a(1) == 'd'
            rv = 0.5875618;
        elseif a(1) == 'D'
            rv = 0.58929;
        elseif a(1) == 'e'
            rv = 0.546073;
        else
            error('CauchyFromAbbe: invalid reference wavelength: this cannot happen');
        end
    end
end