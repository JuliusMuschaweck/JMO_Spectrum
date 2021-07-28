%% PlanckSpectrum
% 
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp; 
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp; 
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp; 
% <a href="GroupedList.html"> Grouped list</a> &nbsp; | &nbsp; 
% Source code: <a href = "file:../PlanckSpectrum.m"> PlanckSpectrum.m</a>
% </p>
% </html>
%
% Computes Planck's blackbody spectrum as function of temperature and wavelength
%% Syntax
% |function rv = PlanckSpectrum(lam_vec, T, opts)|
%% Input Arguments
% * |lam_vec|: vector of double, positive, strictly ascending. Wavelengths of the resulting spectrum
% * |T|: scalar positive double. The absolute temperature in Kelvin. May be |Inf|, then, with |'normalize'| to
% |'localpeak1'| returns the high temperate asymptotic shape.
% * |opts|: Name-value pairs:
%
% <html>
% <p style="margin-left: 25px">
% <table border=1><tr><td><b>Name</b></td><td><b>Type</b></td><td><b>Value</b></td><td><b>Meaning</b></td></tr>
% <tr><td> 'normalize' </td><td>string</td> <td> 'globalpeak1' (default) </td> <td> scaled such that global peak would be 1.0 even if
%           outside lambda range. Only for constant index </td></tr>
% <tr><td>             </td><td></td><td> 'localpeak1' </td> <td> scaled such that the peak value for the given lam_vec is
%           1.0, Note: Not exactly identical if global peak is in range, due to
%           discretization </td></tr>
% <tr><td>  </td><td></td><td> 'localflux1' </td> <td> scaled such that integral over given lambda range is 1.0 </td></tr>
% <tr><td>  </td><td></td><td> 'radiance' </td> <td> scaled such rv is blackbody spectral radiance, W/(wlu m²sr), where wlu is the length unit (usually nm) </td></tr>
% <tr><td>  </td><td></td><td> 'basic_radiance' </td> <td> scaled such rv is blackbody spectral basic radiance, W/(wlu m²sr) </td></tr>
% <tr><td>  </td><td></td><td> 'exitance' </td> <td> scaled such that rv is blackbody spectral exitance, W/(wlu m²) </td></tr>
% <tr><td> 'wavelengthUnit' </td><td>positive real scalar</td><td> 1e-9 (default) </td> <td> lam_vec given in nm, returned spectrum is W / (nm m² sr) or W / (nm m²)
    %               rv.XYZ will be CIE XYZ values X, Y, Z, x, y </td></tr>
% <tr><td>  </td><td></td><td> 1e-6 </td> <td> lam_vec given in µm, returned spectrum is W / (µm m² sr) or W / (µm m²) </td></tr>
% <tr><td>  </td><td></td><td> 1 </td> <td> lam_vec given in m, returned spectrum is W / (m m² sr) or W / (m m²) </td></tr>
% <tr><td> 'n_refr_const' </td><td> positive real scalar </td><td> 1.000277 (default) </td> <td> standard air </td></tr>
% <tr><td> </td><td> </td><td> 1.0 </td> <td> vacuum </td></tr>
% <tr><td> </td><td> </td><td> any other value </td> <td> some constant index medium </td></tr>
% <tr><td> 'n_refr_table' </td><td>A valid spectrum, i.e. struct with appropriate fields lam and val </td><td> </td> <td> </td></tr>
% <tr><td> 'n_refr_func' </td><td> function handle with signature: [n, dn_dlambda] = n_refr_func(lambda) </td><td> @(lambda) NaN; (default)</td> <td> Not used </td></tr>
% <tr><td> </td><td></td><td> any other function </td> <td> Dispersion of the embedding medium. Takes precedence over 'n_refr_table' and 'n_refr_const' 
% NOTE: For dispersive index as function of wavelength, the wavelength is interpreted as wavelength
    %   within the medium (!!). For gases like air or argon, with pressure near atmospheric, the
    %   difference is negligible. For the (academic) case of blackbody radiation in an optically dense
    %   medium, where the dispersion curve is given as function of wavelength in vacuum or air, that
    %   function needs to be converted to a function of wavelength in medium before passing it as a
    %   parameter.
