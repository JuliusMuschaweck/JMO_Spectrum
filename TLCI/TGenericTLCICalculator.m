classdef TGenericTLCICalculator
    %
    properties
        testSamples
        whiteSample
        camera
        display
        referenceSpectrumGenerator
        singleColorDifferenceCalculator
        aggregateColorDifferenceCalculator
    end
    
    methods
        function obj = TGenericTLCICalculator(testSamples, whiteSample, camera, ...
                display, refSpecGen, singleCDC, aggregateCDC)
            %GenericTLCICalculator constructor.
            %Insert desired objects
            % testSamples: an array of TTestSample, e.g.
            %   ColorChecker(1:18) for TLCI
            % camera: a TCamera, e.g. a TTLCIStdCamera
            % display: a TDisplay, e.g. TTLCIDisplay
            % singleCDC: a TSingleColorDifferenceCalculator, e.g.
            %   a TCIEDE2000
            % aggregateCDC: a TAggregateColorDifferenceCalculator,
            %   e.g. a TTLCIColorDifferenceCalculator
            TestArguments(testSamples, camera, ...
                display, singleCDC, aggregateCDC);
            obj.testSamples = testSamples;
            obj.whiteSample = whiteSample;
            obj.camera = camera;
            obj.display = display;
            obj.referenceSpectrumGenerator = refSpecGen;
            obj.singleColorDifferenceCalculator = singleCDC;
            obj.aggregateColorDifferenceCalculator = aggregateCDC;
        end
        
        function [refXYZ, testXYZ, clipped, refSpectrum, testCCT, RGB_Cprime_test, RGB_Cprime_ref] = CalculateXYZ(obj,spectrum)
            nSamples = length(obj.testSamples);
            % compute XYZ for test spectrum and all samples
            obj.camera = DoWhiteBalance(obj,spectrum);
            testXYZ = NaN(3,nSamples);
            RGB_Cprime_test = NaN(3,nSamples);
            clipped.test = false(1,nSamples);
            for i = 1:nSamples
                sample = obj.testSamples(i);
                refl = sample.ReflectedSpectrum(spectrum);
                iRGB_Cprime = obj.camera.Response(refl);
                RGB_Cprime_test(:,i) = iRGB_Cprime.RGB;
                testXYZ(:,i) = obj.display.Response(iRGB_Cprime);
                clipped.test(i) = iRGB_Cprime.clipped;
            end
            % same for reference spectrum
            spectrum.XYZ = CIE1931_XYZ(spectrum);
            spectrum.CCT = CCT_from_xy(spectrum.XYZ.x, spectrum.XYZ.y);
            testCCT = spectrum.CCT;
            % refSpectrum = TLCIReferenceSpectrum(spectrum.CCT);
            refSpectrum = obj.referenceSpectrumGenerator.ReferenceSpectrum(spectrum);
            obj.camera = DoWhiteBalance(obj,refSpectrum);
            refXYZ = NaN(3,nSamples);
            clipped.ref = false(1,nSamples);
            RGB_Cprime_ref = NaN(3,nSamples);
            for i = 1:nSamples
                sample = obj.testSamples(i);
                refl = sample.ReflectedSpectrum(refSpectrum);
                iRGB_Cprime = obj.camera.Response(refl);
                RGB_Cprime_ref(:,i) = iRGB_Cprime.RGB;
                refXYZ(:,i) = obj.display.Response(iRGB_Cprime);
                clipped.test(i) = iRGB_Cprime.clipped;
            end
        end
        
        function rv = Goodness(obj,spectrum)
            [refXYZ, testXYZ, clipped, refSpectrum, testCCT, RGB_Cprime_test, RGB_Cprime_ref] = obj.CalculateXYZ(spectrum);
            nSamples = length(obj.testSamples);
            delta = zeros(1,nSamples);
            usable = false(1,nSamples);
            rv.XYZ_test = zeros(nSamples, 3);
            rv.XYZ_ref = zeros(nSamples,3);
            for i = 1:nSamples
                XYZ1 = struct('X',refXYZ(1,i),'Y',refXYZ(2,i),'Z',refXYZ(3,i));
                XYZ2 = struct('X',testXYZ(1,i),'Y',testXYZ(2,i),'Z',testXYZ(3,i));
                delta(i) = obj.singleColorDifferenceCalculator.Diff(XYZ1,XYZ2);
                rv.XYZ_test(i,:) = (testXYZ(:,i))';
                rv.XYZ_ref(i,:) = (refXYZ(:,i))';
                usable(i) = ~(clipped.test(i) || clipped.ref(i));
            end
            [Qa, Qi] = obj.aggregateColorDifferenceCalculator.Goodness(delta, usable);
            rv.Qa = Qa;
            rv.Qi = Qi;
            rv.dE = delta';
            
            rv.RGB_Cprime_ref = RGB_Cprime_ref';
            rv.RGB_Cprime_test = RGB_Cprime_test';
            rv.ref_spectrum = refSpectrum;
            rv.test_spectrum = spectrum;
            rv.CCT = testCCT;
        end
    end
