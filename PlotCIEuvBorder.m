%% PlotCIEuvBorder
% 
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp; 
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp;
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp; 
% <a href="GroupedList.html"> Grouped list</a> &nbsp; | &nbsp; 
% Source code: <a href = "file:../PlotCIEupvpBorder.m"> PlotCIEupvpBorder.m</a>
% </p>
% </html>
%
% Plot the CIE uv monochromatic border, with optional color fill and other options
%% Syntax
% |[ah, fh] = PlotCIEuvBorder(varargin)|
%% Input Arguments
% * |varargin|: Optional name-value pairs:
%
% <html>
% <p style="margin-left: 25px">
% <table border=1>
% <tr><td> <b>Name</b>    </td> <td>  <b>Type</b>     </td> <td><b>Value</b>     </td> <td><b>Meaning</b>                              </td></tr>
% <tr><td> 'Figure'       </td> <td> handle to figure </td> <td> empty (default) </td> <td> valid figure handle to use for the plot. Current hold state will be restored. When empty, plot into new figure</td></tr>
% <tr><td> 'Axes'         </td> <td> handle to axes   </td> <td> empty (default) </td> <td> valid axes handle to use for the plot. Current hold state will be restored. Overrides 'Figure'</td></tr>
% <tr><td> 'LineSpec'     </td> <td> string           </td> <td> 'k' (default) </td> <td> valid LineSpec string, e.g. '--b' for dashed blue lines, see 'plot' documentation </td></tr>
% <tr><td> 'PlotOptions'  </td> <td> cell array       </td> <td> empty (default) </td> <td> cell array of valid plot options e.g. {'Color',[0.5 0.5 0.5],'LineWidth',2}</td></tr>
% <tr><td> 'Ticks'        </td> <td> double vector    </td> <td> reasonable default </td> <td> array of wavelength values where ticks and labels are plotted. Say ...,'Ticks',[],... to suppress ticks</td></tr>
% <tr><td> 'TickFontSize' </td> <td> scalar double    </td> <td> 6 (default) </td> <td> Font size for ticks annotation, in points </td></tr>
% <tr><td> 'ColorFill'    </td> <td> scalar logical   </td> <td> false (default) </td> <td> When true, fill "shoe" with approximate colors </td></tr>
% <tr><td> 'Opacity'      </td> <td> scalar double    </td> <td> 1.0 (default) </td> <td> Opacity of ColorFill, 0 = fully transparent, 1 = fully opaque </td></tr>
% </table>
% </p>
% </html>
%

%% Output Arguments
% * |ah|: handle to axes where the border was plotted, to be used for further plotting of e.g. color coordinates
% * |fh|: handle to figure where the border was plotted, to be used for further plotting.

%% Algorithm
% Takes the monochromatic border values from the CIE xy standards, converts it to uv and plots it, using the specified options.
%% See also
% <PlotCIExyBorder.html PlotCIExyBorder>, <PlotCIEupvpBorder.html PlotCIEupvpBorder><CIE1931_Data.html, CIE1931_Data>
%% Usage Example
% <include>Examples/ExamplePlotCIEuvBorder.m</include>

% publish with publishWithStandardExample('filename.m') in PublishDocumentation.m

