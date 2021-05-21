function ExampleCRI()
% Constructor: 
% loads the CRI reflectivity spectra into the read-only variable CRISpectra_
cri = CRI()
% generate some test spectra
FL4 = CIE_Illuminant('FL4');
D65 = CIE_Illuminant('D65');
Planck6500 = PlanckSpectrum(360:830, 6500);
% and compute their Ra values
fprintf('Ra = %g for %s\n',cri.Ra(FL4), FL4.name);
fprintf('Ra = %g for %s\n',cri.Ra(D65), D65.name);
fprintf('Ra = %g for 6500K Planck\n',cri.Ra(Planck6500));

% now do the same with strictly 5 nm steps
prev = cri.SetStrict_5nm(true);
fprintf('Ra = %g for %s (5 nm steps)\n',cri.Ra(FL4),FL4.name);
fprintf('Ra = %g for %s (5 nm steps)\n',cri.Ra(D65),D65.name);
fprintf('Ra = %g for 6500K Planck (5 nm steps)\n',cri.Ra(Planck6500));
% restore the previous 5 nm setting
cri.SetStrict_5nm(prev); % restore previous state

% compute a special Ri value:
fprintf('R9 = %g for FL4: Really really bad, FL4 fluorescent and saturated red doesn''t match well\n',cri.SingleRi(FL4,9));
fprintf('R9 = %g for D65: perfect by definition\n',cri.SingleRi(D65,9));
fprintf('R9 = %g for 6500K Planck: \n',cri.SingleRi(Planck6500,9));

% do the same for artificial deep red:
my_red_reflectivity = GaussSpectrum(500:800, 650, 30);
fprintf('R  = %g of Planck 6500K for "my red" sample \n',cri.MySingleR(Planck6500, my_red_reflectivity));

% The full information:
full = cri.FullCRI(FL4);
fprintf('Ra = %g for FL4, all Ri = ',full.Ra);
fprintf('%0.1f, ',full.Ri);
fprintf('\n');

% Plot the CRISpectra
cri.PlotCRISpectra();

end