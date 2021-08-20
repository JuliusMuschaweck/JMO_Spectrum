%% RGBLEDSpectrum
% 
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp; 
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp;
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp; 
% <a href="GroupedList.html"> Grouped list</a> &nbsp; | &nbsp; 
% Source code: <a href = "file:../RGBLEDSpectrum.m"> RGBLEDSpectrum.m</a>
% </p>
% </html>
%
% A class that models red/green/blue LED spectra under operating conditions, from data sheet
% information only.
%% Modeling concept
% This class addresses the following problem: For a particular sample of a particular pure color (red/green/blue) LED type, 
% we would like to know the full spectrum (in absolute W/nm) and the voltage as function of the
% operating conditions, i.e. current and junction temperature. However, all we typically have at our disposal is
% information from data sheets, some a priori information about LEDs in general, 
% and an assumption from which bin the LED is coming from.
%
% As it turns out, the spectrum of such an LED varies with temperature and current in a very
% particular way: To a good approximation, there is an underlying spectral "bell curve" shape, which is
% characteristic for the chip type used, and which is quite similar between LEDs of different power 
% and from different vendors, for the same color.
% The actual spectrum then varies with current and junction temperature, shifting in
% wavelength, scaling in total power, and widening or narrowing. But the underlying shape
% remains nearly unchanged. 
%
% Moreover, the dependence of the key parameters
% (dominant wavelength, luminous flux, spectral width and voltage) on current and temperature
% _separates_, approximately: For example, if the dominant wavelength decreases by 1 nm when
% the temperature increases from 25°C to 45°C, it will do that for any current. We do not need the full
% 2D functional dependence; 1D cross sections suffice.
%
% Our approach, therefore, is this:
% 
% * A spectrum, e.g. digitized from the data sheet, gives us the underlying spectral shape at
% grouping conditions.
% * A set of characteristic curves, taken from the datasheet or estimated from prior
% knowledge, tell us how voltage and spectral properties (dominant wavelength $\lambda_{dom}$, luminous flux $\Phi_v$ and spectral 
% width $\sigma$) vary when current and
% temperature deviate from grouping conditions.
% * Grouping conditions (current and temperature), taken from the data sheet, establish the
% baseline for all relative variations.
% * Binning values (for flux, wavelength and voltage) characterize the grouping condition
% properties of our particular LED sample. 
% * Finally, we compute the operating condition spectrum: The operating condition flux, 
% dominant wavelength and spectral width result from given binning values plus relative deviation given by the
% characteristic curves. Then, the underlying base spectrum is transformed in an iterative process to reproduce these
% values. For voltage, we similarly take the binning value, and the operating condition
% deviation to compute actual operating voltage.
% * Note that "temperature" is always taken as "junction temperature". Often, this is quite
% sufficient. However, it may be necessary to estimate operating condition performance given
% "solder point temperature" or an even more general "ambient temperature". When this is the
% case, this model needs to be integrated into a thermal network, where junction temperature
% is estimated in a higher level iterative procedure from the overall energy balance. While this is
% beyond the scope of this class, both radiant power and thermal power to be cooled off
% are available as model output, as input for the thermal network.
%% Creation
% |obj = RGBLEDSpectrum()| 
%
% creates the object with a zero power default spectrum, with all
% other numeric parameters set to NaN (not a number). The following methods should be called
% to set all required model parameters: |SetBaseSpectrum,
% SetGroupingConditions, SetCharacteristicCurves, SetBinningParameters|. Note that
% |SetGroupingConditions| must be called before |SetCharacteristicCurves|. In addition,
% |SetSpectralWidthCurves| allows to specialize the generic default spectral width dependence.
%% Adding LED type related information
%
% <html><h3>Base spectrum</h3> </html>
%
% |SetBaseSpectrum(obj, baseSpectrum)| 
% 
% assigns the base spectrum to the object. This is the spectrum that will be transformed
% (shifted, scaled), applying datasheet, binning and operating information.
%
% Input parameters:
% 
% * |baseSpectrum|: A spectrum (|struct| with fields |lam| and |val|, see
% <docDesignDecisions.html design decisions>):  The underlying spectrum shape of this LED type. Typically taken from
% the vendor web site, digitized from the data sheet, or a "generic" spectrum: Due to the
% underlying physics of the LED material systems, it is quite possible to take a, say, red
% spectrum from one LED and use it for a very different red LED.
%
% <html><h3>Grouping conditions</h3> </html>
%
% |SetGroupingConditions(obj, grouping_Temp, grouping_I)|
%
% informs the model about the temperature and current where each LED is measured for binning
% purposes. Data sheets typically state how actual LED output varies relative to grouping
% condition.
%
% Input parameters:
%
% * |grouping_Temp|: scalar double: The grouping temperature in °C. This is the temperature
% where the measurements for LED binning are taken. In most cases, this is stated in the data
% sheet, maybe a little cryptic. Often, grouping temperature is 25°C, but some LEDs are
% binned at 85°C to make binning conditions closer to actual operating conditions.
% * |grouping_I|: scalar double: The grouping current, in mA. This is the current where LEDs
% are binned, typically at 50% to 70% of maximum current.
%
% <html><h3>Characteristic curves</h3> </html>
%
% |SetCharacteristicCurves(obj, I_vs_U, relFlux_vs_I, relFlux_vs_Temp, delta_ldom_vs_I,
% delta_ldom_vs_Temp, deltaU_vs_Temp)|
%
% is the interface to enter information from data sheets on how LED performance varies with
% operating conditions vs. performance at grouping conditions.
%
% Input parameters:
% 
% * |I_vs_U|: A struct with fields |I| and |U|, both of which are double vectors of same
% length. This table is interpreted as a continuous, piecewise linear function, and describes how voltage 
% changes with current, at grouping temperature. Units are mA for |I| and V for |U|.
% * |relFlux_vs_I|:  A struct with fields |I| and |relFlux|, both of which are double vectors of same
% length. This table is interpreted as a continuous, piecewise linear function, and describes
% the factor of how the luminous flux changes with current, at grouping temperature. Units are mA for |I|,
% while |relFlux| is dimensionless.
% * |relFlux_vs_Temp|: A struct with fields |Temp| and |relFlux|, both of which are double vectors of same
% length. This table is interpreted as a continuous, piecewise linear function, and describes
% the factor by which luminous flux varies with temperature.
% * |delta_ldom_vs_I|: A struct with fields |I| and |U|, both of which are double vectors of same
% length. This table is interpreted as a continuous, piecewise linear function, and describes
% by how many nanometers the dominant wavelength changes with current.
% * |delta_ldom_vs_Temp|: A struct with fields |I| and |U|, both of which are double vectors of same
% length. This table is interpreted as a continuous, piecewise linear function, and describes
% by how many nanometers the dominant wavelength changes with temperature.
% * |deltaU_vs_Temp|:  A struct with fields |I| and |U|, both of which are double vectors of same
% length. This table is interpreted as a continuous, piecewise linear function, and describes
% by how many Volts the voltage changes with temperature. 
%
% <html><h3>Spectral width</h3> </html>
%
% |SetSpectralWidthCurves(obj, relSigma_vs_I, relSigma_vs_Temp)|
% 
% is the interface to specialize the dependence of spectral width on current and temperature.
% This information is typically not available from data sheets. Therefore, we use a
% "generic" default dependence, taken from experiments. Use this function to override this
% default dependence.
%
% Input parameters:
% 
% * |relSigma_vs_I|:  A struct with fields |I| and |relSigma|, both of which are double vectors of same
% length. This table is interpreted as a continuous, piecewise linear function, and describes
% the factor of how the spectral width changes with current, at grouping temperature. Units are mA for |I|,
% while |relSigma| is dimensionless.
% * |relSigma_vs_Temp|: A struct with fields |Temp| and |relSigma|, both of which are double vectors of same
% length. This table is interpreted as a continuous, piecewise linear function, and describes
% the factor by which spectral width varies with temperature.
% 
%% Individual LED information
% |SetBinningParameters(obj, U, Phiv, ldom)|
%
% is used to inform the model about the binning condition parameters of an individual LED. 
%
% Input parameters:
% 
% * |U|: Scalar double. The binning condition voltage in Volts.
% * |Phiv|: Scalar double: The luminous flux at binning conditions, in lumens.
% * |ldom|: Scalar double: The dominant wavelength at binning conditions, in nm.
%
%% Operating condition performance
%
% <html><h3>Full information</h3> </html>
% 
% |rv = OperatingSpectrum(obj, I, Temp)|
% 
% estimates the operating condition spectrum of the particular LED to be modeled, with some
% additional information.
% 
% Input parameters:
% 
% * |I|: Scalar double. The operating current in mA.
% * |Temp|: Scalar double. The operation junction temperature in °C.
%
% Return value: |rv| is a valid spectrum with additional fields:
%
% * |lam|: Vector of double. The wavelengths of the LED spectrum. Length is same as the
% original LED spectrum that has been set with |SetBaseSpectrum|, but the values are
% transformed. Use <ResampleSpectrum.html ResampleSpectrum> if another wavelength array is
% desired.
% * |val|: Vector of double, same length as |lam|. The LED spectrum in W/nm.
% * |I|: Scalar double. The operating current, a copy of the input parameter.
% * |Temp|: Scalar double. The operating junction temperature, a copy of the input
% parameter.
% * |U|: Scalar double. The voltage at operating conditions in Volts. 
% * |XYZ|: Struct with fields |X, Y, Z, cw, x, y, z| with CIE 1931 colorimetric data, as returned from
% <CIE_1931XYZ.html CIE_1931XYZ>.
% * |luminousFlux|: Scalar double. Luminous flux at operating conditions in lumen, equals |rv.XYZ.Y * 683|.
% * |ldom|: Scalar double. Dominant wavelength at operating conditions in nm.
% * |purity|: Scalar double. Purity at operating conditions. See <LDomPurity.html LDomPurity> for details.
% * |radiantFlux|: Scalar double. Radiant flux in Watts.
% * |P_thermal|: Scalar double.  The thermal power to be cooled off in Watts. Equals electric
% power minus radiant flux.

