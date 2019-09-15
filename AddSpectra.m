function rv = AddSpectra(lhs, rhs)
% function rv = AddSpectra(lhs, rhs)
% input: lhs, rhs: spectra. i.e. struct with vector fields lam and val
% output: sum of both. 
    rv = AddWeightedSpectra([lhs rhs],[1 1]);
end