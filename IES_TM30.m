%% IES_TM30
%
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp;
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp;
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp;
% <a href="GroupedList.html"> Grouped list</a> &nbsp; | &nbsp; 
% Source code: <a href = "file:../CRI.m"> CRI.m</a>
% </p>
% </html>
%
% The |IES_TM30| class provides what is needed to compute the quantities
% defined in IES TM30-20: "Technical Memorandum 30: IES METHOD FOR EVALUATING LIGHT
% SOURCE COLOR RENDITION", and to create the reports defined in Annex D
% thereof.
%% Constructor syntax
% * |this = IES_TM30(opts)|
% with optional argument (name-value pair) |Spectrum|. 
% For example: |tm30 = IES_TM30( Spectrum = CIE_Illuminant("D65"));| or equivalently
% |s = CIE_Illuminant("D65"); tm30 = IES_TM30( "Spectrum", s);|. When
% omitted, then you must inform the IES_TM30 object about the spectrum by
% calling the |SetSpectrum| method, otherwise all functions that need a spectrum will throw an error.
%% Properties
% * |IES_TM30_spectra_|: The 99 reflectivity spectra, as a 401x100 double
%               array. First column is wavelength. Read from |IES_TM30\IES_TM30_spectra_raw.mat|.
% * |s_|: struct with lam val fields. Spectrum for which we evaluate rendition properties. Scaled to Y_10 = 100.
% * |iCCT_|: double. Its color temperature.
% * |duv_|: double. Its distance to Planck.
% * |s_ref_|: struct with lam val. Reference spectrum. Scaled to Y_10 = 100.
% * |CES_XYZ_s_|: 1x99 struct with X Y Z cw x y z. 1964 10° XYZ tristimulus values 
%               for reflected light off the 99 samples.
% * |CES_XYZ_s_ref_|: 1x99 struct with X Y Z cw x y z. Same for the reference spectrum.
% * |Jab_s_|: struct with J_prime a_prime b_prime, each 1x99 double.
%               According to CIECAM J', a', b' (Eqs. 48-50) for 99 reflected spectra.
% * |Jab_s_ref_|: same for reference spectrum.
% * |Delta_E_Jab_|: 1x99 double. The 99 color differences, Eq. 52.
% * |Jab_binned_s_|: struct with J_prime a_prime b_prime h, each 1x16 double, and bin, 1x99 double. 
%               The J'a'b' values of test spectrum averaged over the 16 hue bins.
% * |Jab_binned_s_ref_|: struct with J_prime a_prime b_prime h, each 1x16 double, and bin, 1x99 double. 
%               The J'a'b' values of reference spectrum  averaged over the 16 hue bins.
% * |sRGB_SampleColors_|: 99 x 3 RGB colors under D65 daylight (for the
%               individual fidelity bar chart).
%% Methods
%
% <html>
%   <ul>
%       <li> <tt>function SetSpectrum(obj, s)</tt>: Informs the class instance about which
%               spectrum to analyze; computes all spectrum dependent properties. Performs
%               sanity checking on <tt>s</tt>. 
%               <br>  <b>Input Argument:</b> 
%           <ul style="list-style-type: circle;">
%               <li><tt>s</tt>, a valid spectrum with wavelength range at least 400 to 700.</li>
%           </ul> 
%       </li><br>
%       <!-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -->
%       <li> <tt>function [Rf, Rf_i, Rf_hj] = FidelityIndex(obj)</tt>: Compute and return the overall fidelity
%               index <tt>Rf</tt> (scalar double), the individual fidelity indices <tt>Rf_i</tt> for each color sample (1x99 double)
%               and the local fidelity indices <tt>Rf_hj</tt> for each hue
%               angle bin (1x16 double).
%       </li><br>
%       <!-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -->
%       <li> <tt>function Rg = GamutIndex(obj)</tt>: Compute and return the
%               overall gamut index <tt>Rg</tt>, scalar double. 
%       </li><br>
%       <!-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -->
%       <li> <tt>function rv = ColorVectorGraphic(obj,opts)</tt>: Plots the color vector
%               graphics according to section 4.5; computes the necessary quantities and returns them.
%               <br><b>Optional arguments</b> (name-value pairs):
%           <ul style="list-style-type: circle;">
%               <li> <tt>FigureNumber</tt>: (default 1, scalar positive integer double) plots
%                   to the given figure number. 
%               </li>
%               <li> <tt>Disclaimer</tt>: (default true, scalar logical) triggers presence of 
%                   the disclaimer ('Colors are for visual orientation % purposes only') 
%                   as in Annex D, Figure D.1. 
%               </li>
%               <li> <tt>DisclaimerTime</tt>: (default true, scalar logical) triggers presence 
%                   of a date/time stamp with the disclaimer. 
%               </li>
%           </ul>
%           <b>Return value:</b>
%           <ul style="list-style-type: circle;">
%               <li> <tt>rv</tt>: struct with fields
%                   <ul style="list-style-type: none;">
%                       <li> <tt>rv.x_ref</tt> and <tt>rv.y_ref</tt>, both 1x16
%                           double, are the x/y plot coordinates (NOT CIE x/y coordinates) of the
%                           reference spectrum points. 
%                       </li> 
%                       <li> <tt>x_test</tt> and <tt>y_test</tt> are the same for the test spectrum. 
%                       </li>
%                       <li> <tt>Rf</tt>, scalar double, is the overall fidelity index.  
%                       </li>
%                       <li> <tt>Rg</tt>, scalar double, is the overall gamut index. 
%                       </li>
%                       <li> <tt>CCT</tt>, scalar double, is the correlated color temperature of the test spectrum, and 
%                       </li>
%                       <li> <tt>duv</tt>, scalar double is its distance to the Planck locus in u/v color space. 
%                       </li>
%                       <li> <tt>ax</tt> is the handle to the plot axis.
%                       </li>
%                   </ul>
%               </li>        
%           </ul>
%       </li><br>
%       <!-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -->
%       <li> <tt>function rv =
%       LocalChromaHueShiftFidelityGraphics(obj,opts)</tt>: Plots three
%       graphics: (i) local chroma shift. (ii) local hue shift, (iii) local
%       fidelity index, each for the 16 hue angle bins.
%       <br><b>Optional arguments</b> (name-value pairs):
%           <ul style="list-style-type: circle;">
%               <li> <tt>ChromaFigureNumber</tt>: (default 2, scalar positive integer double) plots
%                   local chroma shift to the given figure number. 
%               </li>
%               <li> <tt>HueFigureNumber</tt>: (default 3, scalar positive integer double) plots
%                   local hue shift to the given figure number. 
%               </li>
%               <li> <tt>FidelityFigureNumber</tt>: (default 3, scalar positive integer double) plots
%                   local fidelity index to the given figure number. 
%               </li>
%               <li> <tt>xLabels</tt>: (default [true, true, true], 1x3
%                       logical) controls printing of x axis labels for the
%                       three plots.
%               </li>
%               <li> <tt>relBarWidth</tt>: (default [0.5,0.5,0.5], 1x3
%                       double) sets the width of the bars in each of the
%                       three plots. A value of 1.0 means no gap between
%                       bars-
%               </li>
%               <li> <tt>mValues</tt>: (default [true, true, true], 1x3
%                       logical) controls printing of m values above the
%                       plots. (m_j is the number of individual samples
%                       that are in each hue bins).
%               </li>
%           </ul>
%           <b>Return value:</b>
%           <ul style="list-style-type: circle;">
%               <li> <tt>rv</tt>: struct with fields
%                   <ul style="list-style-type: none;">
%                       <li><tt>R_csh</tt>: 1x16 double, local chroma shift values
%                       </li>
%                       <li><tt>R_hsh</tt>: 1x16 double, local hue shift values
%                       </li>
%                       <li><tt>Rf_hj</tt>: 1x16 double, local color fidelity
%                       </li>
%                       <li><tt>axc</tt>: axis handle to chroma shift plot
%                       </li>
%                       <li><tt>axh</tt>: axis handle to hue shift plot
%                       </li>
%                       <li><tt>axf</tt>: axis handle to fidelity shift plot
%                       </li>
%                   </ul>
%               </li>        
%           </ul>
%       </li><br>
%       <!-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -->
%       <li> <tt>function rv = IndividualFidelityGraphics(obj, opts)</tt>:
%                   Plots bar chart of 99 individual color fidelities.
%       <br><b>Optional argument</b> (name-value pairs):
%           <ul style="list-style-type: circle;">
%               <li> <tt>FigureNumber</tt>: (default 5, scalar positive integer double) plots
%                   to the given figure number.
%               </li>
%           </ul>
%       <b>Return value</b>:
%           <ul style="list-style-type: circle;">
%               <li> <tt>rv</tt>: struct with fields
%                   <ul style="list-style-type: none;">
%                       <li><tt>ax</tt>: axis handle to plot
%                       </li>
%                       <li><tt>Rf_j</tt>: 1x99 double, individual fidelity
%                               values.
%                       </li>
%                   </ul>
%               </li>        
%           </ul>
%       </li><br>
%       <!-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -->
%       <li> <tt>function rv = SpectrumGraphics(obj, opts)</tt>: Plots test
%               and reference spectra.
%       <br><b>Optional argument</b> (name-value pairs):
%           <ul style="list-style-type: circle;">
%               <li> <tt>FigureNumber</tt>: (default 6, scalar positive integer double) plots
%                   to the given figure number.
%               </li>
%               <li><tt>RelativeScale</tt>: (default "flux", string). 
%                   <br>When "flux", scales spectra to same luminous flux (useful for broad spectra).
%                  <br> When"peak", scales spectra to same peak (useful for spectra
%                  with narrow peaks).
%           </ul>
%       <b>Return value</b>:
%           <ul style="list-style-type: circle;">
%               <li> <tt>rv</tt>: struct with fields
%                   <ul style="list-style-type: none;">
%                       <li><tt>s</tt>: A copy of the test spectrum
%                       </li>
%                       <li><tt>s_ref</tt>: The scaled reference spectrum
%                       </li>
%                       <li><tt>ax</tt>: Handle to plot axes
%                       </li>
%                       <li><tt>fh</tt>: Handle to plot figure
%                       </li>
%                   </ul>
%               </li>        
%           </ul>
%       </li><br>
%       <!-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -->
%       <li> <tt>function CreateFullReport(obj,opts)</tt>: Creates a "full
%                   report" according to Annex D, based on the current
%                   spectrum, and exports the report to a pdf file. The text 
%                   fields of the report content can and should be
%                   specified. This function first creates the figures (using 
%                   the default figure numbers) and saves them to .png 
%                   graphics files (whose default names can be modified if desired).
%                   Then it opens the specially designed Matlab App that
%                   has no interactive features. The App contains the report.
%                   The method then saves the App main figure to a pdf file.
%           <br><b>Optional arguments</b> (name-value pairs):
%               <ul style="list-style-type: circle;">
%                   <li> <tt>Source</tt>: (default "Unnamed source", string,
%                           string) is written in the "Source" field of the
%                           report.
%                   </li>
%                   <li> <tt>Manufacturer</tt>: (default "Unnamed manufacturer", string,
%                           string) is written in the "Manufacturer" field of the
%                           report.
%                   </li>
%                   <li> <tt>Model</tt>: (default  "Unnamed model", string,
%                           string) is written in the "Model" field of the
%                           report.
%                   </li>
%                   <li> <tt>Notes</tt>: (default  "--", string,
%                           string) is written in the "Notes" field of the
%                           report.
%                   </li>
%                   <li> <tt>SpectrumGraphicsName</tt>: (default
%                           "SpectrumGraphics.png", string ) is the name of
%                           the spectrum graphics file.
%                   </li>
%                   <li> <tt>SpectrumRelativeScale</tt>: ("flux" (default) or "peak", 
%                           string ) is used for spectrum scaling
%                           (see the <tt>SpectrumGraphics</tt> method for
%                           details).
%                   </li>
%                   <li> <tt>ChromaShiftGraphicsName</tt>: (default
%                           "ChromaShiftGraphics.png", string ) is the name of
%                           the local chroma shift graphics file.
%                   </li>
%                   <li> <tt>CVGGraphicsName</tt>: (default
%                           "ColorVectorGraphics.png", string ) is the name of
%                           the color vector graphics file.
%                   </li>
%                   <li> <tt>HueShiftGraphicsName</tt>: (default
%                           "HueShiftGraphics.png", string ) is the name of
%                           the local hue shift graphics file.
%                   </li>
%                   <li> <tt>FidelityGraphicsName</tt>: (default
%                           "FidelityGraphics.png", string ) is the name of
%                           the local fidelity graphics file.
%                   </li>
%                   <li> <tt>IndividualFidelityGraphicsName</tt>: (default
%                           "IndividualFidelityGraphics.png", string ) is the name of
%                           the individual fidelity graphics file.
%                   </li>
%                   <li> <tt>ReportFileName</tt>: (default
%                           "TM30Report.pdf", string ) is the name of
%                           pdf report file.
%                   </li>
%               </ul>
%       </li><br>
%       <!-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -->
%       <li> <tt>function CreateFullReport_LaTeX(obj,opts)</tt>: Same
%       purpose and optional arguments as <tt>CreateFullReport</tt>, except
%       that graphics files are written as vector graphics to .eps files
%       and that a working LaTeX installation including pdflatex.exe is
%       required. The result looks very similar, but the graphics quality
%       is probably better due to vector graphics. However, that difference
%       should only be visible for magnified print output. Another small
%       difference is that this pdf is scaled to A4 paper (can be modified
%       by changing the paper size in <tt>IES_TM30ReportTemplate.tex</tt>),
%       whereas <tt>CreateFullReport</tt> creates a somewhat smaller page
%       (16.7 x 23.6 cm on my machine).
%       </li><br>
%       <!-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -->
%       <li> <tt>function Clear(obj)</tt>: Delete all spectrum dependent properties, leaving only
%                the spectrum independent 99 reflectivity spectra and sRGB colors thereof.
%       </li><br>
%   </ul>
% </html>
%
%% Algorithm
% The class implements ANSI/IES TM-30-20 +ERRATA 1: TECHNICAL MEMORANDUM:
% IES METHOD FOR EVALUATING LIGHT SOURCE COLOR RENDITION, which is
% generally considered superior to the color rendering index defined in CIE
% 13.3-1995. CIE has recognized this, and the IES TM-30 fidelity index is
% very similar to the new CIE 224:2017 colour fidelity index. However, IES
% TM-30 also includes the gamut area index, and a standardized reporting
% format. 
%% See also
% <CRI.html CRI>, <CCT.html CCT>, <PlanckSpectrum.html PlanckSpectrum>,
% <CIE_Illuminant.html CIE_Illuminant>, <CIE_Illuminant_D.html CIE_Illuminant_D>
%% Usage Example
% <include>Examples/ExampleIES_TM30.m</include>

