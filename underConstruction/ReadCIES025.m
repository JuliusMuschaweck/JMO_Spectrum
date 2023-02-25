% create spectra for all five cone sensitivities from raw data of CIE S026
% S-cone, M-cone, L-cone, rhodopic, melanopic
% lam ranges from 380 to 780 
% but for 380-389 only rhodopic and melanopic are given (no S/M/L)
% and for 616 to 780 no S-cone data
fn = 'CIES026raw.txt';
fh = fopen(fn,'r');

S_cone_opic_sensitivity.lam = 390:615;
M_cone_opic_sensitivity.lam = 390:780;
L_cone_opic_sensitivity.lam = 390:780;
rhodopic_sensitivity.lam = 380:780;
melanopic_sensitivity.lam = 380:780;
S_cone_opic_sensitivity.val = [];
M_cone_opic_sensitivity.val = [];
L_cone_opic_sensitivity.val = [];
rhodopic_sensitivity.val = [];
melanopic_sensitivity.val = [];
S_cone_opic_sensitivity.name = 'S-cone sensitivity according to CIE S 026/E:2018';
M_cone_opic_sensitivity.name = 'M-cone sensitivity according to CIE S 026/E:2018';
L_cone_opic_sensitivity.name = 'L-cone sensitivity according to CIE S 026/E:2018';
rhodopic_sensitivity.name = 'rhodopic sensitivity according to CIE S 026/E:2018';
melanopic_sensitivity.name = 'melanopic sensitivity according to CIE S 026/E:2018';


for ilam = 380:389
    itest = oneLine(fh);
    if itest ~= ilam
        error('wrong lam %g ~= %g',itest, ilam);
    end
%     S_cone_opic_sensitivity.val(end+1) = oneLine(fh);
%     M_cone_opic_sensitivity.val(end+1) = oneLine(fh);
%     L_cone_opic_sensitivity.val(end+1) = oneLine(fh);
    rhodopic_sensitivity.val(end+1) = oneLine(fh);
    melanopic_sensitivity.val(end+1) = oneLine(fh);
end
for ilam = 390:615
    itest = oneLine(fh);
    if itest ~= ilam
        error('wrong lam %g ~= %g',itest, ilam);
    end
    S_cone_opic_sensitivity.val(end+1) = oneLine(fh);
    M_cone_opic_sensitivity.val(end+1) = oneLine(fh);
    L_cone_opic_sensitivity.val(end+1) = oneLine(fh);
    rhodopic_sensitivity.val(end+1) = oneLine(fh);
    melanopic_sensitivity.val(end+1) = oneLine(fh);
end
for ilam = 616:780
    itest = oneLine(fh);
    if itest ~= ilam
        error('wrong lam %g ~= %g',itest, ilam);
    end
%    S_cone_opic_sensitivity.val(end+1) = oneLine(fh);
    M_cone_opic_sensitivity.val(end+1) = oneLine(fh);
    L_cone_opic_sensitivity.val(end+1) = oneLine(fh);
    rhodopic_sensitivity.val(end+1) = oneLine(fh);
    melanopic_sensitivity.val(end+1) = oneLine(fh);
end


fclose(fh);
%%
figure(1);
clf;
hold on;
PlotSpectrum(S_cone_opic_sensitivity,'b');
PlotSpectrum(M_cone_opic_sensitivity,'g');
PlotSpectrum(L_cone_opic_sensitivity,'r');
PlotSpectrum(rhodopic_sensitivity,'k');
PlotSpectrum(melanopic_sensitivity,'m');
legend({'S_cone_opic','M_cone_opic',...
    'L_cone_opic','rhodopic','melanopic'},'Interpreter','none');
xlabel('\lambda (nm)');
title('human eye cone sensitivities (CIE S 026)');
%%
CIES026.S_cone_opic_sensitivity = S_cone_opic_sensitivity;
CIES026.M_cone_opic_sensitivity = M_cone_opic_sensitivity;
CIES026.L_cone_opic_sensitivity = L_cone_opic_sensitivity;
CIES026.rhodopic_sensitivity = rhodopic_sensitivity;
CIES026.melanopic_sensitivity = melanopic_sensitivity;

save('CIES026_lam_S_M_L_r_m.mat','CIES026');

function rv = oneLine(fh)
    tmp = fgetl(fh);
    rv = str2double(tmp);
%    fprintf('"%s" -> %g\n',tmp,rv);
end

