%% MatchWhiteLEDSpectrum
% 
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp; 
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp;
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp; 
% <a href="GroupedList.html"> Grouped list</a>
% </p>
% </html>
%
% documentation to be completed
%

function rv = MatchWhiteLEDSpectrum(spec, XYZ_target)
    
    % abbreviations
    xt = XYZ_target.x;
    yt = XYZ_target.y;
    xyt = [xt, yt];
    Yt = XYZ_target.Y;
    
    % find near 480nm minimum
    lam_overlap = 450:500;
    spec_overlap = ResampleSpectrum(spec, lam_overlap);
    [~,imin] = min(spec_overlap.val);
    lam_min = lam_overlap(imin);
    % split spectrum there with tanh weight, sigma = 10 nm
    sig = 10;
    ww = 0.5 * (1 + tanh( (spec.lam - lam_min) / sig ));
    ww( (1-ww) < 1e-4) = 1;
    ww( ww < 1e-4) = 0;
    iww = 1 - ww;
    
    blue = MakeSpectrumDirect(spec.lam, spec.val .* iww, 'XYZ', true);
    yellow = MakeSpectrumDirect(spec.lam, spec.val .* ww, 'XYZ', true);
    
    testshift = @(dlam) TestShift(dlam, blue, yellow, xyt);
    dlam_max = 10;
    if testshift(dlam_max) * testshift(-dlam_max) >= 0
        error('MatchWhiteLEDSpectrum: shift more than 10 nm needed');
    end
    % bracket established -- find shift to bring target between blue and yellow
    [dlam, fb, nfe, ok, msg]= FindRoot1D(testshift, -dlam_max, dlam_max);
    blue_shifted = MakeSpectrumDirect(blue.lam + dlam,  blue.val, 'XYZ',true);
    yellow_shifted = MakeSpectrumDirect(yellow.lam - dlam,  yellow.val, 'XYZ',true);
    
    % compute weights
    blue_dist = norm([blue_shifted.XYZ.x, blue_shifted.XYZ.y] - xyt);
    yellow_dist = norm([yellow_shifted.XYZ.x, yellow_shifted.XYZ.y] - xyt);
    
    yfac1 = blue_dist * blue_shifted.XYZ.cw / (yellow_dist * yellow_shifted.XYZ.cw);
    fac2 = Yt / (blue_shifted.XYZ.Y + yfac1 * yellow_shifted.XYZ.Y);
    
    blue_shifted = MakeSpectrumDirect(blue_shifted.lam, blue_shifted.val * fac2, 'XYZ',true);
    yellow_shifted = MakeSpectrumDirect(yellow_shifted.lam, yellow_shifted.val * yfac1 * fac2, 'XYZ',true);
    
    matched_white = AddSpectra(blue_shifted, yellow_shifted);
    % test
    matched_white.XYZ = CIE1931_XYZ(matched_white);
    dY = matched_white.XYZ.Y - Yt;
    dxy = [matched_white.XYZ.x, matched_white.XYZ.y] - xyt;
    
    rv.spec = matched_white;
    rv.blue = blue_shifted;
    rv.yellow = yellow_shifted;
    rv.target = XYZ_target;
end

function rv = TestShift(dlam, blue, yellow, xyt)
    b = CIE1931_XYZ(struct('lam',blue.lam + dlam, 'val', blue.val));
    y = CIE1931_XYZ(struct('lam',yellow.lam - dlam, 'val', yellow.val));
    cross2 =@(lhs, rhs) lhs(1) * rhs(2) - lhs(2) * rhs(1);
    rv = cross2([y.x,y.y] - [b.x, b.y], xyt - [b.x, b.y]); %
end