% </td></tr>
% <tr><td> 'doTest' </td><td> logical scalar </td><td> false (default) </td> <td> Ignore </td></tr>
% <tr><td>  </td><td> </td><td> true </td> <td> Perform diagnostic test ignoring input values, then return. See code for details </td></tr>
% </table></p>
% </html>
%
%% Output Arguments
% * |rv|: A spectrum, i.e. struct with fields |lam| (copy of |lam_vec|) and |val|, the Planck spectrum.
%% Algorithm
% Takes the constants for b, h, c and k from <CODATA2018.html CODATA2018>, and computes the blackbody parameters c1L and
% c2 from these. Using b, c1L and c2, computes the blackbody basic spectral radiance, which is then normalized according
% to the |'normalize'| option. For the intricacies of computing blackbody spectra in anything else but vacuum,
% especially in dispersive media (like air, if you want to be precise), see <BlackbodySpectrumWithRefractiveIndex.html
% BlackbodySpectrumWithRefractiveIndex>
%% See also
% <CIE_Illuminant.html CIE_Illuminant>, <CIE_Illuminant_D.html CIE_Illuminant_D>
%% Usage Example
% <include>Examples/ExamplePlanckSpectrum.m</include>

% publish with publishWithStandardExample('filename.m') in PublishDocumentation.m