% <html><h3>Voltage only</h3> </html>
%
% |rv = Operating_U(obj, I, Temp)|
%
% estimates the voltage at operating conditions.
%
% Input parameters: 
% 
% * |I|: Scalar double. The operating current in mA.
% * |Temp|: Scalar double. The operation junction temperature in °C.
%
% Return value: |rv| is a scalar double: The LED voltage in V.
%
%% Utility functions
%
% |function PlotCharacteristicCurves(obj)|
%
% plots the characteristic curves, useful for debugging and sanity checking of input given to the model.
%% See also
% <CIE1931_XYZ.html CIE1931_XYZ>, <LDomPurity.html LDomPurity>, <ShiftToLdom.html, ShiftToLdom>
%% Usage Example
% See <TestRGBLED.html TestRGBLED> for usage.

% JMO Spectrum Library, 2021. See https://github.com/JuliusMuschaweck/JMO_Spectrum
% I dedicate the JMO_Spectrum library to the public domain under Creative Commons Zero 
% (https://creativecommons.org/publicdomain/zero/1.0/legalcode)
%

classdef RGBLEDSpectrum < handle
    %RGBLEDSpectrum models RGB LED spectra at various conditions, based on data sheet information
    
    properties
        baseSpectrum % spectrum from data sheet, in W/nm
        grouping_Temp = NaN % temperature at grouping, in °C
        grouping_I = NaN % current at grouping, in mA
        grouping_U = NaN % voltage at grouping, in V
        grouping_Phiv = NaN % luminous flux at grouping, in lm
        grouping_ldom = NaN % dominant wavelength at grouping, in nm
        I_vs_U = NaN % struct with array fields I and U to model current vs. voltage
        relFlux_vs_I = NaN % struct with array fields relFlux and I to model relative flux vs. current
        relFlux_vs_Temp = NaN % struct with array fields relFlux and Temp to model relative flux vs. temperature
        delta_ldom_vs_I = NaN % struct with array fields delta_ldom and I to model ldom change vs. current 
        delta_ldom_vs_Temp = NaN % struct with array fields delta_ldom and Temp to model ldom change vs. temperature
        deltaU_vs_Temp = NaN % struct with array fields deltaU and Temp to model voltage change vs. temperature
        relSigma_vs_I = NaN % struct with array fields relSigma and I to model spectral width vs. current
        relSigma_vs_Temp = NaN % struct with array fields relSigma and Temp to model spectral width vs. current        
    end
    
    methods
        function obj = RGBLEDSpectrum()
            obj.baseSpectrum = MakeSpectrum([400,700],[0,0], 'name','zero power default spectrum');
        end
        
        function SetBaseSpectrum(obj, baseSpectrum)
            arguments
                obj
                baseSpectrum (1,1) {IsSpectrum}
            end
            obj.baseSpectrum = baseSpectrum;
        end
        
        function SetGroupingConditions(obj, grouping_Temp, grouping_I)
            arguments
                obj
                grouping_Temp (1,1) double
                grouping_I (1,1) double {mustBePositive}
            end
            obj.grouping_Temp = grouping_Temp;
            if (grouping_Temp < 0) || (grouping_Temp > 125)
                warning('RGBLEDSpectrum: Are you sure grouping_Temp == %g °C?',grouping_Temp);
            end
            obj.grouping_I = grouping_I;
            if (grouping_I < 10) || (grouping_I > 3000)
                warning('RGBLEDSpectrum: Are you sure grouping_I == %g mA?',grouping_I);
            end
        end
        
        function SetCharacteristicCurves(obj, I_vs_U, relFlux_vs_I, relFlux_vs_Temp, delta_ldom_vs_I, ...
                delta_ldom_vs_Temp, deltaU_vs_Temp)
            arguments
                obj
                I_vs_U (1,1) struct
                relFlux_vs_I (1,1) struct
                relFlux_vs_Temp (1,1) struct
                delta_ldom_vs_I (1,1) struct
                delta_ldom_vs_Temp (1,1) struct
                deltaU_vs_Temp (1,1) struct           
            end
            if isnan(obj.grouping_Temp)
                error('RGBLEDSpectrum.SetCharacteristicCurves: call SetGroupingConditions first');
            end
            % check requirements
            ok = true;
            ok = ok && isequal(sort(fieldnames(I_vs_U)), {'I';'U'});
            ok = ok && isequal(sort(fieldnames(relFlux_vs_I)), {'I';'relFlux'});
            ok = ok && isequal(sort(fieldnames(relFlux_vs_Temp)), {'Temp';'relFlux'});
            ok = ok && isequal(sort(fieldnames(delta_ldom_vs_I)), {'I';'delta_ldom'});
            ok = ok && isequal(sort(fieldnames(delta_ldom_vs_Temp)), {'Temp';'delta_ldom'});
            ok = ok && isequal(sort(fieldnames(deltaU_vs_Temp)), {'Temp';'deltaU'});
            if ~ok
                error('RGBLEDSpectrum.SetCharacteristicCurves: check field name requirements');
            end
            obj.I_vs_U = I_vs_U;
            obj.relFlux_vs_I = relFlux_vs_I;
            obj.relFlux_vs_Temp = relFlux_vs_Temp;
            obj.delta_ldom_vs_I = delta_ldom_vs_I;            
            obj.delta_ldom_vs_Temp = delta_ldom_vs_Temp;
            obj.deltaU_vs_Temp = deltaU_vs_Temp;
            if isnan(obj.relSigma_vs_I)
                Imax = max([max(I_vs_U.I), max(relFlux_vs_I.I), max(delta_ldom_vs_I.I)]);
                Igroup = obj.grouping_I;
                % experience: rel. sigma varies linearly with I from 0.92 at I=0 to 1.0 at
                % Igroup and can be linearly extrapolated beyond.
                irelSigma_vs_I = struct('I',[0, Igroup, Imax],'relSigma',[0.92, 1.00, 1 + 0.08 * (Imax - Igroup) / Igroup]);
                % experience: rel. sigma varies linearly with temperature, from 1.0 at 25°C
                % to 1.1 at 95°C, in other words by 10% for dT = 70K
                irelSigma_vs_Temp = struct('Temp', [obj.grouping_Temp - 105, obj.grouping_Temp + 105],...
                    'relSigma',[0.85, 1.15]);
                obj.SetSpectralWidthCurves(irelSigma_vs_I, irelSigma_vs_Temp);                
            end
        end
        
        function SetSpectralWidthCurves( obj, relSigma_vs_I, relSigma_vs_Temp)
            arguments
                obj
                relSigma_vs_I (1,1) struct
                relSigma_vs_Temp (1,1) struct
            end
            ok = true;
            ok = ok && isequal(sort(fieldnames(relSigma_vs_I)), {'I';'relSigma'});
            ok = ok && isequal(sort(fieldnames(relSigma_vs_Temp)), {'Temp';'relSigma'});
            if ~ok
                error('RGBLEDSpectrum.SetSpectralWidthCurves: check field name requirements');
            end
            obj.relSigma_vs_I = relSigma_vs_I;
            obj.relSigma_vs_Temp = relSigma_vs_Temp;
        end
        
        function SetBinningParameters(obj, U, Phiv, ldom)
            arguments
                obj
                U (1,1) double
                Phiv (1,1) double
                ldom (1,1) double
            end
            obj.grouping_U = U;
            obj.grouping_Phiv = Phiv;
            obj.grouping_ldom = ldom;
        end

        function rv = OperatingSpectrum(obj, I, Temp)
            % rv has fields lam, val, I, Temp, U, and color information
            % compute ldom = grouping_ldom + delta_ldom_vs_I(I) + delta_ldom_vs_Temp(Temp)
            delta_l_I = LinInterpol(obj.delta_ldom_vs_I.I, obj.delta_ldom_vs_I.delta_ldom, I);
            delta_l_Temp = LinInterpol(obj.delta_ldom_vs_Temp.Temp, obj.delta_ldom_vs_Temp.delta_ldom, Temp);
            ldom = obj.grouping_ldom + delta_l_I + delta_l_Temp;
            rel_sigma = LinInterpol(obj.relSigma_vs_I.I, obj.relSigma_vs_I.relSigma, I) ...
                * LinInterpol(obj.relSigma_vs_Temp.Temp, obj.relSigma_vs_Temp.relSigma, Temp);
            s = obj.baseSpectrum;
            s.lam = (s.lam - obj.grouping_ldom) * rel_sigma + obj.grouping_ldom;
            % shift spectrum to ldom, compute flux of unscaled spectrum
            rv = ShiftToLdom(s, ldom);
            % compute flux: Phiv = grouping_flux * relFlux_vs_I(I) * relFlux_vs_Temp(Temp)
            relFlux_I = LinInterpol(obj.relFlux_vs_I.I,obj.relFlux_vs_I.relFlux, I);
            relFlux_Temp = LinInterpol(obj.relFlux_vs_Temp.Temp,obj.relFlux_vs_Temp.relFlux, Temp);
            Phiv = obj.grouping_Phiv * relFlux_I * relFlux_Temp;
            XYZ0 = CIE1931_XYZ(rv);
            fac = Phiv / (XYZ0.Y * 683);
            rv.val = rv.val * fac;
            rv.I = I;
            rv.Temp = Temp;
            rv.U = obj.Operating_U(I, Temp);
            % as long as these are the fields returned by CIE1931_XYZ, we can simply scale
            % extrinsic fields
            if isequal(fieldnames(XYZ0),{'X','Y','Z','cw','x','y','z'})
                XYZ0.X = XYZ0.X * fac;
                XYZ0.Y = XYZ0.Y * fac;
                XYZ0.Z = XYZ0.Z * fac;
                XYZ0.cw = XYZ0.cw * fac;
                rv.XYZ = XYZ0;
            else % compute again to stay compatible
                rv.XYZ = CIE1931_XYZ(rv); 
            end
            rv.luminousFlux = rv.XYZ.Y * 683;
            [rv.ldom, rv.purity] = LDomPurity(rv);
            rv.radiantFlux = IntegrateSpectrum(rv);
            rv.P_thermal = rv.U * rv.I * 0.001 - rv.radiantFlux;
        end
        
        function rv = Operating_U(obj, I, Temp)
            % typical voltage at grouping conditions according to data sheet
            U_standard_grouping= LinInterpol(obj.I_vs_U.I, obj.I_vs_U.U, obj.grouping_I);
            % typical voltage at grouping temperature and actual current
            U_standard_I = LinInterpol(obj.I_vs_U.I, obj.I_vs_U.U, I);
            % voltage shift due to current
            delta_U_I = U_standard_I - U_standard_grouping;
            % voltage shift due to temperature
            delta_U_T = LinInterpol(obj.deltaU_vs_Temp.Temp, obj.deltaU_vs_Temp.deltaU, Temp);
            % add voltage shifts to grouping voltage
            rv = obj.grouping_U + delta_U_I + delta_U_T;
        end
        
        function PlotCharacteristicCurves(obj)
            figure();
            clf;
            plot(obj.relFlux_vs_Temp.Temp,obj.relFlux_vs_Temp.relFlux);
            hold on;
            plot(obj.delta_ldom_vs_Temp.Temp,obj.delta_ldom_vs_Temp.delta_ldom);
            plot(obj.deltaU_vs_Temp.Temp,obj.deltaU_vs_Temp.deltaU);
            plot(obj.relSigma_vs_Temp.Temp, obj.relSigma_vs_Temp.relSigma);
            xlabel('Temperature (°C)');
            legend({'\Phi_{rel}','\Delta\lambda_{dom}',...
                '\Delta U','\sigma_{rel}'});
            figure();
            clf;
            plot(obj.I_vs_U.U,obj.I_vs_U.I);
            xlabel('U (V)');
            ylabel('I (mA)');
            figure();
            clf;
            hold on;
            plot(obj.relFlux_vs_I.I,obj.relFlux_vs_I.relFlux);
            plot(obj.delta_ldom_vs_I.I,obj.delta_ldom_vs_I.delta_ldom);
            plot(obj.relSigma_vs_I.I,obj.relSigma_vs_I.relSigma);
            
            xlabel('I (mA)');
            legend({'\Phi_{rel}','\Delta\lambda_{dom}','\sigma_{rel}'});
           
        end
    end
end