% publish with publishWithStandardExample('filename.m') in PublishDocumentation.m

% JMO Spectrum Library, 2021. See https://github.com/JuliusMuschaweck/JMO_Spectrum
% I dedicate the JMO_Spectrum library to the public domain under Creative Commons Zero
% (https://creativecommons.org/publicdomain/zero/1.0/legalcode)
%

classdef IES_TM30 < handle
    properties (GetAccess = public, SetAccess = private)
        IES_TM30_spectra_   % 99 reflectivity spectra, as a 401 x 100 double array. First column is wavelength. 
        s_                  % struct with lam val. Spectrum for which we evaluate rendition properties. Scaled to Y_10 = 100
        iCCT_               % double. Its color temperature
        duv_                % double. Distance to Planck
        s_ref_              % struct with lam val. Reference spectrum. Scaled to Y_10 = 100
        CES_XYZ_s_          % 1x99 struct with X Y Z cw x y z. 1964 10° XYZ tristimulus values 
                            % for reflected light off the 99 samples
        CES_XYZ_s_ref_      % 1x99 struct with X Y Z cw x y z. Same for the reference spectrum
        Jab_s_              % struct with J_prime a_prime b_prime, each 1x99 double.
                            % CIECAM J', a', b' (Eqs. 48-50) for 99 reflected spectra
        Jab_s_ref_          % same for reference spectrum
        Delta_E_Jab_        % 1x99 double. The 99 color differences, Eq. 52
        Jab_binned_s_       % struct with J_prime a_prime b_prime h, each 1x16 double, and bin, 1x99 double. 
                            % J'a'b' values of test averaged over the 16 hue bins
        Jab_binned_s_ref_   % struct with J_prime a_prime b_prime h, each 1x16 double, and bin, 1x99 double. 
                            % J'a'b' values of ref averaged over the 16 hue bins
        sRGB_SampleColors_  % 99 x 3 RGB colors under D65 daylight
    end

    methods
        function this = IES_TM30(opts) % constructor, set up sample color spectra etc.
            arguments
                opts.Spectrum (1,1) struct = struct
            end
            tmp = load(this.IES_TM30_SubDirFileName('IES_TM30\IES_TM30_spectra_raw.mat'),'IES_TM30_spectra');
            this.IES_TM30_spectra_ = tmp.IES_TM30_spectra;
            this.sRGB_SampleColors_ = nan(99,3);
            lam = this.IES_TM30_spectra_(:,1); % first column is wavelength, 380:780
            D65 = CIE_Illuminant('D65');
            D65 = ResampleSpectrum(D65,lam); % now D65 on 380:780
            XYZD65 = CIE1964_XYZ(D65);
            for i = 1:99 % compute sRGB sample colors
                % can be speeded up if needed by using MakeSpectrumDirect, and
                % directly multiplying the value arrays which are both
                % based on 380:780.
                si = MakeSpectrum(this.IES_TM30_spectra_(:,1), this.IES_TM30_spectra_(:,i+1));
                si65 = MultiplySpectra(D65, si);
                XYZ_i = CIE1964_XYZ(si65);
                fac = 1 / XYZD65.Y;
                RGB = XYZ_to_sRGB(XYZ_i.X * fac, XYZ_i.Y * fac, XYZ_i.Z * fac);
                this.sRGB_SampleColors_(i,:) = RGB.RGB;
            end
            s = opts.Spectrum;
            if ~isempty(fields(s)) % optional argument has been given
                this.SetSpectrum(opts.Spectrum); % error checking done there
            end
        end

        function SetSpectrum(obj, s) % tell object to evaluate this spectrum
            arguments
                obj
                s (1,1) struct % a spectrum
            end
            obj.Clear();
            try
                % 3.0 to 3.4 prepare
                % sanity check
                s = obj.SanityCheck(s);

                % Use CIE 1931 XYZ for CCT and for x/y
                % XYZ_10 tristimulus values of test and reference sources scaled such that Y_10 == 100
                % scale s to Y_10 = 100
                obj.s_ = obj.Scale_to_Y10_100(s);

                % compute CCT
                [obj.iCCT_, obj.duv_] = obj.myCCT(obj.s_);

                % get reference source
                % Reference illuminant: Planck for < 4000, CIE D for > 5000, linear proportional mix between 4000 and 5000 using spectral scaled to equal Y_10
                obj.s_ref_= obj.ReferenceSource(obj.iCCT_);

                % 3.6 Do 99 CES reflectance XYZ_10 for test and reference
                [obj.CES_XYZ_s_, obj.CES_XYZ_s_ref_] = obj.GetCES_XYZ(obj.s_, obj.s_ref_);

                % 3.7 Apply CIECAM02
                obj.Jab_s_ = obj.CIECAM02(obj.s_.XYZ1964, obj.CES_XYZ_s_);
                obj.Jab_s_ref_ = obj.CIECAM02(obj.s_ref_.XYZ1964, obj.CES_XYZ_s_ref_);

                % 3.8 Color difference
                %     Delta_E_Jab_i
                %         according to Eq 52
                obj.Delta_E_Jab_ = sqrt((obj.Jab_s_.J_prime - obj.Jab_s_ref_.J_prime).^2 + ...
                    (obj.Jab_s_.a_prime - obj.Jab_s_ref_.a_prime).^2 + (obj.Jab_s_.b_prime - obj.Jab_s_ref_.b_prime).^2);

                % 4.3 Hue angle bins: J'a'b' values averaged over the 16 hue bins
                obj.Jab_binned_s_ = obj.Jab_binned(obj.Jab_s_);
                obj.Jab_binned_s_ref_ = obj.Jab_binned(obj.Jab_s_ref_);

            catch ME
                obj.Clear();
                rethrow(ME);
            end
        end

        function [Rf, Rf_i, Rf_hj] = FidelityIndex(obj) 
            % compute overall fidelity index (4.1), 
            % 99 individual fidelity indices (4.2)
            % and 16 local fidelity indices (4.8)
            if isempty(obj.s_)
                error('IES_TM30.FidelityIndex: no data, use SetSpectrum first');
            end
            % 4.1 Fidelity index Rf from all Delta_E_Jab_i, Eq 53-54
            Rf_prime = 100 - 6.73 / 99 * sum(obj.Delta_E_Jab_);
            Rf = 10 * log(exp(Rf_prime/10) + 1);

            % 4.2 individual sample Rf,CESi from Delta_E_Jab_i, Eq 55-56
            Rf_prime_CESi = 100 - 6.73 * obj.Delta_E_Jab_;
            Rf_i = 10 * log(exp(Rf_prime_CESi/10) + 1);

            % 4.8 local color fidelity 
            bin = obj.Jab_binned_s_.bin;
            dE = nan(1,16);
            for j = 1:16
                dE(j) = mean(obj.Delta_E_Jab_(bin == j));
            end
            Rfprime_hj = 100 - 6.73 * dE;
            Rf_hj = 10 * log(exp(Rfprime_hj/10) + 1);
        end

        function Rg = GamutIndex(obj)
            % 4.4 Gamut index Rg
            %     Rg = 100 * ratio of polygon areas for test vs ref. Polygon defined by 16 avg aprime bprime values
            if isempty(obj.s_)
                error('IES_TM30.GamutIndex: no data, use SetSpectrum first');
            end
            test_area = polyarea(obj.Jab_binned_s_.a_prime, obj.Jab_binned_s_.b_prime);
            ref_area =  polyarea(obj.Jab_binned_s_ref_.a_prime, obj.Jab_binned_s_ref_.b_prime);
            Rg = 100 * test_area / ref_area;        % J'a'b' values averaged over the 16 hue bins
        end

        function rv = ColorVectorGraphic(obj,opts)
            % plot the color vector graphics. 
            % Optional arguments (name-value): 
            %   FigureNumber (integer double): figure to plot to. Default: 1
            %   Disclaimer (boolean): Print disclaimer at bottom
            %   DisclaimerTime (boolean): Add time and date to disclaimer
            %
            % Return value:
            %   rv: struct with fields
            %       x_ref:  1x16 double (reference axis (non-CIE) coordinate, (58)
            %       y_ref:  1x16 double (reference axis (non-CIE) coordinate, (59)
            %       x_test: 1x16 double (reference axis (non-CIE) coordinate, (60)
            %       y_test: 1x16 double (reference axis (non-CIE) coordinate, (61)
            %       Rf:     overall fidelity index
            %       Rg:     overall gamut index
            %       CCT:    CCT of spectrum
            %       duv:    uv distance of spectrum to Planck
            %       ax:     The axis object containing the plot
            arguments
                obj
                opts.FigureNumber (1,1) double = 1
                opts.Disclaimer (1,1) logical = true
                opts.DisclaimerTime (1,1) logical = true
            end
            if isempty(obj.s_)
                error('IES_TM30.ColorVectorGraphic: no data, use SetSpectrum first');
            end
            % 4.5 Color Vector Graphic
            %     scale ref avg aprime bprime radially to circle with r = 1
            %     apply delta avg aprime bprime
            %     Plot arrow plot with color background, Fig. 8
            % rv: struct with fields
            %   x_ref, y_ref, x_test, y_test according to (58) - (61)
            %   fig: figure handle to graphic according to Fig. 8 bottom
            ref_bins = obj.Jab_binned_s_ref_.bin;
            ref_h = obj.Jab_binned_s_ref_.h;
            for j = 1:16
                h(j) = mean(ref_h(ref_bins == j)); %#ok<AGROW>
            end
            rv.x_ref = cos(h); % (58)
            rv.y_ref = sin(h); % (59)
            % conflict between standard and code:
            % TM30-18 document says (a_test_j - a_ref_j) / sqrt((a_test_j + b_ref_j)^2)
            % where the denominator is strange.
            % First, the sqrt and the ^2 cancel to become abs(). It should be sqrt(a^2+b^2)
            % Second, scaling should be norm([a_ref_j,b_ref_j]). It makes no sense to mix
            % a_test with b_ref
            % In the Excel VBA code, they do it like they should but not how the standard is
            % written. We'll do the same.
            den = sqrt((obj.Jab_binned_s_ref_.a_prime).^2 +  (obj.Jab_binned_s_ref_.b_prime).^2);
            rv.x_test = rv.x_ref + (obj.Jab_binned_s_.a_prime ...
                - obj.Jab_binned_s_ref_.a_prime) ./ den; % (60)
            rv.y_test = rv.y_ref + (obj.Jab_binned_s_.b_prime ...
                - obj.Jab_binned_s_ref_.b_prime) ./ den; % (61)

            % prepare the figure
            [ax, markerAngles, hires_angles] = PrepareFigure(opts.FigureNumber);
            xt = rv.x_test;
            yt = rv.y_test;
            % smooth, take center of three repeated intervals. 
            % Cyclic boundary conditions would be better, but hard to find
            xxxtest = cat(2,xt,xt,xt);
            yyytest = cat(2,yt,yt,yt);
            aaangles = cat(2,markerAngles-2*pi,markerAngles,markerAngles+2*pi);
            x_test_smooth = interp1(aaangles,xxxtest,hires_angles,'makima');
            y_test_smooth = interp1(aaangles,yyytest,hires_angles,'makima');
            plot(ax, x_test_smooth,y_test_smooth,Color=[240,80,70]/255,LineWidth=3);

            % arrows
            xref = cos(markerAngles);
            yref = sin(markerAngles);
            % colors of arrows, from Annex B
            arrowColors = ArrowColors();
            for j = 1:16
                Arrow(ax, xref(j),yref(j),xt(j),yt(j),arrowColors(j,:));
            end

            % Rf etc
            Rf = obj.FidelityIndex();
            Rg = obj.GamutIndex();
            iCCT = obj.iCCT_;
            duv = obj.duv_;
            rv.Rf = Rf; rv.Rg = Rg; rv.CCT = iCCT; rv.duv = duv;
            rv.ax = ax;

            text(ax, -1.4,1.37,sprintf('%.0f',Rf),FontSize=24,Color=[0,0,0],FontWeight="bold");
            text(ax, -1.4,1.23,'R_f',FontSize=16,Color=[0,0,0],FontAngle='italic');
            text(ax, -1.4,-1.37,sprintf('%.0f K',iCCT),FontSize=24,Color=[0,0,0],FontWeight="bold");
            text(ax, -1.4,-1.23,'CCT',FontSize=16,Color=[0,0,0]);

            text(ax, 1.4,1.37,sprintf('%.0f',Rg),FontSize=24,Color=[0,0,0],FontWeight="bold",HorizontalAlignment="right");
            text(ax, 1.4,1.23,'R_g',FontSize=16,Color=[0,0,0],FontAngle='italic',HorizontalAlignment="right");
            text(ax, 1.4,-1.37,sprintf('%.4f',duv),FontSize=24,Color=[0,0,0],FontWeight="bold",HorizontalAlignment="right");
            text(ax, 1.4,-1.23,'D_{uv}',FontSize=16,Color=[0,0,0],FontAngle='italic',HorizontalAlignment="right");
            axis equal;
            axis tight;
            axis off;

            % disclaimer
            if opts.Disclaimer
                text(0,-1.6,'Colors are for visual orientation purposes only',FontSize=14,HorizontalAlignment='center');
                if opts.DisclaimerTime
                    str = sprintf('Created with JMO Spectrum Library (%s)',datetime('now',Format='yyyy-MM-dd HH:mm'));
                else
                    str = 'Created with JMO Spectrum Library';
                end
                text(ax, 0,-1.7,str,FontSize=14,HorizontalAlignment='center');
            end

            function rv = ArrowColors()
                rv = ...
                    [230 40 40;      231 75 75;     251 129 46;      255 181 41;
                    203 202 70;     126 185 76;    65 192 109;     0 156 124;
                    22 188 176;     0 164 191;     0 133 195;     59 98 170;
                    69 104 174;     106 78 133;     157 105 161;     167 79 129]...
                    / 255;
            end

            function [ax, markerAngles, hires_angles] = PrepareFigure(fignum)
                background = imread(obj.IES_TM30_SubDirFileName('IES_TM30\CVG_Background.png'));
                fh = figure(fignum);
                clf;
                % flipud and YDir = normal to avoid reversed y axis
                imshow(flipud(background),'XData',[-1.5,1.5],'YData',[-1.5,1.5]);
                axis on; hold on;
                ax = gca;
                ax.YDir = 'normal';
                fh.Position(3:4) = [800,800]; % size only, not position
                % center cross
                mygray = 128/255 * [1,1,1];
                scatter(0,0,36,mygray,'+');
                % radial lines
                hueAngles = linspace(0,2*pi,17);
                hueAngles = hueAngles(1:end-1);
                for i = 1:16
                    lims = [0.15, 1.5];
                    x = cos(hueAngles(i)) * lims;
                    y = sin(hueAngles(i)) * lims;
                    plot(x,y,'--',Color=mygray);
                end
                markerAngles = hueAngles + pi/16;
                for i = 1:16
                    d = 1.43;
                    x = d * cos(markerAngles(i))-0.02;
                    y = d * sin(markerAngles(i));
                    text(x,y,num2str(i),FontSize=16,Color=mygray);
                end
                % ref circle
                hires_angles = linspace(0,2*pi,181);
                plot(cos(hires_angles), sin(hires_angles),'k','LineWidth',2);
                for fac = [0.8,0.9,1.1,1.2]
                    plot(fac*cos(hires_angles), fac*sin(hires_angles),'w','LineWidth',1);
                end
                % +/- 20% markers
                text(-0.15,-0.75,"-20%",Color="w");
                text(-0.15,-1.23,"20%",Color="w");
                axis equal;
            end

            function Arrow(ax, x0, y0, x1, y1, color)
                plot(ax, [x0,x1],[y0,y1],Color=color,LineWidth=2);
                aa = 160*pi/180;
                rot = [cos(aa),sin(aa);-sin(aa),cos(aa)];
                dxy = rot * [x1-x0;y1-y0];
                dxy = 0.04 * dxy / norm(dxy);
                plot(ax, [x1,x1+dxy(1)],[y1,y1+dxy(2)],Color=color,LineWidth=2);
                rot = rot';
                dxy = rot * [x1-x0;y1-y0];
                dxy = 0.04 * dxy / norm(dxy);
                plot(ax, [x1,x1+dxy(1)],[y1,y1+dxy(2)],Color=color,LineWidth=2);
            end
        end % ColorVectorGraphic

        function rv = LocalChromaHueShiftFidelityGraphics(obj, opts)
            % 4.6 Local Chroma shifts R_cs,hj
            %     16 relative radial delta aprime bprimes
            %     Plot as in Fig. 11
            % 4.7 Local Hue Shifts R_hs,hj
            %     16 relative tangential delta aprime bprimes
            %     Plot similar to Fig. 11
            % 4.8 Local Color Fidelity H_f,hj
            %     Similar to 4.1 and 4.2 but now with 16 avg values
            %     Eq 64-65
            % Optional arguments:
            %   ChromaFigureNumber: double, default 2
            %   HueFigureNumber:    double, default 3
            %   FidelityFigureNumber: double, default 4
            %   xLabels:     1x3 logical, flag to plot x labels, default true
            %   relBarWidth: 1x3 double, within [0,1], width of bars, default 0.5 
            %   mValues:     1x3 logical, flag to plot m (# of individuals
            %                   in each of the 16 bins) above the plot
            %
            % Return value:
            %   rv: struct with fields
            %       R_csh: 1x16 double, local chroma shift values
            %       R_hsh: 1x16 double, local hue shift values
            %       Rf_hj: 1x16 double, local color fidelity
            %       axc:    axis handle to chroma shift plot
            %       axh:    axis handle to hue shift plot
            %       axf:    axis handle to fidelity shift plot
            arguments
                obj
                opts.ChromaFigureNumber (1,1) double = 2
                opts.HueFigureNumber (1,1) double = 3
                opts.FidelityFigureNumber (1,1) double = 4
                
                opts.xLabels (1,3) logical = [true, true, true] % false for clean x axis
                opts.relBarWidth (1,3) double = [0.5, 0.5, 0.5] % 1 for full width
                opts.mValues (1,3) logical = [true, true, true] % false to turn off m = .. above plot 
            end
            aref = obj.Jab_binned_s_ref_.a_prime; % 1x16
            bref = obj.Jab_binned_s_ref_.b_prime;
            den = sqrt(aref.^2 + bref.^2); % 1x16
            angles = (0.5:15.5) / 16 * 2 * pi; % hue bin center angles
            ta = (obj.Jab_binned_s_.a_prime - aref) ./ den;
            tb = (obj.Jab_binned_s_.b_prime - bref) ./ den;
            rv.R_csh =   ta .* cos(angles) + tb .* sin(angles); % Eq. (62)
            rv.R_hsh = - ta .* sin(angles) + tb .* cos(angles); % Eq. (63)
            
            % chroma shift figure
            [~, axc, barc] = PrepareFigure(opts.ChromaFigureNumber, rv.R_csh * 100, ...
                [-40,40], opts.xLabels(1));
            for i = 1:16
                yval = rv.R_csh(i) * 100;
                ypos = yval + sign(yval) * 5;
                text(axc,i,ypos,sprintf('%.0f%%',yval),...
                    VerticalAlignment="middle", ...
                    HorizontalAlignment='center',...
                    FontSize=12, ...
                    FontName='Helvetica-Narrow');
                if opts.mValues(1)
                    m = sum(obj.Jab_binned_s_.bin == i);
                    text(axc,i,44,num2str(m),...
                        VerticalAlignment="middle", ...
                        HorizontalAlignment='center');
                end
            end
            % 'm = ' above top
            if opts.mValues(1)
                text(axc,0,44,"m =",...
                    VerticalAlignment="middle", ...
                    HorizontalAlignment='left');
            end
            ylbl = {'-40%','-30%','-20%','-10%','0%','10%','20%','30%','40%'};
            barc.BarWidth = opts.relBarWidth(1);
            axc.set("YTick",-40:10:40);
            axc.set("YTickLabel",ylbl);
            axc.set('YMinorTick','on');
            axc.YAxis.set('TickDirection','both');
            axc.YLabel.String = 'Local Chroma Shift (R_{cs,hj})';

            % hue shift figure
            [~, axh, barh] = PrepareFigure(opts.HueFigureNumber, rv.R_hsh, ...
                [-0.5,0.5], opts.xLabels(2));
            for i = 1:16
                yval = rv.R_hsh(i);
                s = sprintf('%0.2f',yval);
                if yval > 0
                    ypos = yval + 0.02;
                    hal = 'left';
                else
                    ypos = yval - 0.02;
                    hal = 'right';
                end
                tt = text(axh,i,ypos,s, ...
                VerticalAlignment='middle', ...
                HorizontalAlignment=hal,...
                FontSize=12, ...
                FontName='Helvetica-Narrow');
                tt.Rotation = 90;
                if opts.mValues(2)
                    m = sum(obj.Jab_binned_s_.bin == i);
                    text(axh,i,0.55,num2str(m),...
                        VerticalAlignment="middle", ...
                        HorizontalAlignment='center');
                end
            end
            % 'm = ' above top
            if opts.mValues(2)
                text(axh,0,0.55,"m =",...
                    VerticalAlignment="middle", ...
                    HorizontalAlignment='left');
            end
            %ylbl = {'-40%','-30%','-20%','-10%','0%','10%','20%','30%','40%'};
            barh.BarWidth = opts.relBarWidth(2);
            axh.set("YTick",-0.5:0.1:0.5);
            %axh.set("YTickLabel",ylbl);
            axh.set('YMinorTick','on');
            axh.YAxis.set('TickDirection','both');
            axh.YLabel.String = 'Local Hue  Shift (R_{hs,hj})';          

            % fidelity figure
            [~,~,Rf_hj] = obj.FidelityIndex();
            rv.Rf_hj = Rf_hj;
            [~, axf, barf] = PrepareFigure(opts.FidelityFigureNumber, Rf_hj, ...
                [0,110], opts.xLabels(3));
            for i = 1:16
                yval = Rf_hj(i);
                s = sprintf('%0.0f',yval);
                ypos = yval + 8;
                text(axf,i,ypos,s, ...
                VerticalAlignment='middle', ...
                HorizontalAlignment='center',...
                FontSize=12, ...
                FontName='Helvetica-Narrow');
                if opts.mValues(3)
                    m = sum(obj.Jab_binned_s_.bin == i);
                    text(axf,i,115,num2str(m),...
                        VerticalAlignment="middle", ...
                        HorizontalAlignment='center');
                end
            end
            % 'm = ' above top
            if opts.mValues(3)
                text(axf,0,115,"m =",...
                    VerticalAlignment="middle", ...
                    HorizontalAlignment='left');
            end
            %ylbl = {'-40%','-30%','-20%','-10%','0%','10%','20%','30%','40%'};
            barf.BarWidth = opts.relBarWidth(3);
            axf.set("YTick",0:10:100);
            %axh.set("YTickLabel",ylbl);
            axf.set('YMinorTick','on');
            axf.YAxis.set('TickDirection','both');
            axf.YLabel.String = 'Local Color Fidelity(R_{f,hj})';                 

            rv.axc = axc;
            rv.axh = axh;
            rv.axf = axf;
            
            function [fh, ax, b] = PrepareFigure(fignum, val, yrange, xLabels)
                fh = figure(fignum);
                fh.Position(3:4) = [800,350];
                clf; hold on;
                ax = gca;
                b = bar(val,'FaceColor','flat');
                bc = BarColors();
                for ii = 1:16
                    b.CData(ii,:) = bc(ii,:);
                end
                % ticks on hor zero line
                for x = 1.5:1:15.5
                    plot([x,x],[0,yrange(1)/20],'k','LineWidth',0.001);
                end
                % box
                plot([0.4,16.6,16.6],[yrange(2), yrange(2), yrange(1)],'k','LineWidth',0.1);
                % 'm = ' above top
                ax.set("YLim",yrange);
                ax.set("XLim",[0.4,16.6]);
                ax.YAxis.set("FontSize",14);
                if xLabels
                    ax.set("XTick",1:16);
                    ax.XAxis.set('TickDirection','none');
                    ax.XAxis.set("FontSize",14);
                    ax.XLabel.String = "Hue-Angle Bin (j)";
                else
                    ax.set("XTick",[]);
                    ax.set("XTickLabel",[]);
                end                
            end

            
            function bc = BarColors()
                bc = [ 
                    163 92  96;   204 118 94;   204 129 69;   216 172 98;
                    172 153 89;   145 158 93;   102 139 94;   97  178 144;
                    123 186 166;  41  122 126;  85  120 141;  112 138 178;
                    152 140 170;  115 88  119;  143 102 130;  186 122 142
                    ] / 255;
            end
        end % LocalChromaHueShiftFidelityGraphics

        function rv = IndividualFidelityGraphics(obj, opts)
            % plot bar chart of 99 individual color fidelities
            % Optional argument:
            %   FigureNumber: double, default 5
            % Return value:
            %   rv: struct with fields
            %       ax:     Axis handle to plot
            %       Rf_j:   1x99 double, individual fidelity values
            arguments
                obj                
                opts.FigureNumber (1,1) double = 5;
            end
            fh = figure(opts.FigureNumber);
            clf; hold on;
            ax = gca;
            [~,Rf_i] = obj.FidelityIndex();
            b = bar(1:99,Rf_i, 'FaceColor','flat');
            for i = 1:99
                b.CData(i,:) = obj.sRGB_SampleColors_(i,:);
            end
            b.BarWidth = 1;
            ax.set("XLim",[0.5,99.5]);
            b.EdgeColor = 'none';
            ax.set('XTick',1:3:97);
            ax.XAxis.set('TickDirection','none');
            ax.YAxis.set('TickDirection','out');
            ax.set('YMinorTick','on');
            ax.XAxis.set('TickLabelRotation',90);
            i = 0;
            lbl=cell(3*97,1);
            for j = 1:3:97
                i = i + 1;
                lbl{i} = sprintf('CES%02.0f',j);
            end
            ax.XAxis.set('TickLabels',lbl)
            ax.set('YTick',0:10:100);
            ax.set('YLim',[0,100]);
            ax.YLabel.String = 'Color Sample Fidelity (R_{f,CESi})';
            plot(ax,[0.5,99.5,99.5],[100,100,0],'k','LineWidth',0.01);
            ax.YAxis.set("FontSize",14);
            ax.XAxis.set("FontSize",14);

            fh.Position(3:4) = [1600,400];

            rv.ax = ax;
            rv.Rf_i = Rf_i;
        end

        function rv = SpectrumGraphics(obj, opts)
            % Plot test and reference spectra
            % Optional arguments:
            %   FigureNumber: double, default 6
            %   RelativeScale: string, "flux" (default) or "peak".
            %       If "flux", spectra contain same luminous flux
            %       If "peak", spectra are normalized to peak 1
            %
            % Return value:
            %   rv: struct with fields
            %       s: A copy of the test spectrum
            %       s_ref: A copy of the scaled reference spectrum
            %       ax: Axis handle to plot
            %       fh: Figure handle to plot
            arguments
                obj                
                opts.FigureNumber (1,1) double = 6;
                opts.RelativeScale (1,1) string = "flux" % or "peak"
            end
            fh = figure(opts.FigureNumber);
            clf; hold on;
            fh.Position(3:4) = [800,350];
            ax = gca;
            if opts.RelativeScale == "flux"
                flux = IntegrateSpectrum(obj.s_, Vlambda());
                flux_ref = IntegrateSpectrum(obj.s_ref_, Vlambda());
                fac = flux / flux_ref;
            elseif opts.RelativeScale == "peak"
                peak = max(obj.s_.val);
                peak_ref = max(obj.s_ref_.val);
                fac = peak / peak_ref;
            else 
                error("IES_TM30.SpectrumGraphics: Unknown RelativeScale option: %s",opts.RelativeScale);
            end
            s = obj.s_;
            sr = obj.s_ref_;
            sr.val = sr.val * fac;
            rv.s = s;
            rv.s_ref = sr;
            p1 = PlotSpectrum(sr,'k');
            p2 = PlotSpectrum(s,'r',LineWidth=2);
            lims = axis(ax);
            plot(ax,[380 780 780],[lims(4)*0.995,lims(4)*0.995,lims(3)],'k');
            axis(lims);
            lg = legend([p1,p2],{'Reference','Test'},Orientation="horizontal", FontSize=12);
            lg.Color = 'none';
            lg.EdgeColor = 'none';
            ax.set('XLim',[380 780]);
            ax.set('XTick',380:50:780);
            ax.set('XMinorTick','on');
            ax.XAxis.set("FontSize",14);
            ax.XLabel.String = 'Wavelength (nm)';
            ax.set("YTick",[]);
            ax.set("YTickLabel",[]);
            if opts.RelativeScale == "flux"
                ax.YLabel.String = {'Radiant Power','(Equal Luminous Flux)'};
            else
                ax.YLabel.String = {'Radiant Power','(Equal Peak)'};
            end
            ax.YAxis.set("FontSize",14);
            
            rv.ax = ax;
            rv.fh = fh;
        end

        function CreateFullReport(obj,opts)
            % "Full report" according to Annex D.
            % It is based on the current spectrum.
            % The text fields content can and should be specified
            % This function first creates the figures and saves them to .png
            % graphics files (whose names can be modified if desired).
            % Then it opens the specially designed Matlab App that has no
            % interactive features. The App contains the report.
            % The method then saves the App main figure to a pdf file.
            arguments
                obj
                opts.Source (1,1) string = "Unnamed source";
                opts.Manufacturer (1,1) string = "Unnamed manufacturer";
                opts.Model (1,1) string = "Unnamed model";
                opts.Notes (1,:) string = "--";
                opts.SpectrumGraphicsName (1,1) string = "SpectrumGraphics.png"
                opts.SpectrumRelativeScale (1,1) string = "flux" % or "peak" for multiple very narrow bands
                opts.ChromaShiftGraphicsName (1,1) string = "ChromaShiftGraphics.png"
                opts.CVGGraphicsName (1,1) string = "ColorVectorGraphics.png"
                opts.HueShiftGraphicsName (1,1) string = "HueShiftGraphics.png"
                opts.FidelityGraphicsName (1,1) string = "FidelityGraphics.png"
                opts.IndividualFidelityGraphicsName (1,1) string = "IndividualFidelityGraphics.png"
                opts.ReportFileName (1,1) string = "TM30Report.pdf"
            end
            fprintf("Creating graphics...\n");
            spg = obj.SpectrumGraphics(RelativeScale=opts.SpectrumRelativeScale);
            exportgraphics(spg.ax,opts.SpectrumGraphicsName);
            Rch = obj.LocalChromaHueShiftFidelityGraphics(xLabels=[false, false, true],...
                relBarWidth=0.9*[1,1,1], mValues=[true,false,false]);
            exportgraphics(Rch.axc,opts.ChromaShiftGraphicsName);
            exportgraphics(Rch.axh,opts.HueShiftGraphicsName);
            exportgraphics(Rch.axf,opts.FidelityGraphicsName);
            cvg = obj.ColorVectorGraphic(Disclaimer=false,DisclaimerTime=false);
            exportgraphics(cvg.ax,opts.CVGGraphicsName);
            ivg = obj.IndividualFidelityGraphics();
            exportgraphics(ivg.ax,opts.IndividualFidelityGraphicsName);

            [fpath,fname,fext] = fileparts(which("IES_TM30.m"));
            oldpath = addpath(string(fpath) + "\IES_TM30");
            try
                app = IESTM30Report;
                app.SourceValueLabel.Text = opts.Source;
                app.ManufacturerValueLabel.Text = opts.Manufacturer;
                app.DateValueLabel.Text = string(datetime('now','Format','yyyy-MM-dd HH:mm'));
                app.ModelValueLabel.Text = opts.Model;
                app.SpectrumGraphicsImage.ImageSource = opts.SpectrumGraphicsName;
                app.ChromaShiftGraphicsImage.ImageSource = opts.ChromaShiftGraphicsName;
                app.CVGImage.ImageSource = opts.CVGGraphicsName;
                app.HueShiftGraphicsImage.ImageSource = opts.HueShiftGraphicsName;
                app.FidelityGraphicsImage.ImageSource = opts.FidelityGraphicsName;
                app.IndividualFidelityGraphics.ImageSource = opts.IndividualFidelityGraphicsName;
                app.NotesValueTextArea.Value = opts.Notes;
                cinf = ComputeSpectrumColorimetry(obj.s_);
                app.xyupvpLabel.Text = [
                    sprintf("x     %.4f",cinf.x);
                    sprintf("y     %.4f",cinf.y);
                    sprintf("u'     %.4f",cinf.up);
                    sprintf("v'     %.4f",cinf.vp)
                    ];
                app.CRITextArea.Value = [
                    "CIE 13.3-1995";
                    "(CRI)";
                    "";
                    sprintf("Ra          %.0f",cinf.CRI_all.Ra);
                    sprintf("R9          %.0f",cinf.CRI_all.Ri(9));
                    sprintf("R13         %.0f",cinf.CRI_all.Ri(13))
                    ];
                fn = opts.ReportFileName;
                [~,~,ext] = fileparts(fn);
                if ~(string(ext) == ".pdf")
                    fn = strcat(fn,".pdf");
                end
                exportapp(app.UIFigure, fn)
                % fprintf('opening %s in standard external pdf viewer\n',fn);
                % system(fn);
                % fprintf('finished creating TM30 report: %s\n',fn);
            catch ME
                path(oldpath);
                rethrow(ME);
            end
            path(oldpath);
        end       
        
        function CreateFullReport_LaTeX(obj,opts)
            % "Full report" according to Annex D.
            % Requires a working LaTeX installation with pdftex.exe
            % (MikTeX works well).
            % The report is based on the current spectrum.
            % The text fields content can and should be specified
            % This function first creates the figures and saves them to
            % .eps graphics files (whose names can be modified if desired).
            % The report is generated from "TM30ReportTemplate.tex", which
            % remains itself unchanged. What changes is "TM30Include.tex",
            % which is generated on each run by this function, and which
            % contains all the command definitions to populate the report.
            % Advantage over "CreateFullReport" is that this report
            % contains vector graphics, which can be printed with higher
            % quality at large magnification, which is probably not needed
            % for standard letter size or A4 size output.
            arguments
                obj
                opts.Source (1,1) string = "Unnamed source";
                opts.Manufacturer (1,1) string = "Unnamed manufacturer";
                opts.Model (1,1) string = "Unnamed model";
                opts.Notes (1,1) string = "-";
                opts.SpectrumGraphicsName (1,1) string = "SpectrumGraphics.eps"
                opts.SpectrumRelativeScale (1,1) string = "flux" % or "peak" for multiple very narrow bands
                opts.ChromaShiftGraphicsName (1,1) string = "ChromaShiftGraphics.eps"
                opts.CVGGraphicsName (1,1) string = "ColorVectorGraphics.eps"
                opts.HueShiftGraphicsName (1,1) string = "HueShiftGraphics.eps"
                opts.FidelityGraphicsName (1,1) string = "FidelityGraphics.eps"
                opts.IndividualFidelityGraphicsName (1,1) string = "IndividualFidelityGraphics.eps"
                opts.ReportFileName (1,1) string = "IES_TM30Report.pdf"
            end
            fprintf("Creating graphics...\n");
            spg = obj.SpectrumGraphics(RelativeScale=opts.SpectrumRelativeScale);
            exportgraphics(spg.ax,opts.SpectrumGraphicsName,'ContentType','vector');
            Rch = obj.LocalChromaHueShiftFidelityGraphics(xLabels=[false, false, true],...
                relBarWidth=0.9*[1,1,1], mValues=[true,false,false]);
            exportgraphics(Rch.axc,opts.ChromaShiftGraphicsName,'ContentType','vector');
            exportgraphics(Rch.axh,opts.HueShiftGraphicsName,'ContentType','vector');
            exportgraphics(Rch.axf,opts.FidelityGraphicsName,'ContentType','vector');
            cvg = obj.ColorVectorGraphic(Disclaimer=false,DisclaimerTime=false);
            exportgraphics(cvg.ax,opts.CVGGraphicsName,'ContentType','vector');
            ivg = obj.IndividualFidelityGraphics();
            exportgraphics(ivg.ax,opts.IndividualFidelityGraphicsName,'ContentType','vector');

            test = dir('IES_TM30ReportTemplate.tex');
            if ~(isstruct(test) && (~isempty(test)) && (test.isdir == false))
                fprintf('File "IES_TM30ReportTemplate.tex" not found in current path, copying it from library folder\n');
                fn = strcat(fileparts(which("IES_TM30.m")),'\IES_TM30\','IES_TM30ReportTemplate.tex');
                status = copyfile(fn,'.');
                if ~status
                    error('IES_TM30.CreateFullReport_LaTeX: Cannot copy "IES_TM30ReportTemplate.tex" to current folder');
                end
            else
                fprintf('IES_TM30ReportTemplate.tex found in current folder\n');
            end
            fprintf('writing LaTeX include file "IES_TM30Include.tex"\n');
            incl = fopen("IES_TM30Include.tex","w");
            try
                fprintf(incl,"%% JMO Spectrum Library TM 30 report -- LaTeX include file\n");
                OneCmd(incl,"Source",opts.Source);
                OneCmd(incl,"Manufacturer",opts.Manufacturer);
                OneCmd(incl,"Date",string(datetime('now','Format','yyyy-MM-dd')));
                OneCmd(incl,"Model",opts.Model);
                OneCmd(incl,"SpectrumGraphics",opts.SpectrumGraphicsName);
                OneCmd(incl,"ChromaShiftGraphics",opts.ChromaShiftGraphicsName);
                OneCmd(incl,"ColorVectorGraphics",opts.CVGGraphicsName);
                OneCmd(incl,"HueShiftGraphics",opts.HueShiftGraphicsName);
                OneCmd(incl,"FidelityGraphics",opts.FidelityGraphicsName);
                OneCmd(incl,"IndividualFidelityGraphics",opts.IndividualFidelityGraphicsName);
                OneCmd(incl,"Notes",opts.Notes);
                cinf = ComputeSpectrumColorimetry(obj.s_);
                OneCmd(incl,"xVal",sprintf("%0.4f",cinf.x));
                OneCmd(incl,"yVal",sprintf("%0.4f",cinf.y));
                OneCmd(incl,"uprimeVal",sprintf("%0.4f",cinf.up));
                OneCmd(incl,"vprimeVal",sprintf("%0.4f",cinf.vp));
                OneCmd(incl,"RaVal",sprintf("%0.0f",cinf.CRI_all.Ra));
                OneCmd(incl,"RnineVal",sprintf("%0.0f",cinf.CRI_all.Ri(9)));
                OneCmd(incl,"RthirteenVal",sprintf("%0.0f",cinf.CRI_all.Ri(13)));
                fclose(incl);
                fprintf('running pdflatex to create pdf report\n');
                [status,~] = system('pdflatex IES_TM30ReportTemplate.tex'); % replace ~ with cmdout to see what happened in detail
                if ~(status == 0)
                    error('IES_TM30.CreateFullReport_LaTeX: could not run pdflatex. MikTeX installed?');
                end
                fn = opts.ReportFileName;
                [~,~,ext] = fileparts(fn);
                if ~(string(ext) == ".pdf")
                    fn = strcat(fn,".pdf");
                end
                copyfile("IES_TM30ReportTemplate.pdf",fn);
                delete("IES_TM30ReportTemplate.pdf");
                fprintf('opening %s in standard external pdf viewer\n',fn);
                system(fn);
                fprintf('finished creating TM30 report: %s\n',fn);
            catch ME
                fclose(incl);
                rethrow(ME);
            end
            function OneCmd(incl, cmd, def)
                fprintf(incl,"\\newcommand{\\%s}{%s}\n",cmd,def);
            end
        end

        function Clear(obj)
            % delete all spectrum dependent properties, leave only
            % the 99 reflectivity spectra and sRGB colors thereof
            obj.s_ = [];                 % spectrum for which we evaluate rendition properties. Scaled to Y_10 = 100
            obj.iCCT_ = [];              % its color temperature
            obj.duv_  = [];
            obj.s_ref_ = [];             % reference spectrum. Scaled to Y_10 = 100
            obj.CES_XYZ_s_ = [];         % 1964 10° XYZ tristimulus values for reflected light off the 99 samples
            obj.CES_XYZ_s_ref_ = [];     % same for the reference spectrum
            obj.Jab_s_ = [];             % CIECAM J', a', b' (Eqs. 48-50) for 99 reflected spectra
            obj.Jab_s_ref_ = [];         % same for reference spectrum
            obj.Delta_E_Jab_ = [];       % the 99 color differences, Eq. 52
            obj.Jab_binned_s_ = [];      % J'a'b' values averaged over the 16 hue bins
            obj.Jab_binned_s_ref_ = [];  % J'a'b' values averaged over the 16 hue bins
        end

    end % methods

    methods(Access = private)
        function rv = IES_TM30_SubDirFileName(~,fn)
            [fpath,fname,fext] = fileparts(which("IES_TM30.m"));
            rv = fullfile(fpath, fn); 
        end

        function rv = SanityCheck(~, s)
            [ok, msg, s] = SpectrumSanityCheck(s);
            if ~ok
                error('IES_TM30.Evaluate: spectrum failed sanity test: %s',msg);
            end
            % Wavelength range: at min 400 - 700, at max 380 - 780
            if (min(s.lam) > 400) || (max(s.lam) < 700)
                error('IES_TM30.Evaluate: spectrum must have wavelength range at least 400..700 nm, found [%g,%g]',min(s.lam),max(s.lam));
            end
            rv = s;
        end

        function [iCCT, dist_uv] = myCCT(~, s)
            [iCCT, dist_uv, ok, errmsg]  = CCT(s);
            if ~ok
                error('IES_TM30.Evaluate: Cannot compute CCT: %s',errmsg);
            end
            if abs(dist_uv) > 0.05
                warning('IES_TM30.Evaluate: CCT |duv| > 0.05: %g',dist_uv);
            end
        end

        function rv = Scale_to_Y10_100(~,s)
            xyz10 = CIE1964_XYZ(s);
            s.val = s.val * 100 / xyz10.Y;
            s.XYZ1964 = CIE1964_XYZ(s);
            rv = s;
        end

        function rv = ReferenceSource(obj,iCCT)
            lam_ref = obj.IES_TM30_spectra_(:,1);
            if iCCT <= 4000
                s_ref = PlanckSpectrum(lam_ref, iCCT);
            elseif iCCT >= 5000
                s_ref = CIE_Illuminant_D(iCCT, 'lam', lam_ref);
            else
                s_Planck = obj.Scale_to_Y10_100( PlanckSpectrum(lam_ref, iCCT));
                s_CIE_D = obj.Scale_to_Y10_100( CIE_Illuminant_D(iCCT, 'lam', lam_ref));
                u = (5000 - iCCT) / 1000;
                s_ref = AddWeightedSpectra({s_Planck, s_CIE_D},[u, 1-u]);
            end
            rv = obj.Scale_to_Y10_100(s_ref);
            rv.name = sprintf('IES TM30 reference spectrum at CCT = %g',iCCT);
        end

        function [CES_XYZ_s, CES_XYZ_s_ref] = GetCES_XYZ(obj, s, s_ref)
            %CES_XYZ_s = struct(); % 1 x 1 empty
            %CES_XYZ_s_ref = struct();
            nCES = 99;
            for i = 1:nCES
                iCES = MakeSpectrumDirect(obj.IES_TM30_spectra_(:,1), obj.IES_TM30_spectra_(:, i+1));
                CES_XYZ_s(i) = CIE1964_XYZ(MultiplySpectra(s, iCES)); %#ok<AGROW>
                CES_XYZ_s_ref(i) = CIE1964_XYZ(MultiplySpectra(s_ref, iCES)); %#ok<AGROW>
            end
        end

        function Jab = CIECAM02(~, s_XYZ, CES_XYZ_s)
            % Y_b = 20;
            % F = 1;
            N_c = 1;
            c = 0.69;
            L_A = 100;
            % D = 1;
            k = 1 / (5 * L_A + 1); % 0.0020;
            F_L = 1/5 * k^4 * (5 * L_A) + 1/10 * (1-k^4)^2 * (5 * L_A)^(1/3); % 0.7937;
            n = 0.2000;
            N_bb = 0.75 * n^(-0.2); %1.0003;
            N_cb = N_bb;
            z = 1.48 + sqrt(n); %1.9272
            nCES = 99;
            M_CAT02 = [  0.7328, 0.4296, -0.1624;
                -0.7036, 1.6975,  0.0061;
                0.0030, 0.0136,  0.9834];
            inv_M_CAT02 = inv(M_CAT02);
            iRGB_w = M_CAT02 * [s_XYZ.X; s_XYZ.Y; s_XYZ.Z];
            RGB_w = repmat(iRGB_w,1,nCES);
            %     RGB = M_CAT02 * XYZ_10,
            %         M_CAT02 from Eq (30)
            RGB = nan(3,nCES);
            for i = 1:nCES
                iCES_XYZ = CES_XYZ_s(i);
                RGB(:,i) = M_CAT02 * [iCES_XYZ.X; iCES_XYZ.Y; iCES_XYZ.Z];
            end
            %     RGB_C = 100 ./ RGB_w .* RGB
            RGB_C = 100 * RGB ./ RGB_w;
            RGB_C_w = 100 * RGB_w ./ RGB_w;
            %     RGBprime = M_HPE * inv(M_CAT02) * RGB_C,
            %         M_HPE from Eq(35)
            M_HPE = [ 0.38971, 0.68898, -0.07868;
                -0.22981, 1.18340,  0.04641;
                0.00000, 0.00000,  1.00000];
            RGB_prime = (M_HPE * inv_M_CAT02) * RGB_C; %#ok<MINV>
            RGB_prime_w = (M_HPE * inv_M_CAT02) * RGB_C_w; %#ok<MINV>
            %     RGB_a_prime = f(RGBprime)
            %         f defined in Eq(36,37,38)
            tmpRGB = (F_L * RGB_prime / 100).^0.42;
            RGB_a_prime = 0.1 + (400 * tmpRGB) ./ (27.13 + tmpRGB);
            tmpRGB_w = (F_L * RGB_prime_w / 100).^0.42;
            RGB_a_prime_w = 0.1 + (400 * tmpRGB_w) ./ (27.13 + tmpRGB_w);
            %     a,b = func(RGA_a_prime)
            %         func defined in Eq (39,40)
            R_a_prime = RGB_a_prime(1,:);
            G_a_prime = RGB_a_prime(2,:);
            B_a_prime = RGB_a_prime(3,:);
            a = R_a_prime - 12/11 * G_a_prime + 1/11 * B_a_prime;
            b = 1/9 * (R_a_prime + G_a_prime - 2 * B_a_prime);
            R_a_prime_w = RGB_a_prime_w(1,:);
            G_a_prime_w = RGB_a_prime_w(2,:);
            B_a_prime_w = RGB_a_prime_w(3,:);
            % a_w = R_a_prime_w - 12/11 * G_a_prime_w + 1/11 * B_a_prime_w;
            % b_w = 1/9 * (R_a_prime_w + G_a_prime_w - 2 * B_a_prime_w);
            %     Lightness J, chroma C, colorfulness M
            %         according to Eq 41-47
            A = (2 * R_a_prime + G_a_prime + 1/20 * B_a_prime - 0.305) * N_bb;
            A_w = (2 * R_a_prime_w + G_a_prime_w + 1/20 * B_a_prime_w - 0.305) * N_bb;

            J = 100 * (A ./ A_w) .^(c * z);
            h_rad = atan2(b,a);
            e_t = 1/4 * (cos(h_rad + 2) + 3.8);
            t = 50000 / 13 * N_cb * N_c * ((e_t .* sqrt(a.^2 + b.^2)) ./ (R_a_prime + G_a_prime + 21/20 * B_a_prime));
            C = t.^0.9 .* sqrt(J/100) * (1.64 - 0.29^n)^0.73;
            M = C * F_L^0.25;
            %     CAM02-UCS coordinates Jprime, aprime, bprime
            %         according to Eq 48-51
            M_prime = (1 / 0.0228) * log(1 + 0.0228 * M);
            Jab.J_prime = ((1 + 100 * 0.007) * J) ./ (1 + 0.007 * J);
            Jab.a_prime = M_prime .* cos(h_rad);
            Jab.b_prime = M_prime .* sin(h_rad);
        end

        function rv = Jab_binned(obj, Jab) % hue angle bins
            % 4.3 Hue-angle bins
            %     Put all 99 aprime bprime values for CES_i from reference into 16 angle bins
            %     Put all 99 aprime bprime values for CES_i from test into the same corresponding bins
            %     Compute average aprime bprime values for all 16 bins, both for ref and test
            % compute hue angles -> [-pi;pi] based on reference spectrum
            angle = atan2(obj.Jab_s_ref_.b_prime, obj.Jab_s_ref_.a_prime);
            % map to [0; 2*pi]
            angle(angle < 0) = angle(angle < 0) + 2 * pi;
            angle(angle >= 2 * pi) = angle(angle >= 2 * pi) - 2 * pi;
            % compute bins for each of the 99
            nbins = 16;
            bin = 1 + floor(angle * nbins / (2*pi));
            if max(bin) > nbins || min(bin) < 1
                error('max(bin) > %s || min(bin) < 1: this cannot happen',nbins);
            end
            % compute mean values for each bin
            rv.J_prime = nan(1,nbins);
            rv.a_prime = nan(1,nbins);
            rv.b_prime = nan(1,nbins);
            rv.h = angle;
            rv.bin = bin;
            for i =1:nbins
                rv.J_prime(i) = mean(Jab.J_prime(bin == i));
                rv.a_prime(i) = mean(Jab.a_prime(bin == i));
                rv.b_prime(i) = mean(Jab.b_prime(bin == i));
            end
        end

    end


end