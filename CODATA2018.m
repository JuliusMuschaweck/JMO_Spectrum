function cd = CODATA2018()
% function cd = CODATA2018()
% from https://physics.nist.gov/cuu/Constants/index.html
    persistent rv;
    if isempty(rv)
        rv.b  = MakeEntry('Wien wavelength displacement law constant', 0.002897771955, 0, 'm K');
        rv.bprime = MakeEntry('Wien frequency displacement law constant', 5878925757, 0, 'Hz K^-1');
        rv.c  = MakeEntry('speed of light in vacuum', 299792458, 0, 'm s^-1');
        rv.e  = MakeEntry('elementary charge', 1.602176634E-19, 0, 'C');
        rv.h  = MakeEntry('Planck constant', 6.62607015E-34, 0, 'J s');
        rv.k  = MakeEntry('Boltzmann constant', 1.380649E-23, 0, 'J K^-1');
        rv.me = MakeEntry('electron mass', 9.109383701528E-31, 3e-10, 'kg');
        rv.mn = MakeEntry('neutron mass', 1.6749274980495E-27, 5e-10, 'kg');
        rv.mp = MakeEntry('proton mass', 1.6726219236951E-27, 3.1e-10, 'kg');
     % from CODATA2014   rv.mu = MakeEntry('atomic mass constant', 1.66053904E-27, 2E-35, 'kg');
        rv.NA = MakeEntry('Avogadro constant', 6.02214076E+23, 0, 'mol^-1');
        rv.R  = MakeEntry('molar gas constant', 8.314462618, 0, 'J mol^-1 K^-1');
        rv.Vm = MakeEntry('molar volume of ideal gas (273.15 K, 101.325 kPa)', 22.41396954e-3, 0, 'm^3 mol^-1');
        rv.sigma = MakeEntry('Stefan-Boltzmann constant', 5.670374419e-8, 0, 'W m^-2 K^-4');
        rv.c1 = MakeEntry('first radiation constant, 2 pi h c^2', 3.741771852E-16, 0, 'W m^2');
        rv.c1L= MakeEntry('first radiation constant for spectral radiance, 2 h c^2', 1.191042972E-16, 0, 'W m^2 sr^-1');
        rv.c2 = MakeEntry('second radiation constant, h c / k', 0.01438776877, 0, 'm K');
    end
    cd = rv;
end

function rv = MakeEntry(name,value,uncertainty,unit)
    rv.name = name;
    rv.value = value;
    rv.reluncertainty = uncertainty;
    rv.absuncertainty = uncertainty * value;
    rv.unit = unit;
end