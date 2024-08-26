%% CIEData
%
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp;
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp;
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp;
% <a href="GroupedList.html"> Grouped list</a> &nbsp; | &nbsp; 
% Source code: <a href = "file:../CIEData.m"> CIEData.m</a>
% </p>
% </html>
%
% The CIEData class provides official CIE data from <https://cie.co.at/data-tables>. Each dataset at this website is
% given as a .csv file with an array of numbers, and a .json file with metadata. This class provides all spectra in the
% official CIE dataset ready to use in this library.
%% Syntax
% * Constructor: |rv = CIEData()|
%% Properties
% * |CIE_Database_|: Read-only. Array of 35 structs with individual CIE datasets. Each struct has fields |Values| (the .csv file content, 
% a 2D array of double, where the first column is almost always wavelength in nm), |Metadata| (the .json file content, a struct with 
% much additional information), |ShortName| (a short name assigned by me, to be used for lookup), and |ColumnHeaders| (a
% dictionary with the column header name as key, and the column index as value). This dataset is read from |CIE_Database.mat|, 
% which was constructed (|Create_CIE_Database.m|) from the 35 .csv and associated .json files downloaded from
% <https://cie.co.at/data-tables>. In |Create_CIE_Database.m|, the .csv content was succesfully verified against the md5 checksums,
% the sum of columns and the sample row data provided in the .json files. (Note: As of 2024-08-20, there is an error in
% the CIE sum of columns data for standard illuminant A; CIE has been notified to correct this).

