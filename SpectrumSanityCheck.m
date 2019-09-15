function [ok, msg, rv] = SpectrumSanityCheck(spec, varargin)	
% function [ok, msg, colspec] = SpectrumSanityCheck(spec, varargin)
% expect .lam and .val fields, both numeric col vectors of same length > 1
% lam > 0 and strictly ascending
% if 'doThrow',true (default true) call error else return ok = false, msg,
% colspec = [];
% if 'doStrip',true (default false) return only .lam and .val fiels,
% if all ok then msg = [], rv contains same fields as spec but lam
% and val will be column vectors
    p = inputParser;
    addParameter(p, 'doThrow', true, @islogical);
    addParameter(p, 'doStrip', false, @islogical);
    parse(p,varargin{:});
    msg = [];
    msg = check( isfield(spec,'lam'), msg, 'expect field lam');
    msg = check( isfield(spec,'val'), msg, 'expect field val');
    if isempty(msg)
        msg = check( isvector(spec.lam), msg, 'lam must be vector');
        msg = check( isvector(spec.val), msg, 'val must be vector');
    end
    nn = length(spec.lam);
    if isempty(msg)
        msg = check( isreal(spec.lam), msg, 'lam must be real');
        msg = check( sum(isfinite(spec.lam)) == nn, msg, 'lam must be finite');
        msg = check( isreal(spec.val), msg, 'val must be real');
        msg = check( sum(isfinite(spec.val)) == nn, msg, 'val must be finite');
    end
    if isempty(msg)
        msg = check( size(spec.lam) == size(spec.val), msg, 'lam / val must be same size');
        msg = check( sum(spec.lam <= 0) == 0, msg, 'lam must be positive');
        msg = check( isAscending(spec.lam), msg, 'lam must be strictly ascending');
    end
    ok = isempty(msg);
    if ~ok && p.Results.doThrow
        error(['SpectrumSanityCheck: ',msg]);
    end
    if ok
        if ~(p.Results.doStrip)
            rv = spec;
        end
        nn = length(spec.lam);
        rv.lam = reshape(spec.lam,nn,1);
        rv.val = reshape(spec.val,nn,1);
    else
        rv = [];
    end
end

function rv = isAscending(arr)
    lhs = arr(2:end);
    rhs = arr(1:(end-1));
    rv = (sum(lhs<=rhs) == 0);
end

function rv = check(condition, msg, errmsg)
    rv = msg;
    if ~condition
        if isempty(rv)
            rv = errmsg;
        else
            rv = [rv,', ',errmsg];
        end
    end
end