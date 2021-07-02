classdef Spectrum < handle
    properties (GetAccess = public, SetAccess = private)
        lam_ (:,1) double %{mustBeReal, mustBeFinite, mustBePositive, mustBeStrictlyAscending}
        val_ (:,1) double % must have same length
        name_ (1,:) char = 'unnamed'
        description_ (1,:) char = 'unnamed spectrum'
        color_ (1,1) struct = struct('X', NaN, 'Y', NaN, 'Z', NaN, 'x', NaN, 'y', NaN,...
            'z', NaN, 'u', NaN, 'v', NaN, 'uprime', NaN, 'vprime', NaN, 'CCT', NaN, 'dist_uv_Planck', NaN,...
            'Ldom', NaN, 'purity', NaN)
        CRI_ (1,1) struct = struct() % fields Ra (double), Ri (1,16) double
        TLCI_ (1,1) struct = struct() % not yet implemented
    end
    properties
        userInfo_ (1,1) struct = struct() %
    end
    methods
        function obj = Spectrum( lam, val, opts )
            arguments
                lam (:,1) double {mustBeReal, mustBeFinite, mustBePositive, mustBeStrictlyAscending}
                val (:,1) double % must have same length
                opts.name (1,:) char = '';
                opts.description(1,:) char = '';
                opts.computeColor (1,1) logical = true;
            end
            if length(val) ~= length(lam)
                error('Spectrum constructor: lam (length %g) and val (length %g) must have same length',length(lam), length(val));
            end
            obj.lam_ = lam;
            obj.val_ = val;
        end
    end
end