%% SpectrumSanityCheck
% 
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp; 
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp;
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp; 
% <a href="GroupedList.html"> Grouped list</a>
% Source code: <a href = "file:../SpectrumSanityCheck.m"> SpectrumSanityCheck.m</a>
% </p>
% </html>
%
% Performs various checks to see if a spectrum complies with the <docDesignDecisions.html requirements>, 
% returns a sanitized spectrum when possible 
%% Syntax
% |[ok, msg, rv] = SpectrumSanityCheck(spec, varargin)|
%
%% Input Arguments
% * |spec|: a struct. 
% * |varargin|: Name-Value pairs
%
% <html>
% <p style="margin-left: 25px">
% <table border=1>
% <tr><td> <b>Name</b>    </td> <td>  <b>Type</b>     </td> <td><b>Value</b>     </td> <td><b>Meaning</b>                              </td></tr>
% <tr><td> 'doThrow'       </td> <td> logical scalar   </td> <td> true (default) </td> <td> When true, an error is thrown on failure. When false, a message is returned</td></tr>
% <tr><td> 'doStrip'       </td> <td> logical scalar   </td> <td> false (default) </td> <td> When true, the returned spectrum has only fields 'lam' and 'val'</td></tr>
% </table>
% </p>
% </html>
%
%% Output Arguments
% * |ok|: scalar logical. True when  |spec| conforms to the requirements.
% * |msg|: character string. Diagnostic message. Empty when there are no complaints.
% * |rv|: A valid spectrum struct.
%% Algorithm
% Checks if
%
% * the struct |spec| has fields |lam| and |val|, which must both be vectors of double
% * the lengths of |lam| and |val| are the same, and both are all finite reals
% * |lam| is all positive and strictly ascending
% 
% When ok, returns a copy of |spec|, with |lam| and |val| being column vectors. Optionally
% strips all other fields. When not ok, throws an error, or optionally returns a message and 
%% See also
% <docDesignDecisions.html Requirements>, <MakeSpectrum.html MakeSpectrum>, <MakeSpectrumDirect.html MakeSpectrumDirect>, 
%% Usage Example
% <include>Examples/ExampleSpectrumSanityCheck.m</include>

% publish with publishWithStandardExample('filename.m') in PublishDocumentation.m

% JMO Spectrum Library, 2021. See https://github.com/JuliusMuschaweck/JMO_Spectrum
% I dedicate the JMO_Spectrum library to the public domain under Creative Commons Zero 
% (https://creativecommons.org/publicdomain/zero/1.0/legalcode)
%
%
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
    msg = check( isfield(spec,'lam'), [], 'expect field lam');
    msg = check( isfield(spec,'val'), msg, 'expect field val');
    if isempty(msg)
        msg = check( isvector(spec.lam), msg, 'lam must be vector');
        msg = check( isvector(spec.val), msg, 'val must be vector');
    end
    if ~isempty(msg)
        ok = false;
        rv = [];
        return;
    end
    nn = length(spec.lam);
    if isempty(msg)
        msg = check( nn > 1, msg, 'length of lam must be >= 2 (no line spectra)');
        msg = check( numel(spec.lam) == numel(spec.val), msg, 'lam / val must be same size');
        msg = check( isreal(spec.lam), msg, 'lam must be real');
        msg = check( all(isfinite(spec.lam)), msg, 'lam must be finite');
        msg = check( isreal(spec.val), msg, 'val must be real');
        msg = check( all(isfinite(spec.val)), msg, 'val must be finite');
    end
    if isempty(msg)
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
        else 
            rv = MakeSpectrumDirect(spec.lam, spec.lam);
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