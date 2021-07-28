%% ComputeSpectrumColorimetry
% 
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp; 
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp;
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp; 
% <a href="GroupedList.html"> Grouped list</a> &nbsp; | &nbsp; 
% Source code: <a href = "file:../ComputeSpectrumColorimetry.m"> ComputeSpectrumColorimetry.m</a>
% </p>
% </html>
%
% For a given spectrum, computes a large selection of colorimetric properties
%% Syntax
% |rv = ComputeSpectrumColorimetry(spec, varargin)|
%% Input Arguments
% * |spec|: A valid spectrum. See <SpectrumSanityCheck.html SpectrumSanityCheck>
% * |varargin|: Name-Value pairs:
%
% <html>
% <p style="margin-left: 25px">
% <table border=1>
% <tr><td> <b>Name</b>    </td> <td>  <b>Type</b>     </td> <td><b>Value</b>     </td> <td><b>Meaning</b>                              </td></tr>
% <tr><td> 'Normalize'    </td> <td> character string </td> <td> 'off' (default) </td> <td> Ignore                                     </td></tr>
% <tr><td>                </td> <td>                  </td> <td> 'peak'          </td> <td> Normalize values to peak == 1 </td></tr>
% <tr><td> 'XYZn'         </td> <td> struct           </td> <td> Fields X, Y, Z  </td> <td> Reference white stimulus                   </td></tr>
% <tr><td> 'XYZn'         </td> <td> real vector, length 3 </td> <td> [X, Y, Z]  </td> <td> Reference white stimulus                   </td></tr>
% </table>
% </p>
% </html>
%
%% Output Arguments
% * |rv|: A spectrum: A copy of the original spectrum struct, with added fields
%
% <html>
% <p style="margin-left: 25px">
% <table border=1>
% <tr><td> <b>Name</b>    </td> <td>  <b>Type</b>     </td> <td> <b>Value</b>             </td> <td> <b>Meaning</b>                              </td></tr>
% <tr><td> 'XYZ'          </td> <td> struct           </td> <td> scalar real fields x, y, z, X, Y, Z  </td> <td> As returned from <a href="CIE1931_XYZ.html"> CIE1931_XYZ</a> </td></tr>
% <tr><td> 'x'            </td> <td> scalar real      </td> <td>                          </td> <td> CIE 1931 x (convenience for XYZ.x)  </td></tr>
% <tr><td> 'y'            </td> <td> scalar real      </td> <td>                          </td> <td> CIE 1931 y (convenience for XYZ.x)  </td></tr>
% <tr><td> 'u'            </td> <td> scalar real      </td> <td>                          </td> <td> CIE u = 4 * x / (-2*x + 12*y +3)  (see <a href="CIE_upvp.html"> CIE_upvp</a>) </td></tr>
% <tr><td> 'v'            </td> <td> scalar real      </td> <td>                          </td> <td> CIE v = 6 * y / (-2*x + 12*y +3)  </td></tr>
% <tr><td> 'up'           </td> <td> scalar real      </td> <td>                          </td> <td> CIE up = u = 4 * x / (-2*x + 12*y +3)  </td></tr>
% <tr><td> 'vp'           </td> <td> scalar real      </td> <td>                          </td> <td> CIE vp = 1.5 v = 9 * y / (-2*x + 12*y +3)  </td></tr>
% <tr><td> 'CCT'          </td> <td> scalar real      </td> <td>                          </td> <td> Correlated color temperature  </td></tr>
% <tr><td> 'dist_uv_Planck'</td> <td> scalar real     </td> <td>                          </td> <td> u,v Distance to Planck locus (see <a href="CCT.html"> CCT</a>) </td></tr>
% <tr><td> 'CRI_all'      </td> <td> struct           </td> <td> fields Ri (16x1 double) and Ra (double) </td> <td> All CRI values (see <a href="CRI.html"> CRI</a>) </td></tr>
% <tr><td> 'Ra'           </td> <td> scalar real      </td> <td>                          </td> <td> General CRI  </td></tr>
% <tr><td> 'Ldom'         </td> <td> scalar real      </td> <td>                          </td> <td> Dominant wavelength (see <a href="LDomPurity.html"> LDomPurity</a>) </td></tr>
% <tr><td> 'purity'       </td> <td> scalar real      </td> <td>                          </td> <td> Purity (see <a href="LDomPurity.html"> LDomPurity</a>) </td></tr>
% <tr><td> 'Lab'          </td> <td> struct           </td> <td> fields L, a, b           </td> <td> Only with optional XYZn input argument: CIELAB L*, a*, b* (see <a href="CIE_Lab.html"> CIE_Lab</a>) </td></tr>
% <tr><td> 'Luv'          </td> <td> struct           </td> <td> fields L, u, v           </td> <td> Only with optional XYZn input argument: CIELUV L*, u*, v* (see <a href="CIE_Luv.html"> CIE_Luv</a>) </td></tr>
% </table>
% </p>
% </html>
%
%% Algorithm
% Calls the various colorimetry functions and collects these values in the returned struct.
%% See also
% <CIE1931_XYZ.html CIE1931_XYZ>, <CIE_upvp.html CIE_upvp>, <CIE_Lab.html CIE_Lab>, <CIE_Luv.html CIE_Luv>, <CRI.html CRI>, <LDomPurity.html LDomPurity>, 
%% Usage Example
% <include>Examples/ExampleComputeSpectrumColorimetry.m</include>

