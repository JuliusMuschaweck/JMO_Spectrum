clear;
% reading a 4000K white LED spectrum, exported from the very recommendable OSRAM Color calculator
% available at https://www.researchgate.net/publication/320930275_ColorCalculator_software
spec = ReadASCIITableSpectrumFile('OSRAM_ColorCalc_LED4000K.txt');
[myCCT,myduv] = CCT(spec);
fprintf("White LED, CCT = %.0f K, uv distance to Planck: %.3f\n", myCCT, myduv);
% plotting the spectrum -- looks like a regular white LED
figure(1); clf;
PlotSpectrum(spec); title("A white LED spectrum");
 
% initialize the IES_TM30 class instance
tm30 = IES_TM30;
% tell it which spectrum we want to analyze
tm30.SetSpectrum(spec);
% compute the fidelity indices...
[Rf,Rfi, Rf_hj] = tm30.FidelityIndex();
% ... and the gamut index
Rg = tm30.GamutIndex();
figure(2);
clf;
bar(Rfi);

%% Creating the full TM30 report via LaTeX 
% Requires that pdflatex.exe is on the system path
tm30.CreateFullReport_LaTeX(...
    Source = "some 4000K LED",...
    Manufacturer = "unknown manufacturer",...
    Model = "unknown model",...
    Notes = "results from TM30 test run",...
    ReportFileName = 'someTM30Test_LaTeX.pdf');

%% full report via Matlab App
%% Creating the full TM30 report via LaTeX 
% Requires that pdflatex.exe is on the system path
tm30.CreateFullReport_MLApp(...
    Source = "some 4000K LED",...
    Manufacturer = "unknown manufacturer",...
    Model = "unknown model",...
    Notes = "results from TM30 test run",...
    ReportFileName = 'someTM30Test_MLApp.pdf');

%%
cvg = tm30.ColorVectorGraphic(Disclaimer=true,DisclaimerTime=true);
% exportgraphics(cvg.ax,'ColorVectorGraphics.eps','ContentType','vector');
% exportgraphics(cvg.ax,'ColorVectorGraphics.png');

%%
Rch = tm30.LocalChromaHueShiftFidelityGraphics(xLabels=[false, false, true],...
    relBarWidth=0.9*[1,1,1], mValues=[true,false,false]);
%exportgraphics(Rch.axc,'ChromaShiftGraphics.eps','ContentType','vector');
%exportgraphics(Rch.axh,'HueShiftGraphics.eps','ContentType','vector');
%exportgraphics(Rch.axf,'FidelityGraphics.eps','ContentType','vector');
exportgraphics(Rch.axc,'ChromaShiftGraphics.png');
exportgraphics(Rch.axh,'HueShiftGraphics.png');
exportgraphics(Rch.axf,'FidelityGraphics.png');
%%
ivg = tm30.IndividualFidelityGraphics();
% exportgraphics(ivg.ax,'IndividualFidelityGraphics.eps','ContentType','vector');
exportgraphics(ivg.ax,'IndividualFidelityGraphics.png');
%%
spg = tm30.SpectrumGraphics(RelativeScale="peak");
%exportgraphics(spg.ax,'SpectrumGraphics.eps','ContentType','vector');
exportgraphics(spg.ax,'SpectrumGraphics.png');
%% Matlab figure
% Tried to create TM30 report as a Matlab figure, but could not really make it work

gridheight = 38;
gridwidth = 2;
fh = figure(10);
clf; hold on;
fh.Position(3:4) = [975,1354];

info.source = 'Example source';
info.date = datetime('now','Format','yyyy-MM-dd');
info.manufacturer = 'Example mft';
info.model = 'Example model';

tcl = tiledlayout(gridheight, gridwidth);
set(tcl,'TileSpacing','none');
set(tcl,'Padding','compact');
ttl = title(tcl, 'IES TM-30-18 Color Rendition Report');
set(ttl,'FontSize',16);
set(ttl,"FontWeight","bold");

% Source, date
P = 1; W = 1; H = 3;
nexttile(P,[H,W]);
%plot(rand(5,1));
axis([0,1,0,1]);
axis off;
tt = text(0,0.7,sprintf('Source:  %s',info.source));
tt.FontSize = 12;
tt = text(0,0.2,sprintf('Date:  %s',info.date));
tt.FontSize = 12;

% manufacturer, model
P = 2; W = 1; H = 3;
nexttile(P,[H,W]);
plot(rand(5,1));
axis([0,1,0,1]);
axis off;
tt = text(0,0.7,sprintf('Manufacturer:  %s',info.manufacturer));
tt.FontSize = 12;
tt = text(0,0.2,sprintf('Model:  %s',info.model));
tt.FontSize = 12;

% spectrum graphics
P = 2*4-1; W = 1; H = 6;
nexttile(P,[H,W]);
F = getframe(spg.fh);
imshow(F.cdata);
axis off;
% set(gca,"Position",[0,0,1,1],Units="normalized");

%plot(rand(5,1));

P = P + 1;
nexttile(P,[H,W]);
plot(rand(5,1));

P = 2*10-1; W = 1; H = 14;
nexttile(P,[H,W]);
plot(rand(5,1));

P = P + 1;W = 1; H = 7;
nexttile(P,[H,W]);
plot(rand(5,1));

P = 2*17 ; W = 1; H = 7;
nexttile(P,[H,W]);
plot(rand(5,1));

P = 2*24-1; W = 2; H = 9;
nexttile(P,[H,W]);
plot(rand(5,1));

P = 2*33-1; W = 1; H = 5;
nexttile(P,[H,W]);
plot(rand(5,1));

P = P + 1;W = 1; H = 5;
nexttile(P,[H,W]);
plot(rand(5,1));

P = 2*38-1 ; W = 2; H = 1;
nexttile(P,[H,W]);
plot(rand(5,1));