% JMO Spectrum Library, 2021. See https://github.com/JuliusMuschaweck/JMO_Spectrum
% I dedicate the JMO_Spectrum library to the public domain under Creative Commons Zero 
% (https://creativecommons.org/publicdomain/zero/1.0/legalcode)
%
%
function [ah, fh] = PlotCIEuvBorder(varargin)
    % Plots the CIE uv border "shoe" into a figure and returns the axes and figure handles for further plotting
    %
    % Parameters:
    %   varargin: Name/Value pairs:
    %       'Figure': valid figure handle to use for the plot. Current hold state will be restored
    %       'Axes'  : valid axes handle to use for the plot. Current hold state will be restored.
    %       Overrides 'Figure';
    %       'LineSpec' : valid LineSpec string, e.g. '--b' for dashed blue lines, see 'plot' documentation.
    %       'PlotOptions': cell array of valid plot options
    %                   e.g. {'Color',[0.5 0.5 0.5],'LineWidth',2}
    %       'Ticks' : array of wavelength values where ticks and labels are plotted. Reasonable default
    %                   Say ...,'Ticks',[],... to suppress ticks
    %       'TickFontSize': number, obvious use. Default: 6
    %       'ColorFill': logical, fills shoe with approximate RGB colors. Default: false
    p = inputParser;
    p.addParameter('Figure',[], @(h) ishandle(h) && strcmp(get(h,'type'),'figure'));
    p.addParameter('Axes',[], @(h) ishandle(h) && strcmp(get(h,'type'),'axes'));
    p.addParameter('LineSpec','k');
    p.addParameter('PlotOptions',{},@(c) iscell(c));
    defaultTicks = [400, 430, 450, 460, 465:5:520, 530:10:620, 640, 700];
    p.addParameter('Ticks',defaultTicks,@(x) isempty(x) || (isnumeric(x) && isvector(x)));
    p.addParameter('TickFontSize',6,@(x) isnumeric(x) && isscalar(x));
    p.addParameter('ColorFill',false,@islogical);
    p.addParameter('Opacity',1,@(x) isnumeric(x) && isscalar(x));
    parse(p,varargin{:});
    if isempty(p.Results.Axes)
        if isempty(p.Results.Figure)
            fh = figure();
            ah = axes;
            holdstate = true;
        else
            fh = p.Results.Figure;
            figure(fh);
            ah = gca;
            holdstate = ishold(ah);
        end
    else
        ah = p.Results.Axes;
        fh = ah.Parent;
        holdstate = ishold(ah);
    end
    lspec = p.Results.LineSpec;
    popts = p.Results.PlotOptions;
    blank = isempty(p.Results.Axes) && isempty(p.Results.Figure);
    
    if p.Results.ColorFill
        load('RGBColorShoeImage.mat','rgb_uv_img');
        im = image([0 1],[1 0],flipud(rgb_uv_img));
        alph = 1 - (sum(flipud(rgb_uv_img),3) >= 3); % set white to transparent
        im.AlphaData = alph * p.Results.Opacity;
        set(gca,'ydir','normal');
    end
    
    % 22.8.2024 now using official CIE data
    CIE1931XYZ = CIE1931_Data();
    % load('CIE1931_lam_x_y_z.mat','CIE1931XYZ');
    hold on;
    xb = CIE1931XYZ.xBorder;
    yb = CIE1931XYZ.yBorder;
    xb(end+1)=xb(1); % close loop
    yb(end+1)=yb(1);
    tmp = CIE_upvp(struct('x',xb, 'y',yb));
    ub = tmp.up;
    vb = tmp.vp * 2/3;
    plot(ah,ub,vb,lspec,popts{:});
    if blank
        axis equal;
        grid on;
        if isempty(p.Results.Ticks)
            axis([0 0.65 0 0.4]);
        else
            axis([-0.08,0.65,-0.05,0.45]);
        end
        xlabel('CIE u');
        ylabel('CIE v');
        title('CIE uv border');
    end
    if ~isempty(p.Results.Ticks)
        [b,db] = border(p.Results.Ticks,CIE1931XYZ,ub(1:(end-1)), vb(1:(end-1)));
        for i = 1:size(b,1)
            d = [-0.00,0.015];
            plot(b(i,1) + db(i,1) * d, b(i,2) + db(i,2) * d, p.Results.LineSpec);
            text(b(i,1) + 0.035 * db(i,1), b(i,2) + 0.035 * db(i,2),num2str(p.Results.Ticks(i)),...
                'HorizontalAlignment','center','FontSize',p.Results.TickFontSize);
        end
    end
    if ~holdstate
        hold(ah,'off');
    end
end

function ColorFillDemo() %#ok<DEFNU>
% % This snippet show how we can do color filling:
    figure();
    clf;
    hold on;
    img = imread('Berg.jpg');
    alpha = 0.5 * ones(size(img,1,2));
    alpha(100:1000,100:1000) = 0.2;
    alpha(1000:1800,100:1000) = 0.8;

    % Create a red octagon using the fill function.
    t = (1/16:1/8:1)'*2*pi;
    x = cos(t);
    y = sin(t);
    fill(x,y,'r');
    axis square;
    axis tight;
    % alpha can be anything -- set to 1 outside color shoe
    % we could do this pixel by pixel using LDom/purity, slow but available and we do it only once and save   
    % To get the fill color: Use Rec709 / sRGB to compute rgb within sRGB gamut, and continue with 
    % same color on lines from E to border when outside gamut. 
    imagesc([-1 1],[-1,1],flipud(img),'AlphaData',alpha);
    %imagesc([0 1],[0,1],flipud(img));
    plot([-1 1],[-1 1], 'LineWidth',3);
end

function [uvbb, dxyb] = border(lam, CIEXYZ, ub, vb)
    % for lam length n, return xyb border points, and local normal unit vectors outward
    iubb = interp1(CIEXYZ.lam, ub, lam);
    ivb = interp1(CIEXYZ.lam, vb, lam);
    uvbb = cat(2,iubb(:),ivb(:));
    
    blam = [360, 410:10:600, 830];
    ublam = interp1(CIEXYZ.lam, ub, blam);
    vblam = interp1(CIEXYZ.lam, vb, blam);
    
    dubint = ipp_deriv(pchip(blam, ublam));
    dvbint = ipp_deriv(pchip(blam, vblam));
    
    % perpendicular outward
    diub = - ppval(dvbint,lam);
    divb = ppval( dubint, lam);
    idublen = sqrt((diub(:)).^2 + (divb(:)).^2);
    dxyb = cat(2,diub(:)./ idublen ,divb(:)./ idublen);
end