%% Methods
% * |function rv = DataList(obj)|: An overview which items are in this collection
% *Output Arguments*: |rv|: A table with 35 rows and three columns: |ShortName|, a string copied from the |ShortName| field of
% the |CIE_Database_| property; |Description|, a string copied from the |descriptions.description| field of the metadata
% struct; and |ColumnHeaders|, a string containing all column headers names. Use the output of this function to see
% which exact names can be used in the following functions.
%
% <html>
% <p style="margin-left: 25px">
% <table border=1>
% <tr><td> <b>ShortName</b> </td> <td><b>Description</b></td>  <td><b>ColumnHeaders</b></tr>
% <tr><td> L41 </td> <td>Relative spectral power distribution of the CIE reference spectrum L41, wavelength range: 360 nm to 830 nm, wavelength increment: 1 nm, original source: CIE 251:2023 Table 1</td>  <td>lam, L41</td></tr>
% <tr><td> A-opic_action </td> <td>Alpha-opic action spectra describing the ability of optical radiation to stimulate each of the five photoreceptor types that can contribute, via the melanopsin-containing intrinsically-photosensitive retinal ganglion cells (ipRGCs), to retina-mediated non-visual effects of light in humans, wavelength range: 380 nm to 780 nm, wavelength increment: 1 nm, original source: CIE S026:2018, Table 2</td>  <td>lam, s_sc, s_mc, s_lc, s_rh, s_mel</td></tr>
% <tr><td> CIE1931_border </td> <td>Loci in a chromaticity diagram of points that represent monochromatic stimuli, CIE 1931, 2-degree observer, wavelength range: 360 nm to 830 nm, wavelength increment: 1 nm, original source: CIE 018:2019, Table 6.</td>  <td>lam, x, y, z</td></tr>
% <tr><td> CIE1964_border </td> <td>Loci in a chromaticity diagram of points that represent monochromatic stimuli, CIE 1964, 10 degree observer, wavelength range: 360 nm to 830 nm, wavelength increment: 1 nm, original source: ISO/CIE 11664-1:2019, Table 2</td>  <td>lam, x10, y10, z10</td></tr>
% <tr><td> ConeFundamental_10deg_Vlambda </td> <td>CIE cone-fundamental-based spectral luminous efficiency function for 10° field size in terms of energy, wavelength range: 390 nm to 830 nm, wavelength increment: 1 nm. To convert from terms of energy to terms of quanta, multiply by 1/lambda and renormalize, original source: CIE 170-2:2015, Table 10.4</td>  <td>lam, Vlambda_F10</td></tr>
% <tr><td> ConeFundamental_2deg_Vlambda </td> <td>CIE cone-fundamental-based spectral luminous efficiency function for 2° field size in terms of energy, wavelength range: 390 nm to 830 nm, wavelength increment: 1 nm. To convert from terms of enerty to terms of quanta, multiply by 1/lambda and renormalize, original source: CIE 170-2:2015, Table 10.2</td>  <td>lam, Vlambda_F2</td></tr>
% <tr><td> ConeFundamental_10deg_xyz </td> <td>CIE cone-fundamental-based spectral tristimulus values for 10°field size, wavelength range: 390 nm to 830 nm, wavelength increment: 1 nm, original source: CIE 170-2:2015, Table 10.8 (x_F,10_bar, y_F,10_bar, z_F,10_bar)</td>  <td>lam, x10, y10, z10</td></tr>
% <tr><td> ConeFundamental_2deg_xyz </td> <td>CIE cone-fundamental-based spectral tristimulus values for 2°field size, wavelength range: 390 nm to 830 nm, wavelength increment: 1 nm, original source: CIE 170-2:2015, Table 10.7a</td>  <td>lam, x, y, z</td></tr>
% <tr><td> C </td> <td>Relative spectral power distributions of CIE illuminant C, wavelength range: 380 nm to 780 nm, wavelength increment: 5 nm, original source: CIE 015:2018 table 5</td>  <td>lam, C</td></tr>
% <tr><td> D55 </td> <td>Relative spectral power distributions of CIE illuminant D55, wavelength range: 380 nm to 780 nm, wavelength increment: 5 nm, original source: CIE 015:2018 table 5</td>  <td>lam, D55</td></tr>
% <tr><td> D75 </td> <td>Relative spectral power distributions of CIE illuminant D75, wavelength range: 380 nm to 780 nm, wavelength increment: 5 nm, original source: CIE 015:2018 table 5</td>  <td>lam, D75</td></tr>
% <tr><td> Dxx </td> <td>Components S_0(lambda), S_1(lambda), S_2(lambda) of the relative spectral distribution of daylight used in the calculation of relative spectral power distributions of CIE daylight illuminants of different correlated colour temperatures, wavelength range: 360 nm to 830 nm, wavelength increment: 1 nm, original source: CIE 015:2018 Table 6</td>  <td>lam, S0, S1, S2</td></tr>
% <tr><td> FLs_5nm </td> <td>Relative spectral power distributions of illuminants representing typical fluorescent lamps, wavelength range: 380 nm to 780 nm, wavelength increment: 5 nm, original source: CIE 015:2018 table 10.1, 10.2, 10.3</td>  <td>lam, FL1, FL2, FL3, FL4, FL5, FL6, FL7, FL8, FL9, FL10, FL11, FL12, FL3.1, FL3.2, FL3.3, FL3.4, FL3.5, FL3.6, FL3.7, FL3.8, FL3.9, FL3.10, FL3.11, FL3.12, FL3.13, FL3.14, FL3.15</td></tr>
% <tr><td> FLs_1nm </td> <td>Relative spectral power distributions of illuminants representing typical fluorescent lamps, wavelength range: 380 nm to 780 nm, wavelength increment: 1 nm, original source: CIE 015:2018 table 10.1, 10.2, 10.3</td>  <td>lam, FL1, FL2, FL3, FL4, FL5, FL6, FL7, FL8, FL9, FL10, FL11, FL12, FL3.1, FL3.2, FL3.3, FL3.4, FL3.5, FL3.6, FL3.7, FL3.8, FL3.9, FL3.10, FL3.11, FL3.12, FL3.13, FL3.14, FL3.15</td></tr>
% <tr><td> HPs </td> <td>Relative spectral power distributions of high pressure discharge lamp illuminants, wavelength range: 380 nm to 780 nm, wavelength increment: 5 nm, original source: CIE 015:2018 table 11</td>  <td>lam, HP1, HP2, HP3, HP4, HP5</td></tr>
% <tr><td> ID50 </td> <td>Relative spectral power distribution of the daylight indoor illuminant ID50, wavelength range: 380 nm to 780 nm, wavelength increment: 5 nm, original source: CIE 184:2009 Table 2</td>  <td>lam, ID50</td></tr>
% <tr><td> ID65 </td> <td>Relative spectral power distribution of the daylight indoor illuminant ID65, wavelength range: 380 nm to 780 nm, wavelength increment: 5 nm, original source: CIE 184:2009 table 2</td>  <td>lam, ID65</td></tr>
% <tr><td> LEDs_5nm </td> <td>Relative spectral power distributions of illuminants representing typical LED lamps, wavelength range: 380 nm to 780 nm, wavelength increment: 5 nm, original source: CIE 015:2018 table 12.1/12.2</td>  <td>lam, LED-B1, LED-B2, LED-B3, LED-B4, LED-B5, LED-BH1, LED-RGB1, LED-V1, LED-V2</td></tr>
% <tr><td> LEDs_1nm </td> <td>Relative spectral power distributions of illuminants representing typical LED lamps, wavelength range: 380 nm to 780 nm, wavelength increment: 1 nm, original source: CIE 015:2018 table 12.1/12.2 (excel sheet associated with the publication)</td>  <td>lam, LED-B1, LED-B2, LED-B3, LED-B4, LED-B5, LED-BH1, LED-RGB1, LED-V1, LED-V2</td></tr>
% <tr><td> ConeFundamentals_10deg </td> <td>CIE 2006 LMS cone fundamentals for 10° field size in terms of energy, wavelength range: 390 nm to 830 nm, wavelength increment: 5 nm, original source: CIE 170-1:2006 table 6.2</td>  <td>lam, l10, m10, s10</td></tr>
% <tr><td> ConeFundamentals_2deg </td> <td>CIE 2006 LMS cone fundamentals for 2° field size in terms of energy, wavelength range: 390 nm to 830 nm, wavelength increment: 5 nm, original source: CIE 170-1:2006 table 6.7</td>  <td>lam, l, m, s</td></tr>
% <tr><td> Max_SLE_mesopic </td> <td>Values of maximum luminous efficacy for mesopic vision, K_m,mes;m at varied adaptation coefficient values m (for other m values use Eq. (8) of CIE 018:2019), original source: CIE 018:2019, Table 4</td>  <td>m, K_m</td></tr>
% <tr><td> Vlambda_10deg </td> <td>Values of spectral luminous efficiency for 10° photopic vision, V10(lambda), lambda in standard air, original source: CIE 018:2019, Table 5</td>  <td>lam, Vlambda_10</td></tr>
% <tr><td> Vlambda_mesopic_08 </td> <td>Values of spectral luminous efficiency for mesopic vision, at adaptation coefficient m = 0.8, (i.e. Vmes;0,8(lambda)) as an example,  (for other m values use Eq. (2) of CIE 018:2019), wavelength range: 360 nm to 830 nm, wavelength increment: 1 nm, original source: CIE 018:2019, Table 3.</td>  <td>lam, Vlambda_mesopic_08</td></tr>
% <tr><td> Vlambda </td> <td>Values of spectral luminous efficiency for photopic vision, V(lambda), lambda in standard air, wavelength range: 360 nm to 830 nm, wavelength increment: 1 nm, original source: CIE 018:2019, Table 1</td>  <td>lam, Vlambda</td></tr>
% <tr><td> Vprime_lambda </td> <td>Values of spectral luminous efficiency for scotopic vision, V_prime(lambda), lambda in standard air, wavelength range: 360 nm to 830 nm, wavelength increment: 1 nm, original source: CIE 018:2019, Table 2</td>  <td>lam, Vprime_lambda</td></tr>
% <tr><td> MacLeod_Boynton_lms </td> <td>CIE spectral MacLeod-Boynton chromaticity coordinates for 2° field size, wavelength range: 390 nm to 830 nm, wavelength increment: 5 nm, original source: CIE 170-2:2015, Table 10.5</td>  <td>lam, l_MB, m_MB, s_MB</td></tr>
% <tr><td> CIE224_Refl_5nm </td> <td>Spectral radiance factors of 99 test samples for the CIE colour fidelity index calculation,  wavelength range: 380 nm to 780 nm, wavelength increment: 5 nm, original source: CIE 224:2017 Table A.1 to A1.10</td>  <td>lam, R1, R2, R3, R4, R5, R6, R7, R8, R9, R10, R11, R12, R13, R14, R15, R16, R17, R18, R19, R20, R21, R22, R23, R24, R25, R26, R27, R28, R29, R30, R31, R32, R33, R34, R35, R36, R37, R38, R39, R40, R41, R42, R43, R44, R45, R46, R47, R48, R49, R50, R51, R52, R53, R54, R55, R56, R57, R58, R59, R60, R61, R62, R63, R64, R65, R66, R67, R68, R69, R70, R71, R72, R73, R74, R75, R76, R77, R78, R79, R80, R81, R82, R83, R84, R85, R86, R87, R88, R89, R90, R91, R92, R93, R94, R95, R96, R97, R98, R99</td></tr>
% <tr><td> CIE224_Refl_1nm </td> <td>Spectral radiance factors of 99 test samples for the CIE colour fidelity index calculation, wavelength range: 380 nm to 780 nm, wavelength increment: 1 nm, original source: CIE 224:2017 toolbox (CIE 2017 Colour Fidelity Index Calculator 1 nm - V.3(2017-07-15).xlsx)</td>  <td>lam, R1, R2, R3, R4, R5, R6, R7, R8, R9, R10, R11, R12, R13, R14, R15, R16, R17, R18, R19, R20, R21, R22, R23, R24, R25, R26, R27, R28, R29, R30, R31, R32, R33, R34, R35, R36, R37, R38, R39, R40, R41, R42, R43, R44, R45, R46, R47, R48, R49, R50, R51, R52, R53, R54, R55, R56, R57, R58, R59, R60, R61, R62, R63, R64, R65, R66, R67, R68, R69, R70, R71, R72, R73, R74, R75, R76, R77, R78, R79, R80, R81, R82, R83, R84, R85, R86, R87, R88, R89, R90, R91, R92, R93, R94, R95, R96, R97, R98, R99</td></tr>
% <tr><td> CRI_Refl </td> <td>Spectral radiance factors of 14 test samples for the CIE colour rendering index calculation, for the general colour rendering index calculation the first 8 samples are used,  wavelength range: 360 nm to 830 nm, wavelength increment: 5 nm, original source: CIE 13.3:1995 Table 1 and 2.</td>  <td>lam, R1, R2, R3, R4, R5, R6, R7, R8, R9, R10, R11, R12, R13, R14</td></tr>
% <tr><td> A </td> <td>CIE standard illuminant A. The values are calculated using equation 1 of  ISO/CIE 11664-2:2022, rounded to 6 digits, wavelength range: 300 nm to 830 nm, wavelength increment: 1 nm,original source:  ISO/CIE 11664-2:2022 Table A.1</td>  <td>lam, A</td></tr>
% <tr><td> D50 </td> <td>CIE standard illuminant D50, wavelength range: 300 nm to 830 nm, wavelength increment: 1 nm, original source: ISO/CIE 11664-2:2022, Table B.1</td>  <td>lam, D50</td></tr>
% <tr><td> D65 </td> <td>CIE standard illuminant D65, 1 nm wavelength steps, original source: ISO/CIE 11664-2:2022, Table B.1</td>  <td>lam, D65</td></tr>
% <tr><td> CIE1931_xyz </td> <td>CIE 1931 colour-matching functions (x_bar, y_bar, z_bar), 2 degree observer, wavelength range: 360 nm to 830 nm, wavelength increment: 1 nm, original source: CIE 018:2019, Table 6.</td>  <td>lam, x, y, z</td></tr>
% <tr><td> CIE1964_xyz </td> <td>CIE 1964 colour-matching functions (x_bar_10, y_bar_10, z_bar_10), 10 degree observer, wavelength range: 360 nm to 830 nm, wavelength increment: 1 nm, original source: ISO/CIE 11664-1:2019, Table 2.</td>  <td>lam, x10, y10, z10</td></tr>
% </table></p>
% <ul> <!-- function list -->
%   <hr>
%   <li><tt>function rv = Column_by_Idx(obj, shortName, columnIdx, opts)</tt>:
%       &ensp; Retrieves one column of numbers from the database, namely the <tt>columnIdx</tt>'th column from the
%       dataset <tt>shortName</tt>.
%       <ul> 
%           <li> <b>Input arguments:</b>
%               <ul>
%                   <li><tt>shortName</tt>: A string with the short name of the desired dataset. </li>
%                   <li><tt>columnIdx</tt>: An integer ranging from 1 to the number of columns in the dataset. 
%                           In most cases, <tt>columnIdx==1</tt> corresponds to the wavelength.</li>
%                   <li><tt>opts.zero_NaN</tt>: Logical scalar, default <tt>true</tt>; when true, 
%                           <tt>NaN</tt> values in the column are replaced by zeros. </li>
%               </ul>
%           </li>
%           <li> <b>Output arguments</b>:
%               <ul>
%                   <li> <tt>rv</tt>: A n x 1 array of double, the values from the desired column of the desired dataset.</li>
%               </ul>
%           </li>
%       </ul> <!-- I/O arguments -->
%   </li> <!-- function Column_by_Idx-->
%   <hr>
%   <li><tt> function rv = Column_by_Header(obj, shortNa
% me, columnHeader, opts)</tt>:
%       &ensp; Retrieves one column of numbers from the database, namely the column with header <tt>columnHeader</tt> from the
%       dataset <tt>shortName</tt>.
%       <ul> 
%           <li> <b>Input arguments:</b>
%               <ul>
%                   <li><tt>shortName</tt>: A string with the short name of the desired dataset. </li>
%                   <li><tt>columnHeader</tt>: A string with the desired column header.</li>
%                   <li><tt>opts.zero_NaN</tt>: Logical scalar, default <tt>true</tt>; when true, 
%                           <tt>NaN</tt> values in the column are replaced by zeros. </li>
%               </ul>
%           </li>
%           <li> <b>Output arguments</b>:
%               <ul>
%                   <li> <tt>rv</tt>: A n x 1 array of double, the values from the desired column of the desired dataset.</li>
%               </ul>
%           </li>
%       </ul> <!-- I/O arguments -->
%   </li> <!-- function Column_by_Header-->
%   <hr>
%   <li><tt>function rv = Spectrum(obj, shortName, opts)</tt>:
%       &ensp; For a single desired spectrum, retrieves the wavelength and value data from the database, and creates a
%       valid spectrum struct. Many entries have more than one spectrum (e.g. the x, y, z color matching functions are
%       combined in one entry); for such spectra, the desired spectrum is selected by column header, or by column index.
%       <ul> 
%           <li> <b>Input arguments:</b>
%               <ul>
%                   <li><tt>shortName</tt>: A string with the short name of the desired dataset. </li>
%                   <li><tt>opts.valueIdx</tt>: Numeric scalar, denotes the desired value column in case there is more
%                   than one. Must be a positive integer, no larger than the number of value columns.
%                       Note that this value index is one less than the corresponding column index in routine 
%                       <tt>Column_by_Idx</tt>, because the first data column is always the wavelength.</li>
%                   <li><tt>opts.columnHeader</tt></li> String,  the column header of the desired column. 
%               </ul>
%               If there is more than one value column, then exactly one of <tt>opts.valueIdx</tt> and
%               <tt>opts.columnHeader</tt> must be supplied.
%           </li>
%           <li> <b>Output arguments</b>:
%               <ul>
%                   <li> <tt>rv</tt>: A valid spectrum, with the usual fields <tt>val</tt>, <tt>lam</tt>, 
%                       and fields <tt>name</tt>, <tt>description</tt>, and <tt>dataSource</tt>.</li>
%               </ul>
%           </li>
%       </ul> <!-- I/O arguments -->
%   </li><!-- function Spectrum-->
%   <hr>
%   <li><tt>function rv = Entry(obj, shortName)</tt>:
%       &ensp; A low level function to retrieve a single entry from the database, as a struct containing the raw value
%       array, the metadata struct, the short name and the column headers. <b>Input argument:</b> The short name of the
%       entry to be retrieved. Consult the output of <tt>DataList</tt> to find the short name for the desired entry.
%   </li><!-- function Entry-->
% </ul> <!-- function list -->
% </html>
% 
%% Algorithm
% The original official data from the CIE website (<https://cie.co.at/data-tables>, total of 35 .csv files and 35 corresponding .json files)
% was used to create the library-internal database stored in |CIE_Database.mat|, essentially a direct copy of the CIE data, with a short name 
% assigned to each database entry. To avoid repeated loading of the database, a static class property would have been
% used in languages like C++. However, Matlab has no static class properties. Therefore, we use a static method with a
% persistent variable. Read-only copies of large variables are cheap in Matlab due to copy-on-write (a copy of a
% variable is just essentially a pointer at first; only when the copy is modified, the actual content is copied).
% To facilitate and speed up data access based on strings (short names for entries, and column header names instead of
% integer indices), Matlab dictionaries are used to translate the strings (as keys) to the actual integer array indices (as
% values). An additional property of the CIE values is the presence of NaN's: When a database entry contains multiple
% value arrays for the same wavelength array, then, in some cases, there is no data for part of the wavelength range; an
% example is found in the short wavelength receptor data in |"ConeFundamentals_2deg"|. However, a spectrum in the
% context of this library cannot have NaN values. We therefore replace NaN's with 0's by default when necessary, but
% optionally allow to keep the NaN's when desired for whatever reason.
%% See also
% <CIE1931_Data.html CIE1931_Data>, <CIE1931_XYZ.html CIE1931_XYZ>, <CIE1964_Data.html CIE1964_Data>, 
% <CIE1964_XYZ.html CIE1964_XYZ>, <CIE_Illuminant.html CIE_Illuminant>, <CIE_Illuminant_D.html CIE_Illuminant_D>, 
% <CIE_S_026_Data.html CIE_S_026_Data>, <CRI.html CRI>
%% Usage Example
% <include>Examples/ExampleCIEData.m</include>

% publish with publishWithStandardExample('filename.m') in PublishDocumentation.m

% JMO Spectrum Library, 2021. See https://github.com/JuliusMuschaweck/JMO_Spectrum
% I dedicate the JMO_Spectrum library to the public domain under Creative Commons Zero
% (https://creativecommons.org/publicdomain/zero/1.0/legalcode)

classdef CIEData < handle
    properties (GetAccess = public, SetAccess = private)
        CIE_Database_ % read from CIE_Database.mat file
        % array of struct, each with fields Values Metadata ShortName ColumnHeaders
    end

    methods
        % Constructor
        function obj = CIEData()
            obj.CIE_Database_ = CIEData.GetCIE_Database();
            datalist = obj.DataList();
            shortnames = table2array(datalist(:,1));
            obj.shortNameDictionary_ = dictionary(shortnames, (1:length(shortnames))');
        end
        
        % Query which CIE data items are in this collection
        function rv = DataList(obj)
            % returns a table with fields "ShortName" and "Description"
            % e.g. row 33: "D65", ...
            %      "CIE standard illuminant D65, 1 nm wavelength steps, ...
            %       original source: ISO/CIE 11664-2:2022, Table B.1"
            n = length(obj.CIE_Database_);
            rv = table('Size',[n,3],'VariableNames',{'ShortName','Description','ColumnHeaders'},...
                'VariableTypes',{'string','string','string'});
            for i = 1:n
                ii = obj.CIE_Database_(i);
                rv.ShortName(i) = ii.ShortName;
                rv.Description(i) = ii.Metadata.descriptions.description;
                tmp = ii.ColumnHeaders.keys;
                nch = length(tmp);
                cheads = "";
                connect = "";
                for j = 1:nch
                    cheads = append( cheads, connect, tmp(j));
                    connect = ", ";
                end
                rv.ColumnHeaders(i) = cheads;
            end
        end

        % Generic function to retrieve one column array from the collection
        % For most entries, column 1 is wavelength, column 2 ... are values
        % with the exception of "Max_SLE_mesopic" where column 1 is mesopic m
        function rv = Column_by_Idx(obj, shortName, columnIdx, opts)
            % shortName: short name of entry
            % columnIdx: integer >= 1
            % opts.zero_NaN: When true, NaN values are replaced with zeros
            arguments
                obj
                shortName (1,1) string
                columnIdx (1,1) double
                opts.zero_NaN (1,1) logical = true;
            end
            entry = obj.Entry(shortName);
            if columnIdx> size(entry.Values,2)
                error("CIEData.Column: no such columnIdx (%g) in %s",columnIdx,shortName);
            end
            rv = entry.Values(:,columnIdx);
            if opts.zero_NaN
                rv( isnan(rv) ) = 0;
            end
        end

        function rv = Column_by_Header(obj, shortName, columnHeader, opts)
            % shortName: short name of entry
            % columnHeader: string, must be in dictionary
            % opts.zero_NaN: When true, NaN values are replaced with zeros
            arguments
                obj
                shortName (1,1) string
                columnHeader (1,1) string
                opts.zero_NaN (1,1) logical = true;
            end
            entry = obj.Entry(shortName);
            if ~entry.ColumnHeaders.isKey(columnHeader)
                error("CIEData.Column_by_header: no such header %s in entry %s",...
                    columnHeader, shortName);
            end
            columnIdx = entry.ColumnHeaders(columnHeader);
            rv = entry.Values(:,columnIdx);
            if opts.zero_NaN
                rv( isnan(rv) ) = 0;
            end
        end

        % Generic function to retrieve one spectrum struct from the collection
        % Some data items (e.g. xyz color matching functions) have 
        % more than one value array; use optional valueIdx to say which one
        function rv = Spectrum(obj, shortName, opts)
            % from entry <shortName>, retrieve a spectrum.
            % Not valid for "Max_SLE_mesopic", because that contains no spectra.
            % For entries with only one value column, retrieves that column,
            % For entries with more than one value column, the column must be specified
            % either by opts.valueIdx (1 to # of value columns)
            % or by opts.columnHeader, but not both.
            % Create a spectrum from it, with additional fields
            % 'name' (=shortName) and 'description' (=long description from metadata)
            % and 'dataSource' (=csv file name)
            % valueIdx: 1 .. # of value columns
            % When a value is NaN, that row is omitted from the spectrum
            arguments
                obj
                shortName (1,1) string
                opts.valueIdx (1,1) double = NaN
                opts.columnHeader (1,1) string = "";
            end
            if shortName == "Max_SLE_mesopic"
                error("CIEData.Spectrum: Max_SLE_mesopic is no spectrum");
            end
            entry = obj.Entry(shortName);
            lam = obj.Column_by_Idx(shortName, 1);
            nvals = size(entry.Values,2) - 1;
            ch = opts.columnHeader ~= "";
            vi = ~isnan(opts.valueIdx);
            if  nvals == 1
                if ch || vi
                    warning("CIEData.Spectrum: column specification is ignored for entry %s",shortName);
                end
                val = obj.Column_by_Idx(shortName, 2);
            else
                if ch
                    if vi
                        error("CIEData.Spectrum: Column cannot be specified by both valueIdx and columnHeader");
                    else
                        val = obj.Column_by_Header(shortName, opts.columnHeader, zero_NaN = false);
                    end
                else % no column header
                    if vi 
                        val = obj.Column_by_Idx(shortName, opts.valueIdx, zero_NaN = false);
                    else
                        error("CIEData.Spectrum: Column must be specified for entry %s, using either opts.ValueIdx or opts.columnHeader",shortName);
                    end
                end
            end
            valOk = ~isnan(val);
            val = val(valOk);
            lam = lam(valOk);
            rv = MakeSpectrum(lam, val);
            if nvals > 1
                if vi
                    rv.name = sprintf("%s (value column # %g)",shortName,opts.valueIdx);
                else
                    rv.name = sprintf("%s (value column %s)",shortName,opts.columnHeader);
                end
            else
                rv.name = shortName;
            end
            rv.description = entry.Metadata.descriptions.description;
            rv.dataSource = entry.Metadata.alternateIdentifiers.alternateIdentifier ...
                + " from https://cie.co.at/data-tables, retrieved Aug. 18, 2024";
        end        
        
        % Low level function to directly retrieve one CIE data object
        function rv = Entry(obj, shortName)
            % returns a struct with fields 
            %       "Values":   data array as read from CIE csv file
            %       "Metadata": struct with metadata, directly from CIE json file
            %       "ShortName": the same shortName
            % If shortName is not present in one of the entries: error
            if ~isKey(obj.shortNameDictionary_, shortName)
                error("CIEData.Entry: %s is not a known ShortName",shortName)
            end
            i = obj.shortNameDictionary_(shortName);
            rv = obj.CIE_Database_(i);
        end

    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    properties (Access = private)
        shortNameDictionary_ % key: shortName, value: index 1..35
                            % to retrieve entries based on short names
    end
    methods (Static, Access = private)
        % store the big object in a static property, one for all instances
        % which loads from file only the first time it's accessed in a Matlab session
        % Matlab doesn't directly have static properties like C++
        % but a persistent variable in a static method is doing the same
        % returns a 1x35 array of struct, each with fields 
        % Values (array, read from the CIE xxx.csv file)
        % Metadata (struct, translated from the CIE xxx.csv_metadata.json file)
        % ShortName (a short, unique descriptive name, assigned by me)
        function rv = GetCIE_Database()
            persistent data;
            if isempty(data)
                tmp = load("CIE_Database.mat","CIE_Database");
                data = tmp.CIE_Database;
            end
            rv = data;
        end
    end
end