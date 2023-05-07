function ExampleCIE1964_XYZ()
    % Standard illuminant E: A flat spectrum from 360:830
    sE = CIE_Illuminant('E');
    % a common pattern: Compute some property of a spectrum, then add that property as a field.
    % Many routines make use of this: When field XYZ is present in a spectrum, and that field is a struct with fields
    % 'x' and 'y', then the computation of CIE XYZ values by integration is skipped when the XYZ values are needed.
    sE.XYZ = CIE1964_XYZ(sE);
    fprintf('CIE Illuminant E: 1964 X Y Z x y z = %g, %g, %g, %g, %g, %g\n',sE.XYZ.X,sE.XYZ.Y,sE.XYZ.Z,sE.XYZ.x,sE.XYZ.y,sE.XYZ.z);
    % a single mode helium neon laser line with integral 1
    s_HeNe = MakeSpectrum([632.815, 632.816, 632.817],[0,1000,0]);
    s_HeNe.XYZ = CIE1964_XYZ(s_HeNe);
    fprintf('HeNe: 1964 X Y Z x y z = %g, %g, %g, %g, %g, %g\n',s_HeNe.XYZ.X,s_HeNe.XYZ.Y,s_HeNe.XYZ.Z,...
        s_HeNe.XYZ.x,s_HeNe.XYZ.y,s_HeNe.XYZ.z);
end