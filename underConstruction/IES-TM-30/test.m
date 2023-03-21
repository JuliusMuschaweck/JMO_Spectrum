tmp = IES_TM30;

spec = ReadLightToolsSpectrumFile('LED_4003K.sre');
%%
tmp.SetSpectrum(spec);
[Rf,Rfi] = tmp.FidelityIndex();
Rg = tmp.GamutIndex();
%%
tmp.Clear();