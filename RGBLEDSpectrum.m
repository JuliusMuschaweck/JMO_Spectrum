%% RGBLEDSpectrum
% 
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp; 
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp;
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp; 
% <a href="GroupedList.html"> Grouped list</a>
% </p>
% </html>
%
% documentation to be completed
%
classdef RGBLEDSpectrum < handle
    %RGBLEDSpectrum models RGB LED spectra at various conditions, based on data sheet information
    
    properties
        baseSpectrum % spectrum from data sheet
        grouping_Temp % temperature at grouping
        grouping_I % current at grouping
        grouping_U = NaN % voltage at grouping
        grouping_Phiv = NaN % luminous flux at grouping
        grouping_ldom = NaN % dominant wavelength at grouping
        I_vs_U = NaN % struct with array fields I and U to model current vs. voltage
        relFlux_vs_I = NaN % struct with array fields relFlux and I to model relative flux vs. current
        relFlux_vs_Temp = NaN % struct with array fields relFlux and T to model relative flux vs. temperature
        delta_ldom_vs_I = NaN % struct with array fields delta_ldom and I to model ldom change vs. current 
        delta_ldom_vs_Temp = NaN % struct with array fields delta_ldom and T to model ldom change vs. temperature
        deltaU_vs_Temp = NaN % struct with array fields deltaU and T to model voltage change vs. temperature
    end
    
    methods
        function obj = RGBLEDSpectrum(baseSpectrum, grouping_Temp, grouping_I)
            obj.baseSpectrum = baseSpectrum;
            obj.baseSpectrum.ldom = LDomPurity(obj.baseSpectrum);
            obj.grouping_Temp = grouping_Temp;
            obj.grouping_I = grouping_I;
        end
        
        function SetCharacteristicCurves(obj, I_vs_U, relFlux_vs_I, relFlux_vs_Temp, delta_ldom_vs_I, ...
                delta_ldom_vs_Temp, deltaU_vs_Temp)
            obj.I_vs_U = I_vs_U;
            obj.relFlux_vs_I = relFlux_vs_I;
            obj.relFlux_vs_Temp = relFlux_vs_Temp;
            obj.delta_ldom_vs_I = delta_ldom_vs_I;            
            obj.delta_ldom_vs_Temp = delta_ldom_vs_Temp;
            obj.deltaU_vs_Temp = deltaU_vs_Temp;
        end
        
        function SetBinningParameters(obj, U, Phiv, ldom)
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
            % shift spectrum to ldom, compute flux of unscaled spectrum
            rv = ShiftToLdom(obj.baseSpectrum, ldom);
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
            rv.XYZ = CIE1931_XYZ(rv);
            [rv.ldom, rv.purity] = LDomPurity(rv);
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
            xlabel('Temperature (°C)');
            legend({'\Phi_{rel}','\Delta\lambda_{dom}',...
                '\Delta U'});
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
            xlabel('I (mA)');
            legend({'\Phi_{rel}','\Delta\lambda_{dom}'});
           
        end
    end
end