% publish with publishWithStandardExample('filename.m') in PublishDocumentation.m

% JMO Spectrum Library, 2021. See https://github.com/JuliusMuschaweck/JMO_Spectrum
% I dedicate the JMO_Spectrum library to the public domain under Creative Commons Zero 
% (https://creativecommons.org/publicdomain/zero/1.0/legalcode)
%
function rv = ComputeSpectrumColorimetry(spec, varargin)
    % For input spectrum s, compute colorimetry information, return same spectrum with added fields
    % Parameters:
    %   s: spectrum, struct with fields lam and val
    %   varargin: Name/Value pairs
    %       'Normalize', 'peak' | 'off' (default) 
    %           Normalize -> 'peak' scales spectrum .val to have peak = 1
    %           Normalize -> 'off' leaves .val unchanged
    %       'XYZn': struct with fields X, Y; Z or (1,3) double, the diffuse white tristimulus value to be
    %       used in CIELAB and CIELUV
    % Computed and added fields are:
    %   XYZ: struct with fields x, y, z, X, Y, Z as returned from CIE1931_XYZ(s)
    %   x: convenience for XYZ.x
    %   y: convenience for XYZ.y
    %   u: CIE u = 4 * x / (-2*x + 12*y +3)
    %   v: CIE v = 6 * y / (-2*x + 12*y +3)
    %   up: CIE u = 4 * x / (-2*x + 12*y +3)
    %   vp: CIE v = 9 * y / (-2*x + 12*y +3)
    %   CCT, dist_uv_Planck: color temperature and distance to Planck locus
    %   CRI_all: struct with all 16 Ri and Ra
    %   Ra: number, general CRI value
    %   Ldom: Dominant wavelength
    %   purity: purity
    % When optional argument XYZn is present:
    %   Lab: struct with fields L, a, b: the CIELAB L*, a*, b* values
    %   Luv: struct with fields L, u, v: the CIELUV L*, u*, v* values
    persistent cri
    if isempty(cri)
        cri = CRI();
    end
    p = inputParser;
    p.addRequired('s');
    validateNormalize = @(str) strcmp(str,'peak') || strcmp(str,'off');
    p.addParameter('Normalize','off',validateNormalize);
    p.addParameter('XYZn',[NaN,NaN,NaN], @(rhs) (isstruct(rhs) && isfield(rhs,'X')) || (isvector(rhs) && isreal(rhs) && length(rhs)==3));
    parse(p, spec, varargin{:});
    rv = p.Results.s;
    if strcmp(p.Results.Normalize,'peak')
        rv.val = rv.val / max(rv.val); % normalize to max = 1;
    end
    rv.XYZ = CIE1931_XYZ(rv);
    rv.x = rv.XYZ.x;
    rv.y = rv.XYZ.y;
    den = -2*rv.x + 12*rv.y +3;
    rv.u = 4 * rv.x / den;
    rv.v = 6 * rv.y / den;
    rv.up = rv.u;
    rv.vp = rv.v * 1.5;
    [rv.CCT, rv.dist_uv_Planck, ok, ~] = CCT_from_xy(rv.XYZ.x, rv.XYZ.y);
    if ok
        rv.CRI_all = cri.FullCRI(rv);
        rv.Ra = rv.CRI_all.Ra;
    else
        rv.Ra = NaN;
        rv.CRI_all.Ra = NaN;
        rv.CRI_all.Ri = NaN(16,1);
    end
    [rv.Ldom, rv.purity] = LDomPurity(rv.XYZ);
    XYZn = p.Results.XYZn;
    if isstruct(XYZn)
        XYZn = [XYZn.X,XYZn.Y,XYZn.Z];
    end
    if ~isnan(XYZn(1)) % do CIELAB and CIELUV
        %         f(0)
        %         116 * f(0) - 16 % 0
        %         f((24/116)^3)
        %         f((24/116)^3 + eps) % same as previous
        %         f(1) % 1
        %         f(8) % 2
        XXn = rv.XYZ.X / XYZn(1);
        YYn = rv.XYZ.Y / XYZn(2);
        ZZn = rv.XYZ.Z / XYZn(3);
        cn = sum(XYZn);
        xn = XYZn(1) / cn;
        yn = XYZn(2) / cn;
        den_n = -2 * xn + 12 * yn + 3;
        upn = 4 * xn / den_n;
        vpn = 9 * yn / den_n;
        L = 116 * f(YYn) - 16;
        rv.Lab.L = L;
        rv.Lab.a = 500 * (f(XXn) - f(YYn));
        rv.Lab.b = 200 * (f(YYn) - f(ZZn));
        rv.Luv.L = L;
        rv.Luv.u = 13 * L * (rv.up - upn);
        rv.Luv.v = 13 * L * (rv.vp - vpn);
    end
end

function rv = f(rhs)
    thresh = (24/116)^3;
    if rhs > thresh
        rv = rhs ^ (1/3);
    else
        rv = 841 / 108 * rhs + 16 / 116;
    end
end