end

function rv = DoWhiteBalance(obj,spectrum) % return camera
    lam = spectrum.lam;
    val = ones(size(lam));
    % as long as val is just 1.0 everywhere, the reflected spectrum
    % calculation is not needed. But maybe we want to switch to the
    % color checker 0.9 white, which is actually not constant 0.9
    % and according to Regine Krämer's comments, we do want that
    %white100 = TTestSample('White100', '100 % white', lam, val);
    %whiteSample = white100;
    reflected = obj.whiteSample.ReflectedSpectrum(spectrum);
    rv = obj.camera.WhiteBalance(reflected);
end

function TestArguments(testSamples, camera, ...
        display, singleCDC, aggregateCDC)
    test1 = @(condition,errmsg) iif(~(condition), ...
        @() error(['GenericTLCICalculator constructor: ', errmsg]));
    test1(isvector(testSamples), 'testSamples must be vector of TTestSample but is not a vector');
    testisa(testSamples,'TTestSample');
    testisa(camera,'TCamera');
    testisa(display,'TDisplay');
    testisa(singleCDC, 'TSingleColorDifferenceCalculator');
    testisa(aggregateCDC,'TAggregateColorDifferenceCalculator');
end

function testisa(var,type)
    if ~ isa(var,type)
        error(['GenericTLCICalculator constructor: ',inputname(1), ' must be a ',type]);
    end
end

function varargout = iif(varargin)
    
    % out = iif(conditions_actions)
    %
    % This is an inline form of "if", allowing one to use "if" as a function.
    % Generally, the form looks like:
    %
    % iif(<if this>,      <then that>, ...
    %     <else if this>, <then that>);
    %
    % That is, the odd inputs are treated as conditions and the even inputs are
    % treated as the actions to be performed. The action corresponding to the
    % first true condition is executed.
    %
    % For example, consider normalizing a vector, x.
    %
    % x_hat = iif(all(x == 0), @() x, ...
    %             true,        @() x/sqrt(sum(x.^2)))
    %
    % Consider writing an anonymous function to safely normalize x.
    %
    % safe_normalize = @(x) iif(all(x == 0), @() x, ...
    %                           true,        @() x/sqrt(sum(x.^2)));
    %
    % To avoid calculating *all* possible conditions before determing which
    % action to perform, the conditions can be expressed as anonymous functions
    % to execute. These will be executed in order until a condition returning
    % true is found. Here the same example as the above, with "@()" added
    % before each condition to prevent its execution until it's needed (and
    % skipping it altogether when it's not needed). This can be useful for
    % conditions that take a long time to evaluate. Note that this syntax is
    % likely slower than the above when the conditions are easy to execute.
    %
    % safe_normalize = @(x) iif(@() all(x == 0), @() x, ...
    %                           @() true,        @() x/sqrt(sum(x.^2)));
    %
    % See functional_programming_examples.m for more.
    %
    % Tucker McClure
    % Copyright 2013 The MathWorks, Inc.
    
    % The user of a single structure for conditions and actions is meant to
    % make it easy to call the function with "if left, then do right"
    % syntax like the example above.
    conditions = varargin(1:2:end);
    actions    = varargin(2:2:end);
    
    % The conditions mights be an array of true/false *or* a cell array of
    % function handles to call that should return true/false. Find the
    % first true one. If function handles, evaluate in order so only the
    % necessary conditions are evaluated.
    if isa(conditions{1}, 'function_handle')
        condition = recur(@(f, n) iif(conditions{n}(), @() n, ...
            true,            @() f(f, n+1)), 1);
    else
        condition = find([conditions{:}], 1, 'first');
    end
    
    % Perform the correct action.
    if ~isempty(condition)
        [varargout{1:nargout}] = actions{condition}();
    else
        [varargout{1:nargout}] = [];
    end
    
end