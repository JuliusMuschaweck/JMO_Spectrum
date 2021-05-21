function rv = TLCIReferenceSpectrum( CCT )
% returns CIE D daylight spectrum mixed with Planck according to 
% EBU 3355.
% input: CCT in Kelvin
% return value: rv struct with rv.lam, rv.val, rv.CCT, rv.description
% rv.lam = 380:760 step 5
% rv.val = spectrum values according to the standard, normalized to 1 at 560.
% rv.CCT is obvious
% rv.description contains a description
    lam = 380:5:760;
    lam = lam(:);
    if (lam(37) ~= 560)
        error('TLCIReferenceSpectrum: lam(37) ~= 560: this cannot happen');
    end
    rv.CCT = CCT;
    if CCT < 5000 % need Planck
        planck = PlanckSpectrum(lam, CCT);
        planck = MakeSpectrumDirect(planck.lam, planck.val);
        % normalize to 560 nm
        planck.val = 100 * planck.val / (planck.val(37));
    end
    if CCT > 3400 % need daylight
        Dspec = CIE_Illuminant_D(CCT, 'lam', lam, 'enforceCCTrange', false);
%         iT = 1000/CCT;
%         iT2 = iT*iT;
%         iT3 = iT2 * iT;
%         if CCT < 7000
%             xD = -4.6070 * iT3 + 2.9678 * iT2 + 0.09911 * iT + 0.244063;
%         else
%             xD = - 2.0064 * iT3 + 1.9018 * iT2 + 0.24748 * iT + 0.237040;            
%         end
%         yD = -3.0 * xD * xD + 2.870 * xD -0.275;
%         den = 0.25539 * xD - 0.73217 * yD + 0.02387;
%         M1 = (-1.77861 * xD + 5.90757 * yD - 1.34674) / den;
%         M2 = (-31.44464 * xD + 30.06400 * yD + 0.03638) / den;
%         Dspec.lam = lam;
%         Dspec.val = CIE_D_local.S0.val + M1 * CIE_D_local.S1.val + M2 * CIE_D_local.S2.val;
%         % normalize to 560 nm
        Dspec.val = 100 * Dspec.val / Dspec.val(37);
    end
    if CCT <= 3400 % pure planck
        rv = planck;
        rv.description = sprintf("CIE Daylight Spectrum, CCT = %g K, pure Planck spectrum, according to EBU Tech 3355 Appendix 3 / CIE Tech.15:2004", CCT);
    elseif CCT >= 5000 % pure daylight
        rv = Dspec;
        rv.description = sprintf("CIE Daylight Spectrum, CCT = %g K, pure daylight spectrum, according to EBU Tech 3355 Appendix 3 / CIE Tech.15:2004", CCT);
    else % mixed spectrum
        u = (CCT - 3400) / (5000 - 3400);
        rv.val = u * Dspec.val + (1-u) * planck.val;
        rv.lam = lam;
        rv.description = sprintf("CIE Daylight Spectrum, CCT = %g K, mixed Planck/daylight spectrum, according to EBU Tech 3355 Appendix 3 / CIE Tech.15:2004", CCT);
    end
    rv.CCT = CCT;
end
