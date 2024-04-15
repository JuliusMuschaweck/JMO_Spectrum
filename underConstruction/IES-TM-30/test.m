clear;
tmp = IES_TM30;

% spec = ReadLightToolsSpectrumFile('LED_4003K.sre');
spec = ReadASCIITableSpectrumFile('OSRAM_ColorCalc_LED4000K.txt');
figure(1);
PlotSpectrum(spec);
[myCCT,myduv] = CCT(spec)
%%
tmp.SetSpectrum(spec);
[Rf,Rfi] = tmp.FidelityIndex();
Rg = tmp.GamutIndex();
figure(2);
bar(Rfi);
%%
cvg = tmp.ColorVectorGraphic();
%%
tmp.Clear();