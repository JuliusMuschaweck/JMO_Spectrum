clear;

fn = "NIST_Spectral_Skin_Reflectivity_raw.xlsx";
rawdata = readmatrix(fn,Range="A9:OK759");
nSubjects = (size(rawdata,2) - 1) / 4; % col 1 = lambda, 1,2,3 + avg for each subject
lam = rawdata(:,1);
for isubject = 1:nSubjects
    col = 1 + 4 * isubject;
    s = MakeSpectrum(lam,rawdata(:,col));
    s.name = sprintf("NIST spectral skin reflectivity, subject # %g",isubject);
    s.xyz = CIE1931_XYZ(s);
    vis_range = [360,830];
    vis_weight = MakeSpectrumDirect([360,830],[1,1]);
    s.avg_refl_360_830nm = IntegrateSpectrum(s,vis_weight) / diff(vis_range);
    skinReflectivities{isubject} = s;
end

save("NIST_Spectral_Skin_Reflectivities.mat","skinReflectivities");

%%
clear;
% close all;
load("NIST_Spectral_Skin_Reflectivities.mat","skinReflectivities");
nSubjects = length(skinReflectivities);
for i = 1:nSubjects
    s = skinReflectivities{i};
    x(i) = s.xyz.x;
    y(i) = s.xyz.y;
    refl(i) = s.avg_refl_360_830nm;
end
fh = figure(1); clf; hold on; axis equal;
[ah, fh] = PlotCIExyBorder(Figure=fh);
scatter(ah,x,y);
pl = PlanckLocus();
plot(ah,pl.x,pl.y);
cri = CRI();
cri13 = cri.CRISpectra_(13);
cri13.xyz = CIE1931_XYZ(cri13);
scatter(ah,cri13.xyz.x,cri13.xyz.x,'filled','square');
%%
figure(2);clf;
histogram(refl,20);