function ExampleCODATA2018()
    cd = CODATA2018();
    c = cd.c;
    fprintf('c: name = %s, value = %i, reluncertainty = %g, unit = %s\n',c.name, c.value, c.reluncertainty, c.unit);
    c2 = cd.c2.value;
    h = cd.h.value;
    k = cd.k.value;
    c2_indirect = h * c.value / k;
    fprintf('difference of c2 = %0.11f to h * c / k is %g\n',c2, c2-c2_indirect);
end