function rv = iJMO_Spectrum_root()
    % return the root folder of the spectrum library
    test = which('iJMO_Spectrum_root.m');
    if isempty(test)
        error('iJMO_Spectrum_root: JMO Spectrum root directory not in search path');
    end
    [rv,~,~] = fileparts(test);
end