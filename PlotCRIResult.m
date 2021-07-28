%% PlotCRIResult
% 
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp; 
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp;
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp; 
% <a href="GroupedList.html"> Grouped list</a> &nbsp; | &nbsp; 
% Source code: <a href = "file:../PlotCRIResult.m"> PlotCRIResult.m</a>
% </p>
% </html>
%
% Plots a chart to compare CRI colors between test and reference lamp
%% Syntax
% |[refspec, fh] = PlotCRIResult(lamp, opts)|
%% Input Arguments
% * |lamp|: scalar struct. A valid spectrum
% * |opts|: Name-Value pairs
%
% <html>
% <p style="margin-left: 25px">
% <table border=1>
% <tr><td> <b>Name</b>    </td> <td>  <b>Type</b>     </td> <td><b>Value</b>     </td> <td><b>Meaning</b>                              </td></tr>
% <tr><td> 'Figure'       </td> <td> figure handle or positive integer   </td> <td>  </td> <td> figure to plot into </td></tr>
% <tr><td> 'Title'        </td> <td> string           </td> <td> '' (default) </td> <td> title of figure </td></tr>
% <tr><td> 'Pos_x'        </td> <td> positive integer </td> <td> 10 (default) </td> <td> horizontal position of figure from left </td></tr>
% <tr><td> 'Pos_y'        </td> <td> positive integer </td> <td> 10 (default) </td> <td> vertical position of figure from bottom </td></tr>
% <tr><td> 'Width'        </td> <td> positive integer </td> <td> 980 (default) </td> <td> width of figure </td></tr>
% <tr><td> 'Height'       </td> <td> positive integer </td> <td> 980 (default) </td> <td> height of figure </td></tr>
% <tr><td> 'Position'     </td> <td> integer vector of length 4 </td> <td> [10 10 980 980] (default)</td> <td> full figure position (see Matlab figure documentation), overrides individual settings </td></tr>
% <tr><td> 'Background    </td> <td> double vector of length 3  </td> <td> [0.5 0.5 0.5] (default)</td> <td> background color (medium gray improves visibility) </td></tr>
% </table>
% </p>
% </html>
%
%% Output Arguments
% * |refspec|: the CRI reference spectrum
% * |fh|: the figure handle
%% Algorithm
% For the lamp spectrum and the reference spectrum, computes the reflected spectra (pairs) for 16 color samples (all 14 standardized CRI spectra,
% unofficial #15 (asian skin), and 100% perfect white). Determines sRGB values for all
% reflected spectra using <XYZ_to_sRGB.html XYZ_to_sRGB>. Creates a plot with 4 x 4 square
% color patches, where the outer frame / the inner square are the colors of the sample under
% the reference / test lamp. Writes additional information into the patches (name of sample,
% RGB values, individual Ri). Uses the optional figure parameters or their default values to
% set figure properties
%% See also
% <CRI.html CRI>, <XYZ_to_sRGB.html XYZ_to_sRGB>
%% Usage Example
% <include>Examples/ExamplePLotCRIResult.m</include>

% publish with publishWithStandardExample('filename.m') in PublishDocumentation.m

% JMO Spectrum Library, 2021. See https://github.com/JuliusMuschaweck/JMO_Spectrum
% I dedicate the JMO_Spectrum library to the public domain under Creative Commons Zero 
% (https://creativecommons.org/publicdomain/zero/1.0/legalcode)
%
%
function [refspec, fh] = PlotCRIResult(lamp, opts)
    arguments
        lamp (1,1) struct
        opts.Figure (1,1) = NaN % figure handle or integer
        opts.Title (:,1) char = ''
        opts.Pos_x (1,1) double = 10
        opts.Pos_y (1,1) double = 10
        opts.Width (1,1) double = 980
        opts.Height(1,1) double = 980
        opts.Position (1,4) double = [NaN NaN NaN NaN]
        opts.Background (1,3) double = [0.5 0.5 0.5];
    end
    load('CRISpectra.mat','CRISpectra');
    XYZ0 = CIE1931_XYZ(lamp);
    % rgb0 = XYZ_to_sRGB(XYZ0.X / XYZ0.Y, 1 , XYZ0.Z / XYZ0.Y, 'clip', true);
    % make a 1024 x 1024 RGB picture
    n = 1024;
    pic = ones(n, n, 3);
    % divided into 4x4 tiles for 16 color samples
    dn = n / 4;    
    % reference spectrum
    [cct, duv] = CCT(lamp);
    if duv > 0.05
        warning('lamp too far away from Planck, CCT = %g, d_uv = %g',cct, duv);
    end
    if cct < 5000
        refspec = PlanckSpectrum(360:830, cct);
    else
        refspec = CIE_Illuminant_D(cct);
    end
    refXYZ0 = CIE1931_XYZ(refspec);    
    % the loop to create the picture
    idx = 0;
    for i = 1:4 % row
        for j = 1:4 % column
            idx = idx + 1; % which CRI sample
            r0 = (i-1) * dn + 1; % upper left corner of tile
            c0 = (j-1) * dn + 1;
            s = CRISpectra(idx);
            % outer frame with reference color
            sref = MultiplySpectra(s, refspec); % the reflected spectrum
            XYZref = CIE1931_XYZ(sref);
            irgbref = XYZ_to_sRGB(XYZref.X / refXYZ0.Y, XYZref.Y / refXYZ0.Y, XYZref.Z / refXYZ0.Y, 'clip', true); % and its sRGB values
            cri_rgb_ref{i,j} = irgbref.RGB; %#ok<AGROW>
            for ii = 1:3 % assign to the tile
                pic(r0:(r0+dn),c0:(c0+dn),ii) = irgbref.RGB(ii);
            end
            % inner square with lamp color
            sr = MultiplySpectra(s, lamp); % the reflected spectrum
            XYZ = CIE1931_XYZ(sr);
            irgb = XYZ_to_sRGB(XYZ.X / XYZ0.Y, XYZ.Y / XYZ0.Y, XYZ.Z / XYZ0.Y, 'clip', true); % and its sRGB values
            cri_rgb{i,j} = irgb.RGB; %#ok<AGROW>
            for ii = 1:3 % assign to the tile
                pic((r0+dn/4):(r0+3*dn/4),(c0+dn/4):(c0+3*dn/4),ii) = irgb.RGB(ii);
            end
        end
    end
    
    % show the result
    if isnan(opts.Figure)
        fh = figure();
    elseif isgraphics(opts.Figure,'figure')
        fh = opts.Figure;
    elseif isnumeric(opts.Figure) && opts.Figure > 0 && opts.Figure == int32(opts.Figure)
        fh = figure(opts.Figure);        
    else 
        error('PlotCRIResult: ''figure'' optional argument must be figure handle or scalar positive integer');
    end
    if isnan(opts.Position(1))
        set(fh,'Position', [opts.Pos_x, opts.Pos_y, opts.Width, opts.Height]);
    else
        set(fh,'Position', opts.Position);
    end
    set(fh,'Color', opts.Background);
    clf;
    imagesc(pic);
    axis equal;
    axis off;
    hold on;
    idx = 0;
    cri = CRI;
    icri = cri.FullCRI(lamp);
    for i = 1:4
        for j = 1:4
            idx = idx + 1;
            s = CRISpectra(idx);
            r0 = (i-1) * dn + 1;
            c0 = (j-1) * dn + 1;
            irgb = cri_rgb{i,j};
            irgbref = cri_rgb_ref{i,j};
            text(c0+dn/2, r0+dn/2,sprintf('%s',s.name), 'HorizontalAlignment','center',  'VerticalAlignment','middle','FontSize',20);
            text(c0+dn/2, r0+dn/2 + 30,sprintf('%s', s.description), 'HorizontalAlignment','center',  'VerticalAlignment','middle');
            text(c0+dn/2, r0+dn/2 + 55,sprintf('lamp RGB: [%0.3f,%0.3f,%0.3f]', irgb(1), irgb(2), irgb(3)), 'HorizontalAlignment','center',  'VerticalAlignment','middle');
            text(c0+dn/2, r0+dn/2 + 80,sprintf('ref. RGB: [%0.3f,%0.3f,%0.3f]', irgbref(1), irgbref(2), irgbref(3)), 'HorizontalAlignment','center',  'VerticalAlignment','middle');
            text(c0+dn/2, r0+dn/2 + 105,sprintf('R%g = %0.1f', idx, icri.Ri(idx)), 'HorizontalAlignment','center',  'VerticalAlignment','middle');
        end
    end
    title(sprintf('%s, Ra = %0.1f',opts.Title,icri.Ra));
end


