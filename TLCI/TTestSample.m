classdef TTestSample
    % TTestSample is class for TLCI test samples
    % A TTestSample knows its name and reflectivity, 
    % and knows how to reflect a spectrum
    properties
        name
        description
        spec % lam, val fiels
    end
    
    methods
        
        function obj = TTestSample(name, description, lam, val)
            % construct TTestSample
            % name: string
            % description : string
            % lam: ascending double array
            % val: reflectivity array of same length
            if nargin > 0
                obj.name = name;
                obj.description = description;
                obj.spec.lam = lam;
                obj.spec.val = val;
            else % default constructor
                obj.name = 'default TTestSample';
                obj.description = 'default TTestSample';
                obj.spec.lam = [360 830];
                obj.spec.val = [1 1];
            end
        end
        
        function rv = ReflectedSpectrum( obj, spec)
            % compute reflected spectrum by multiplication
            % input: spec with lam and val
            % output: rv with lam and val
            % check if lams are equal then just multiply
            % else do it the long way
            if isequal(obj.spec.lam, spec.lam)
                rv = obj.ReflectedSpectrumDirect( spec);
            else
                rv = MultiplySpectra(obj.spec, spec);
            end
        end
        
        function rv = ReflectedSpectrumDirect( obj, spec ) 
            % compute reflected spectrum by multiplication
            % input: spec with lam and val
            % output: rv with lam and val
            % assume that spec.lam is the same as obj.val
            % just multiply.
            rv.lam = obj.spec.lam;
            rv.val = obj.spec.val .* spec.val;
        end
    end
end