% JMO Spectrum Library, 2021. See https://github.com/JuliusMuschaweck/JMO_Spectrum
% I dedicate the JMO_Spectrum library to the public domain under Creative Commons Zero 
% (https://creativecommons.org/publicdomain/zero/1.0/legalcode)
%




function rv = PlanckSpectrum(lam_vec, T, varargin)
    
    % preliminaries
    if nargin == 0
       TestPlanckSpectrum();
       rv = [];
       return;
    end

    
    p = inputParser;
    addRequired(p,'lam_vec',@(x) isreal(x) && isvector(x));
    addRequired(p,'T',@(x) isreal(x) && isscalar(x) && x>0);
    addParameter(p,'normalize','globalpeak1',@normalize_validate);
    addParameter(p,'wavelengthUnit', 1e-9, @(x) isreal(x) && isscalar(x) && x>0);
    addParameter(p,'n_refr_const', 1.000277, @(x) isreal(x) && isscalar(x) && x>0);
    addParameter(p,'n_refr_func', @(lambda) NaN, @(fh) isa(fh,'function_handle'));
    addParameter(p,'n_refr_table', struct('lam',NaN,'val',NaN), @(s) IsSpectrum(s));
    addParameter(p,'doTest', false, @islogical);
    parse(p,lam_vec,T,varargin{:});
    
    nFunc = ~isnan(p.Results.n_refr_func(lam_vec(1)));
    nTable = ~isnan(p.Results.n_refr_table.lam(1));
    
    isdispersive =  nFunc || nTable;
    
    if p.Results.doTest
        TestPlanckSpectrum();
        return;
    end
    
    normalize = p.Results.normalize;
    wlu = p.Results.wavelengthUnit;
    
    CODATA = CODATA2018();
    b = CODATA.b.value; % Wien's displacement law constant
    %c1L = CODATA.c1L.value; % first radiation constant = 2 h c^2
    %c2 = CODATA.c2.value; % second radiation constant = h c / k
 
    %taking these physical values reduces the rel. radiance error to 5e-11
    c1L = 2 * CODATA.h.value * (CODATA.c.value)^2;
    c2 = CODATA.h.value * CODATA.c.value / CODATA.k.value;
    % compute basic spectral radiance
    rv.lam = lam_vec(:);
    if isdispersive
        if nFunc % evaluate dispersion function which must include derivative vs lambda
            [nn, dndlam] = arrayfun(p.Results.n_refr_func, rv.lam);
        elseif nTable % create spline from dispersion function
            npp = spline(p.Results.n_refr_table.lam, p.Results.n_refr_table.val);
            dnpp = ipp_deriv(npp); % analytic derivative of piecewise polynomial
            nn = ppval(npp, rv.lam);
            dndlam = ppval(dnpp, rv.lam);
        else
            error('PlanckSpectrum: dispersive but no func or table, this cannot happen');
        end
        L_lam_basic = L_array_index();
    else % constant refractive index
        nn = p.Results.n_refr_const;
        L_lam_basic = L_const_index(nn);
    end
    
    if isdispersive
        mediumDescription = 'medium with dispersive index';
    else
        mediumDescription = sprintf('medium with refractive index = %g',nn);
    end
        
    
    % normalize
    if strcmp(normalize,'globalpeak1')
    %       'globalpeak1': scaled such that global peak would be 1.0 even if
    %           outside lambda range
        if isdispersive
            error('PlanckSpectrum: globalpeak1 normalization not compatible with dispersive medium');
        end
        lpeak_m = b / (nn * T);
        Bpeak = nn * wlu * c1L * (lpeak_m ^(-5)) / expm1(c2/(lpeak_m*T));
        rv.val = L_lam_basic / Bpeak;
        rv.name = sprintf('Planck blackbody spectrum for T = %g K in %s, normalized to global peak = 1', T, mediumDescription);
    elseif strcmp(normalize,'localpeak1')
    %       'localpeak1': scaled such that the peak value of any lam_vec is
    %           1.0, Note: Not exactly identical if global peak is in range, due to
    %           discretization
        rv.val = L_lam_basic / max(L_lam_basic);
        rv.name = sprintf('Planck blackbody spectrum for T = %g K in %s, normalized to peak = 1 within wavelength range', T, mediumDescription);
    elseif strcmp(normalize,'localflux1')
    %       'localflux1: scaled such that integral over lambda range is 1.0
        flux = trapz(rv.lam,L_lam_basic);
        rv.val = L_lam_basic / flux;
        rv.name = sprintf('Planck blackbody spectrum for T = %g K in %s, normalized to flux = 1 within wavelength range', T, mediumDescription);
    elseif strcmp(normalize,'radiance')
    %       'radiance': scaled such rv is blackbody spectral radiance, W/(wlu m²sr)
        if isdispersive
            rv.val = L_lam_basic .* (nn.^2);
        else
            rv.val = L_lam_basic * (nn^2);
        end
        rv.name = sprintf('Planck blackbody spectral radiance for T = %g K in %s, in W / (%s m^2 sr)', T, mediumDescription, wluName(wlu));
    elseif strcmp(normalize,'basic_radiance')
    %       'basic_radiance': scaled such rv is blackbody spectral basic radiance, W/(wlu m²sr)
        rv.val = L_lam_basic;
        rv.name = sprintf('Planck blackbody spectral basic radiance for T = %g K in %s, in W / (%s m^2 sr)', T, mediumDescription, wluName(wlu));
    elseif strcmp(normalize,'exitance')
    %       'exitance': scaled such that rv is blackbody spectral exitance, W/(wlu m²)
        % integrate basic spectral radiance over dk_x, dk_y = dOmega * cos(theta) * n^2 for full
        % hemisphere, i.e. multiply basic spectral radiance by n^2 pi
        if isdispersive
            rv.val = L_lam_basic .* (nn.^2) * pi;
        else
            rv.val = L_lam_basic * (nn^2) * pi;
        end
        rv.name = sprintf('Planck blackbody spectral radiant exitance for T = %g K in %s, in W / (%s m^2)', T, mediumDescription, wluName(wlu));
    else
        error('PlanckSpectrum: illegal normalize mode: this cannot happen');
    end
    
    if wlu == 1e-9
        rv.XYZ = CIE1931_XYZ(rv);
    end
    
    function Lbvac = L_vacuum_m(lam_vac_m)
        denom = (lam_vac_m.^5) .* expm1((c2/T) ./ lam_vac_m);
        Lbvac = c1L ./ denom;
    end
    
    function Lb = L_const_index(n)
        if T > 1e100
            Lb = (rv.lam).^(-4);
            Lb = Lb / max(Lb);
            return;
        end
        lam_vac_m = rv.lam * nn * wlu;
        Lbvac = L_vacuum_m(lam_vac_m);
        Lb = (n * wlu) * Lbvac;
    end
    
    function Lb = L_array_index()
        if T > 1e100
            Lb = (rv.lam).^(-4) * (nn + (rv.lam).*dndlam);
            Lb = Lb / max(Lb);
            return;
        end
        lam_vac_m = wlu * (rv.lam .* nn);
        Lbvac = L_vacuum_m(lam_vac_m);
        Lb = wlu * (nn + rv.lam .* dndlam) .* Lbvac;
    end
    
end

function rv = normalize_validate(s)
    rv = ischar(s);
    if ~rv
        return;
    end
    ok = sum(strcmp(s,{'globalpeak1','localpeak1','localflux1','radiance','basic_radiance','exitance'})) > 0;
    rv = rv && ok;
end

function rv = wluName(wlu)
    if wlu == 1
        rv = 'm';
    elseif wlu == 1e-6
        rv = 'micron';
    elseif wlu  == 1e-9
        rv = 'nm';
    else
        rv = [num2str(wlu),'m'];
    end
end

%%
function TestPlanckSpectrum()
    % Input: lam_vec vector of reals, T scalar real in K.
    %   T may be inf, then returns lam_vec^(-4), scaled to 'localpeak1'
    %   Options:
    %   'normalize' -> string, default 'globalpeak1'
    %       'globalpeak1': scaled such that global peak would be 1.0 even if
    %           outside lambda range. Only for constant index
    %       'localpeak1': scaled such that the peak value of any lam_vec is
    %           1.0, Note: Not exactly identical if global peak is in range, due to
    %           discretization
    %       'localflux1: scaled such that integral over lambda range is 1.0
    %       'radiance': scaled such rv is blackbody spectral radiance, W/(wlu m²sr)
    %       'basic_radiance': scaled such rv is blackbody spectral basic radiance, W/(wlu m²sr)
    %       'exitance': scaled such that rv is blackbody spectral exitance, W/(wlu m²)
    %           wlu is wavelengthUnit, see below
    %   'wavelengthUnit' -> positive real scalar, default 1e-9 (nanometers)
    %       1e-9 : lam_vec given in nm, returned spectrum is W / (nm m² sr) or W / (nm m²)
    %               rv.XYZ will be CIE XYZ values X, Y, Z, x, y
    %       1e-6: lam_vec given in µm, returned spectrum is W / (µm m² sr) or W / (µm m²)
    %       1  : lam_vec given in m, returned spectrum is W / (m m² sr) or W / (m m²)
    %   'n_refr_const' -> positive real scalar, default 1.000277
    %   'n_refr_func' -> function handle to dispersion function n(lambda), default not used (returning NaN)
    %               signature: [n, dn_dlambda] = n_refr_func(lambda):
    %   'n_refr_table' -> n is a valid spectrum, i.e. struct with appropriate fields lam and val
    %   'n_refr_func' has precedence over 'n_refr_table', which has precedence over 'n_refr_const'
    CODATA = CODATA2018();
    lam1vac = 70:0.005:2000; % wavelengths in vacuum in nm
    lam2vac = (linspace(2000^0.25,1e7^0.25,1000000)).^4;
    T = 5600;
    k = CODATA.k.value;
    h = CODATA.h.value;
    c = CODATA.c.value;
    sigma = 2 * pi^5 * k^4 / (15 * h^3 * c^2);
    figure(1);
    clf;
    hold on;
    grid on;
    figure(2);
    clf;
    hold on;
    grid on;
    title('log-log plot of radiances');
    figure(3);
    clf;
    hold on;
    grid on;
    title('refractive indices');
    % test vacuum for 5600 K
    n = 1.0;
    color = 'r';
    lam1 = lam1vac/n;
    lam2 = lam2vac/n;
    ps1 = PlanckSpectrum(lam1,T,'normalize','basic_radiance','n_refr_const',n);
    ps2 = PlanckSpectrum(lam2,T,'normalize','basic_radiance','n_refr_const',n);
    figure(2);
    plot(log10(ps1.lam),log10(ps1.val),color);
    plot(log10(ps2.lam),log10(ps2.val),color);
    radiance_num = trapz(ps1.lam,ps1.val) + trapz(ps2.lam,ps2.val);
    radiance_phys = sigma * T^4 / pi;
    testzero = radiance_num/radiance_phys - 1;
    fprintf('vacuum blackbody radiance for T = %g: L = %g, should be %g. Rel. error = %g\n',T,radiance_num, radiance_phys, testzero);
    psplot = PlanckSpectrum(200:1500,T,'normalize','basic_radiance','n_refr_const',n);
    figure(1);
    plot(psplot.lam,psplot.val,color);
    xlabel('\lambda (nm) in medium');
    ylabel('spectral basic radiance');
    legends{1} = sprintf('n = %g',n);
    figure(3);
    plot(lam1([1,end]),[n n],color);
    
    % test for constant refractive index 1.5
    n = 1.5;
    color = 'b';    
    lam1 = lam1vac/n;
    lam2 = lam2vac/n;
    ps1 = PlanckSpectrum(lam1,T,'normalize','basic_radiance','n_refr_const',n);
    ps2 = PlanckSpectrum(lam2,T,'normalize','basic_radiance','n_refr_const',n);
    figure(2);
    plot(log10(ps1.lam),log10(ps1.val),color);
    plot(log10(ps2.lam),log10(ps2.val),color);
    radiance_num = trapz(ps1.lam,ps1.val) + trapz(ps2.lam,ps2.val);
    radiance_phys = sigma * T^4 / pi;
    testzero = radiance_num/radiance_phys - 1;
    fprintf('blackbody basic radiance for T = %g and n = %g: L = %g, should be %g. Rel. error = %g\n',T,n,radiance_num, radiance_phys, testzero);
    psplot = PlanckSpectrum(200:1500,T,'normalize','basic_radiance','n_refr_const',n);
    figure(1);
    plot(psplot.lam,psplot.val,color);
    legends{2} = sprintf('n = %g',n);
    figure(3);
    plot(lam1([1,end]),[n n],color);
    
    % test for dispersive refractive index function
    lam1 = lam1vac/1.0;
    lam2 = lam2vac/1.0;
    color = 'g';
    ps1 = PlanckSpectrum(lam1,T,'normalize','basic_radiance','n_refr_func',@dispersive_n);
    ps2 = PlanckSpectrum(lam2,T,'normalize','basic_radiance','n_refr_func',@dispersive_n);
    figure(2);
    plot(log10(ps1.lam),log10(ps1.val),color);
    plot(log10(ps2.lam),log10(ps2.val),color);
    radiance_num = trapz(ps1.lam,ps1.val) + trapz(ps2.lam,ps2.val);
    radiance_phys = sigma * T^4 / pi;
    testzero = radiance_num/radiance_phys - 1;
    fprintf('blackbody basic radiance for T = %g and dispersive n function: L = %g, should be %g. Rel. error = %g\n',T,radiance_num, radiance_phys, testzero);
    psplot = PlanckSpectrum(200:2000,T,'normalize','basic_radiance','n_refr_func',@dispersive_n);
    figure(1);
    plot(psplot.lam,psplot.val,color);
    legends{3} = sprintf('n dispersive function');
    legend(legends);
    title(sprintf('Spectral basic radiance for T = %g K',T));
    figure(3);
    plot(lam1,dispersive_n(lam1),color);
    
    % test for dispersive refractive index table
    clear n;
    lam1 = lam1vac/2;
    lam2 = lam2vac/2;
    color = 'm';
    n.lam = [35, 400, 800, 900, 1000];
    n.val = [2, 1.7, 1.6,1.55,1.5];
    ps1 = PlanckSpectrum(lam1,T,'normalize','basic_radiance','n_refr_table',n);
    ps2 = PlanckSpectrum(lam2,T,'normalize','basic_radiance','n_refr_const',1.5);
    figure(2);
    plot(log10(ps1.lam),log10(ps1.val),color);
    plot(log10(ps2.lam),log10(ps2.val),color);
    radiance_num = trapz(ps1.lam,ps1.val) + trapz(ps2.lam,ps2.val);
    radiance_phys = sigma * T^4 / pi;
    testzero = radiance_num/radiance_phys - 1;
    fprintf('blackbody basic radiance for T = %g and dispersive n table: L = %g, should be %g. Rel. error = %g\n',T,radiance_num, radiance_phys, testzero);
    psplot = PlanckSpectrum(200:1000,T,'normalize','basic_radiance','n_refr_table',n);
    figure(1);
    plot(psplot.lam,psplot.val,color);
    legends{4} = sprintf('n dispersive table');
    legend(legends);
    title(sprintf('Spectral basic radiance for T = %g K',T));
    figure(3);
    plot(lam1,spline(n.lam,n.val,lam1),color);

    % test global peak 1 within wavelength range and outside
    figure(4);
    clf;
    hold on;
    title('Testing global and local peak 1');
    p1 = PlanckSpectrum(200:2000, 5600,'normalize','globalpeak1');
    p2 = PlanckSpectrum(800:2000, 5600,'normalize','globalpeak1');
    p3 = PlanckSpectrum(800:2000, 5600,'normalize','localpeak1');
    plot(p1.lam,p1.val);
    plot(p2.lam,p2.val,'LineWidth',2);
    plot(p3.lam,p3.val);

    %       'localflux1: scaled such that integral over lambda range is 1.0
    p = PlanckSpectrum(200:2000, 5600,'normalize','localflux1');
    test1 = trapz(p.lam,p.val);
    fprintf('normalize localflux1: test = %g, test - 1 = %g\n',test1, test1-1);

    % test wlu
    pnm = PlanckSpectrum(200:2000, 5600,'normalize','basic_radiance');
    pmm = PlanckSpectrum((200:2000) * 1e-6, 5600,'normalize','basic_radiance','wavelengthUnit',1e-3);
    Phinm = trapz(pnm.lam,pnm.val);
    Phimm = trapz(pmm.lam,pmm.val);
    fprintf('wavelength unit: flux for nm = %g, flux for mm = %g, difference = %g\n',Phinm, Phimm,Phinm - Phimm);

    
    function [n, dndl] = dispersive_n(lambda)
        n = 2 - exp(-lambda/1000);
        dndl =  exp(-lambda/1000) / 1000;
    end
    
end
