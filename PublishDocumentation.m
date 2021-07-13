publishWithStandardExample('AddSpectra.m');
publishWithStandardExample('AddWeightedSpectra.m');
publishWithStandardExample('CauchyFromAbbe.m');
publishWithStandardExample('CCT.m');
publishWithStandardExample('CCT_from_xy.m');
publishWithStandardExample('CIE1931_Data.m');
publishWithStandardExample('CIE1931_XYZ.m');
publishWithStandardExample('CIE_Illuminant.m');
publishWithStandardExample('CIE_Illuminant_D.m');
publishWithStandardExample('CIE_Lab.m');
publishWithStandardExample('CIE_Luv.m');
publishWithStandardExample('CIEDE2000_Lab.m');
publishWithStandardExample('CIEDE2000_XYZ.m');
publishWithStandardExample('CIE_upvp.m');
publishWithStandardExample('CODATA2018.m');
publishWithStandardExample('ComputeSpectrumColorimetry.m');
publishWithStandardExample('CRI.m');
publishWithStandardExample('EvalSpectrum.m');

publishWithStandardExample('FindRoot1D.m');
publishWithStandardExample('FindRootND.m');
publishWithStandardExample('GaussSpectrum.m');
publishWithStandardExample('IntegrateSpectrum.m');
publish('IsOctave.m','evalCode',false,'showCode',false);
publishWithStandardExample('IsSpectrum.m');
publishWithStandardExample('JMOSpectrumVersion.m');
publishWithStandardExample('LDomPurity.m');

publishWithStandardExample('MatchAdditiveMix.m');

publishWithStandardExample('PlanckSpectrum.m');
publishWithStandardExample('ResampleSpectrum.m');
publishWithStandardExample('LinInterpol.m');
publishWithStandardExample('LinInterpolAdd4Async.m');
publishWithStandardExample('MacAdamEllipse.m');
publish('MacAdamEllipse_g.m','evalCode',false,'showCode',false);
publishWithStandardExample('MakeSpectrum.m');
publishWithStandardExample('MakeSpectrumDirect.m');
publishWithStandardExample('MatchWhiteLEDSpectrum.m'); % see ExampleMatchWhiteLEDSpectrum.m
publishWithStandardExample('MultiplySpectra.m');
publish('Octave_xyz2rgb.m','evalCode',false,'showCode',false);
publishWithStandardExample('PlanckLocus.m');
% COBYLA.m
% Example_WhiteLED.m
NotYetDocumented('OptimalAdditiveMix.m');
NotYetDocumented('PlotCIExyBorder.m');
NotYetDocumented('PlotCRIResult.m'); % see ExamplePlotCRIResult.m
NotYetDocumented('RainbowColorMap.m');
NotYetDocumented('ReadASCIITableFile.m');
NotYetDocumented('ReadASCIITableSpectrumFile.m');
NotYetDocumented('ReadLightToolsSpectrumFile.m');
NotYetDocumented('RGBLEDSpectrum.m');
NotYetDocumented('ShiftToLdom.m');
NotYetDocumented('SolarSpectrum.m');
NotYetDocumented('SpectrumSanityCheck.m');
NotYetDocumented('TestMacAdamEllipse.m');
NotYetDocumented('Vlambda.m');
NotYetDocumented('WriteLightToolsSpectrumFile.m');
NotYetDocumented('XYZ_from_xyY.m');


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

function NotYetDocumented(fn)
    publish(fn,'evalCode',false,'showCode',false);
end