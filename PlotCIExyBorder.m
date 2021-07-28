%% PlotCIExyBorder
% 
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp; 
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp;
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp; 
% <a href="GroupedList.html"> Grouped list</a> &nbsp; | &nbsp; 
% Source code: <a href = "file:../PlotCIExyBorder.m"> PlotCIExyBorder.m</a>
% </p>
% </html>
%
% Plot the CIE xy monochromatic border, with optional color fill and other options
%% Syntax
% |[ah, fh] = PlotCIExyBorder(varargin)|
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
% </table>
% </p>
% </html>
%

%% Output Arguments
% * |ah|: handle to axes where the border was plotted, to be used for further plotting of e.g. color coordinates
% * |fh|: handle to figure where the border was plotted, to be used for further plotting.

%% Algorithm
% Takes the monochromatic border values from the CIE standards and plots it, using the specified options.
%% See also
% <PlotCIEupvpBorder.html PlotCIEupvpBorder>, <CIE1931_Data.html, CIE1931_Data>
%% Usage Example
% <include>Examples/ExamplePlotCIExyBorder.m</include>

% publish with publishWithStandardExample('filename.m') in PublishDocumentation.m

% JMO Spectrum Library, 2021. See https://github.com/JuliusMuschaweck/JMO_Spectrum
% I dedicate the JMO_Spectrum library to the public domain under Creative Commons Zero 
% (https://creativecommons.org/publicdomain/zero/1.0/legalcode)
%
%
function [ah, fh] = PlotCIExyBorder(varargin)
    % Plots the CIE xy border "shoe" into a figure and returns the axes and figure handles for further plotting
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
    defaultTicks = [400, 430, 450:10:480, 485:5:520, 530:10:620, 640, 700];
    p.addParameter('Ticks',defaultTicks,@(x) isempty(x) || (isnumeric(x) && isvector(x)));
    p.addParameter('TickFontSize',6,@(x) isnumeric(x) && isscalar(x));
    p.addParameter('ColorFill',false,@islogical);
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
        load('RGBColorShoeImage.mat','rgbimg2');
        im = image([0 1],[1 0],flipud(rgbimg2));
        alph = 1 - (sum(flipud(rgbimg2),3) == 3); % set white to transparent
        im.AlphaData = alph;
        set(gca,'ydir','normal');
    end
    
    load('CIE1931_lam_x_y_z.mat','CIE1931XYZ');
    hold on;
    xb = CIE1931XYZ.xBorder;
    yb = CIE1931XYZ.yBorder;
    xb(end+1)=xb(1); % close loop
    yb(end+1)=yb(1);
    plot(ah,xb,yb,lspec,popts{:});
    if blank
        axis equal;
        grid on;
        if isempty(p.Results.Ticks)
            axis([0 0.8 0 0.9]);
        else
            axis([-0.05,0.9,-0.05,0.9]);
        end
        xlabel('CIE x');
        ylabel('CIE y');
        title('CIE xy border');
    end
    if ~isempty(p.Results.Ticks)
        [b,db] = border(p.Results.Ticks,CIE1931XYZ);
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

function ColorFillDemo()
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

function [xyb, dxyb] = border(lam, CIEXYZ)
    % for lam length n, return xyb border points, and local normal unit vectors outward
    ixb = interp1(CIEXYZ.lam, CIEXYZ.xBorder, lam);
    iyb = interp1(CIEXYZ.lam, CIEXYZ.yBorder, lam);
    xyb = cat(2,ixb(:),iyb(:));
    
    blam = [360, 410:10:600, 830];
    xblam = interp1(CIEXYZ.lam, CIEXYZ.xBorder, blam);
    yblam = interp1(CIEXYZ.lam, CIEXYZ.yBorder, blam);
    
    dxbint = ipp_deriv(pchip(blam, xblam));
    dybint = ipp_deriv(pchip(blam, yblam));
    
    % perpendicular outward
    dixb = - ppval(dybint,lam);
    diyb = ppval( dxbint, lam);
    idxblen = sqrt((dixb(:)).^2 + (diyb(:)).^2);
    dxyb = cat(2,dixb(:)./ idxblen ,diyb(:)./ idxblen);
end