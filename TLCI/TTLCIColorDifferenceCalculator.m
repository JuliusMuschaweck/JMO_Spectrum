classdef TTLCIColorDifferenceCalculator < TAggregateColorDifferenceCalculator
    % TTLCIColorDifferenceCalculator
    properties
        p = 2.4;
        k = 3.16;
    end
    
    methods
        function [rv, Q] = Goodness(obj, dca, usable ) % dca: Array of reals, color differences
            if nargin > 2
                dca_usable = dca(usable);
            else
                dca_usable = dca;
            end
            dca4 = dca_usable .^ 4;
            dEa = (mean(dca4)) ^ 0.25;
            rv = 100 / (1 + (dEa / obj.k) ^ obj.p); 
            if nargout > 1
                n = length(dca);
                Q = zeros(n,1);
                for i = 1:n
                    Q(i) = 100 / (1 + (dca(i) / obj.k) ^ obj.p); 
                end
            end
        end
    end
end

