publishWithStandardExample('AddSpectra.m');
publishWithStandardExample('AddWeightedSpectra.m');
publishWithStandardExample('AssignNewWavelength.m');
publishWithStandardExample('CauchyFromAbbe.m');
publishWithStandardExample('CCT.m');
publishWithStandardExample('CCT_from_xy.m');
publishWithStandardExample('CIE1931_Data.m');
publishWithStandardExample('CIE1931_XYZ.m');
publishWithStandardExample('CIE_Illuminant.m');
publishWithStandardExample('CIE_Illuminant_D.m');
publishWithStandardExample('CIE_Lab.m');


publishWithStandardExample('PlanckSpectrum.m');

% CIEDE2000_Lab.m 
% CIEDE2000_XYZ.m 
% CIE_Luv.m 
% CIE_upvp.m 
% CODATA2018.m 
% ComputeSpectrumColorimetry.m 
% CRI.m 
% EvalSpectrum.m 
% Example_WhiteLED.m 
% FindRoot1D.m 
% GaussSpectrum.m 
% IntegrateSpectrum.m 
% IsOctave.m 
% IsSpectrum.m 
% LDomPurity.m 
% LinInterpol.m 
% LinInterpolAdd4Async.m 
% MacAdamEllipse.m 
% MacAdamEllipse_g.m 
% MakeSpectrum.m 
% MultiplySpectra.m 
% PlanckLocus.m 
% PlotCIExyBorder.m 
% RainbowColorMap.m 
% ReadLightToolsSpectrumFile.m 
% RGBLEDSpectrum.m 
% ShiftToLdom.m 
% SolarSpectrum.m 
% SpectrumSanityCheck.m 
% TestCIEDE2000.m 
% TestCRI_vanKries.m 
% TestLinInterpol.m 
% TestMacAdamEllipse.m 
% Vlambda.m 
% WriteLightToolsSpectrumFile.m 


fprintf('publish additional docs\n')
publish('docDesignDecisions.m','evalCode',true,'showCode',true);
publish('PublishFunctionTemplate.m','evalCode',false,'showCode',false);
%%
Doc_mlx('BlackbodySpectrumWithRefractiveIndex.mlx');
Doc_mlx('docCauchyFromAbbe.mlx');

%%
fprintf('publish main doc pages\n')
publish('JMOSpectrumLibrary.m','evalCode',true,'showCode',true);
publish('AlphabeticList.m','evalCode',false,'showCode',false);
publish('GroupedList.m','evalCode',false,'showCode',false);


close all;
fprintf('done\n')

function Doc_mlx(fn)
    [~,fname,~] = fileparts(fn);
    matlab.internal.liveeditor.openAndConvert(fn, ['html/',fname,'.html']);
end

