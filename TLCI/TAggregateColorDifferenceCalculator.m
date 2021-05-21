classdef TAggregateColorDifferenceCalculator
    % TAggregateColorDifferenceCalculator: abstract base class 
    % to evaluate what a set of color differences means
    methods (Abstract)
        [rv, Q] = Goodness( dca, usable ) % dca: Array of reals, color differences
    end
end

