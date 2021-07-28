%% OptimalAdditiveMix
% 
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp; 
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp;
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp; 
% <a href="GroupedList.html"> Grouped list</a> &nbsp; | &nbsp; 
% Source code: <a href = "file:../OptimalAdditiveMix.m"> OptimalAdditiveMix.m</a>
% </p>
% </html>
%
% documentation to be completed
%

% Input: 
% * a cell array of spectra
%     * min/max values for their contribution weights (default [0, Inf])
%         * when min = max value, it's considered a fixed contribution
%     * number of spectra to actually use (default Inf)
% * constraints:
%     * equality constraints (color point, luminous flux, CCT, weighted sum of spectral weights)
%     * inequality constraints (Ra > 90, lm/W > 200, distance to Planck)
% * a merit function
%     * weighted sum of individual contributions
%     * maximize luminous / radiant flux, Ra, Ri, lm/W
% * options
%     * algorithm 
%     * nfe max
%     * start point
%     * error handling
% 
% Output:
% * optimized additive mix spectrum
% * diagnostic information
%     

function rv = OptimalAdditiveMix( spectra, meritFunc, opts)
    arguments
        spectra (1,:) cell
        ~
        opts.equalityConstraints = {}
        opts.inequalityConstraints = {}
        opts
end