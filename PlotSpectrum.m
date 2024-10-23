%% PlotSpectrum
% 
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp; 
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp;
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp; 
% <a href="GroupedList.html"> Grouped list</a> &nbsp; | &nbsp; 
% Source code: <a href = "file:../XXX.m"> XXX.m</a>
% </p>
% </html>
%
% Convenience function to avoid |plot(s.lam, s.val)|, and errors like |plot(good.lam, bad.val)|. Additional parameters are forwarded to |plot|.
%% Syntax
% |function PlotSpectrum(s, varargin)|
%
% |function PlotSpectrum(ax, s, varargin)|
%
%% Input Arguments
% * |s|: A valid spectrum (see <SpectrumSanityCheck.html SpectrumSanityCheck>)
% * |ax|: An Axes objct handle
% * |varargin|: Any other arguments
%
%% Output Arguments
% |p|: The Line object returned by |plot|
%% Algorithm
% |PlotSpectrum(s, varargin)| plots the spectrum |s| to the current axes, essentially calling |plot(s.lam,s.val,varargin{2:end}|, i.e.
% optional arguments are simply forwarded to |plot|.
%
% |PlotSpectrum(ax, s, varargin)| does the same, but plots to axes |ax|.
% 
% In addition, sets xlabel = "Wavelength (nm)";
%% See also
% Matlab |plot| for additional arguments
%% Usage Example
% <include>Examples/ExamplePlotSpectrum.m</include>

% publish with publishWithStandardExample('filename.m') in PublishDocumentation.m

% JMO Spectrum Library, 2022. See https://github.com/JuliusMuschaweck/JMO_Spectrum
% I dedicate the JMO_Spectrum library to the public domain under Creative Commons Zero 
% (https://creativecommons.org/publicdomain/zero/1.0/legalcode)
%

function p = PlotSpectrum(varargin)
    if nargin == 0
        error('PlotSpectrum: no argument given');
    end
    if nargin == 1
        s = varargin{1};
        argstart = 2;
        ax = gca;
    end
    if nargin >= 2
        if isa(varargin{1},'matlab.graphics.axis.Axes')
            ax = varargin{1};
            s = varargin{2};
            argstart = 3;
        else
            ax = gca;
            s = varargin{1};
            argstart = 2;
        end
    end

    if ~IsSpectrum(s)
        error('PlotSpectrum: no valid spectrum argument (class %s):\n %s',class(s),formattedDisplayText(s));
    end
    if nargin >= argstart
        p = plot(ax,s.lam,s.val,varargin{argstart:end});
    else
        p = plot(ax,s.lam,s.val);
    end
    xlabel(ax,"Wavelength (nm)");
end