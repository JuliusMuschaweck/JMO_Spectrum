%% TrueRainbow
% 
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp; 
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp;
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp; 
% <a href="GroupedList.html"> Grouped list</a> &nbsp; | &nbsp; 
% Source code: <a href = "file:../XXX.m"> XXX.m</a>
% </p>
% </html>
%
% Computes an array of RGB values to display monochromatic rainbow colors on an sRGB monitor, as correctly as possible
% under gamut restrictions
%% Syntax
% |rv = TrueRainbow(opts)|
%
%% Input Arguments
% * |opts|: Optional Name-Value pairs
%
% <html>
% <p style="margin-left: 25px">
% <table border=1>
% <tr><td> <b>Name</b>      </td> <td>  <b>Type</b>         </td> <td><b>Value</b>        </td> <td><b>Meaning</b>                                                </td></tr>
% <tr><td> 'lam'            </td> <td> array of wavelengths </td> <td> 360:830 (default)  </td> <td> The wavelengths for which the RGB values shall be computed   </td></tr>
% <tr><td> 'showDiagnostics'</td> <td> logical scalar       </td> <td> false   (default)  </td> <td> When true, several informative plots are created             </td></tr>
% <tr><td> 'floor'          </td> <td> real scalar          </td> <td> 0.01    (default)  </td> <td> Lower threshold of linear RGB values to avoid black          </td></tr>
% </table>
% </p>
% </html>
%
%% Output Arguments
% * |rv|: struct with fields 
%
% |lam|: A copy of the input array of wavelength (length |n|). 
%
% |RGB|: A |n| by |3| array of RGB values between 0 and 1: The corresponding RGB values. 
%
% |RGBfunc|: A function handle with signature |rv = RGBfunc(lam)|; 
%     returns an |m| by |3| array to interpolate RGB values for other wavelengths. Extrapolation beyond the original
%     wavelength array returns black (|[0,0,0]|).
%
% |RainbowImageFunc|: A function handle with signature |rv = RainbowImageFunc(lam_query, horizontal, n_lines)|. Input:
%
% |lam_query|: An array of wavelengths. |horizontal|: Logical scalar. |n_lines|: the number of parallel rainbow pixel
% lines.
%
% |floor|: Real scalar, copy of input value |opts.floor|.

%% Algorithm
% Ideally, a rainbow on a sRGB display would look exactly like a real rainbow from sunlight. We want to precisely
% correlate colors with wavelength, and the apparent brightness distribution of the rainbow. This ideal cannot be
% reached: The color gamut is not sufficient, and the colors on the display will look less saturated than the real
% rainbow. Still, it is only saturation, not hue, that should be affected by the display.
%
% We proceed in the following steps:
%
% * We obtain the CIE xy monochromatic border color points as function of wavelengthm in 1 nm intervals from 360 nm to
% 830 nm.
%
% * We obtain the sRGB color gamut, i.e. the R, G, B primary color points
%
% * We define |E = [1/3, 1/3]| as the center point for color projection in the CIE xy color space.
%
% * If we would simply project the monochromatic border toward the center |E|, then we would have visible boundaries in
% the rainbow at the wavelengths corresponding to the gamut corners. We choose a somewhat smaller projected color locus,
% with rounded corners, but strictly inside the gamut triangle. We create this by first computing the mid points of the
% gamut triangle sides, and then defining three weighted, degree 2 Bezier splines (one for each corner), where for each
% spline we take center point - corner - center point as control points. This resulting triangle is G2 smooth
% (continuous tangent directions).
%
% * For each point on the monochromatic border, we compute the intersection point with the rounded projection gamut
% triangle, and obtain its |x|, |y|, and |z = 1 - x - z| color coordinates
%
% * Using the standard sRGB transformation matrix |M|, we transform |[x,y,z]| to linear |[r,g,b]| values.
%
% * Using the standard sRGB primary luminosities, we compute the luminance of each |[r,g,b]| triplet, and scale them
% such that they all have same luminance (constant brightness rainbow).
%
% * Two factors govern the actual luminance distribution of a rainbow: (i) the spectral distribution of sunlight, and
% (ii) the human eye sensitivity. We approximate the sunlight spectrum with a 5500 K blackbody spectrum (the actual
% solar spectrum doesn't look good here because of narrow absorption lines), and the human eye sensitivity is taken to
% follow V(lambda). We could now simply scale the equal luminance linear RGB values such that they follow the product of
% both functions (5500K spectrum times V(lambda)). However, there would be substantial deep red and deep blue tails
% which would be essentially black. We therefore scale this original weighted luminance |L| (nromalized to peak 1), 
% with a small |floor| value, such % that the resulting luminance value |L'| is given by |L' = (L + floor) / (1 +
% floor)|, mapping the interval |[0, 1]| to |[floor, 1]|. This way, the deep red and blue tails remain dark red and dark
% purple.
%
% * Finally, we apply the sRGB standard gamma function to map linear RGB values to sRGB values. At this stage, we have
% valid RGB values for the rainbow, from 360 nm to 830 nm, in 1 nm steps.
%
% * The return value is a struct with several fields.
%
% * The field |lam| is just a copy of the input wavelength array, of length |n|.
%
% * The field |RGB| is an array of size |n| by |3|, with linearly interpolated RGB values.
%
% * The field |floor| is just a copy of the input floor value (default 0.01).
%
% * The field |RGBfunc| is a function with sigbature |rv = RGBfunc(lam)| which allows to interpolate the rainbow RGB
% values to any set of wavelength values.
%
% * The field |RainbowImageFunc| is also a function, with signature |rv = RainbowImageFunc(lam_query, horizontal,
% n_lines)|. This function computes an RGB image (a |m| b< |n| by |3| array) which is an image of the rainbow. When the
% boolean flag |horizontal| is |false|, then the first dimension corresponds to the wavelengths |lam_query|. 
% The second dimension contains |n_lines| copies of the rainbow. The result is a rectangular rainbow image, where the
% wavelengths vary vertically, blue at the top. When |horizontal| is true, the first two dimensions are swapped, and the
% image is a horizonal rainbow.
%% See also
% <PlotHorizontalRainbow.html PlotHorizontalRainbow>, <PlotRainbowFilledSpectrum.html PlotRainbowFilledSpectrum>
%% Usage Example
% <include>Examples/ExampleTrueRainbow.m</include>

% publish with publishWithStandardExample('filename.m') in PublishDocumentation.m

% JMO Spectrum Library, 2021. See https://github.com/JuliusMuschaweck/JMO_Spectrum
% I dedicate the JMO_Spectrum library to the public domain under Creative Commons Zero 
% (https://creativecommons.org/publicdomain/zero/1.0/legalcode)
%

function rv = TrueRainbow(opts)
    arguments
        opts.lam = []; % 360:830
        opts.showDiagnostics = false;
        opts.floor = 0.01;
    end
    % obtain CIE border
    cie = CIE1931_Data();
    lam = cie.lam;
    xB = cie.xBorder;
    yB = cie.yBorder;
    
    % define white point for projection
    Ex = 1/3;
    Ey = 1/3;
    E = [Ex, Ey];

    % sRGB gamut
    R = [0.64, 0.30];
    G = [0.3, 0.6];
    B = [0.15, 0.06];
    % mid points of RGB triangle sides
    RB = 0.5 * (R+B);
    BG = 0.5 * (B+G);
    GR = 0.5 * (G+R);
    % RGB corner weights for spline.
    w_R = 5;
    w_G = 3.5;
    w_B = 2;

    R_spline = @(u) WeightedBezierSpline(GR, R, RB, w_R, u);
    G_spline = @(u) WeightedBezierSpline(BG, G, GR, w_G, u);
    B_spline = @(u) WeightedBezierSpline(RB, B, BG, w_B, u);


    n = length(lam);
    x = nan(1,n);
    y = nan(1,n);

    % dominant wavelengths of mid points
    lam_BG = LDomPurity(BG);
    lam_GR = LDomPurity(GR);    

    % project monochromatic CIE border to RGB spline
    % by numerical 1D root finding
    for i = 1 : length(lam)
        xyB = [xB(i), yB(i)];
        if lam(i) < lam_BG
            u = ProjectToBracketedSpline( B_spline, xyB);
            xy = B_spline(u);
        elseif lam(i) < lam_GR
            u = ProjectToBracketedSpline( G_spline, xyB);
            xy = G_spline(u);
        else 
            u = ProjectToBracketedSpline( R_spline, xyB);
            xy = R_spline(u);
        end
        x(i) = xy(1);
        y(i) = xy(2);
    end
    z = 1 - x - y;
    % the sRGB conversion matrix
    M = [ 3.2406255, -1.5372080, -0.4986286;
        -0.9689307,  1.8757561,  0.0415175;
        0.0557101, -0.2040211,  1.0569959];
    % linear RGB weights for the sRGB primaries
    RGBlin = [x(:),y(:),z(:)] * M'; % 3 x n
    % a couple spurious very slightly negative values set to zero
    RGBlin(RGBlin < 0) = 0;
    assert(all(RGBlin(:) >= 0));

    % the inverse sRGB conversion matrix
    M2 = [0.4124, 0.3576, 0.1805;
         0.2126, 0.7152, 0.0722;
         0.0193, 0.1192, 0.9505];
    % the relative luminance of each linear RGB value
    Y_lin = RGBlin * (M2(2,:))';

    % scale linear RGB to obtain equal luminance linear RGB values
    tmp = RGBlin ./ Y_lin;
    RGB_lin_equalY = tmp / max(tmp(:));

    % test = RGB_lin_equalY * (M2(2,:))';

    % apply the sRGB Gamma function to obtain equal luminance sRGB
    % only for demonstration/plotting purposes
    RGB_equalY = Gamma(RGB_lin_equalY);

    floor = opts.floor;

    vlam = cie.y;
    solar = PlanckSpectrum(lam, 5500);
    weight = solar.val .* vlam;
    weight = (weight + floor) / (1 + floor);
    tmp = RGB_lin_equalY .* weight;
    RGB_lin_vlam_Y = tmp / max(tmp(:));
    RGB_vlam_Y = Gamma(RGB_lin_vlam_Y);

    if isempty(opts.lam)
        rv.lam = lam;
        rv.RGB = RGB_vlam_Y;
    else
        rv.lam = opts.lam;
        tmp = InterpolRainbow(lam, RGB_vlam_Y, opts.lam);
        rv.RGB = tmp.RGB;
    end
    rv.RGBfunc = @(lam) InterpolRainbow(rv.lam, rv.RGB, lam);
    rv.RainbowImageFunc = @ (lam_query, horizontal, n_lines) RainbowImage(rv.lam, rv.RGB, lam_query, horizontal, n_lines);
    rv.floor = opts.floor;

    if opts.showDiagnostics
        ShowDiagnostics();
    end


    function X_C_prime = Gamma(X_B)
        X_C_prime = NaN(size(X_B));
        negative = (X_B < (-0.0031308));
        positive = (X_B > 0.0031308);
        small = ~(negative | positive);
        X_C_prime(small) = 323/25 * X_B(small);
        X_C_prime(positive) = (211 * X_B(positive).^(5/12) - 11) / 200 ;
        X_C_prime(negative) = - (211 * ((-X_B(negative)).^(5/12)) - 11) / 200 ;
    end    

    function u = ProjectToBracketedSpline( spline, xy)
        func = @(uu) CrossProductZero(xy, spline(uu));
        assert(func(0) * func(1) < 0, 'no bracket');
        u = FindRoot1D(func, 0, 1);
    end
    
    function rv = CrossProductZero(xy1, xy2) % shift to E = origin. positive if xy2 is counterclockwise from xy1
        d1 = xy1 - E;
        d2 = xy2 - E;
        rv = d1(1)*d2(2) - d1(2) * d2(1);
    end

    function ax = ShowDiagnostics()
        figure(2);
        clf;
        hold on;
        ax = PlotCIExyBorder('Figure',2);
        rr = R_spline(linspace(0,1,100));
        gg = G_spline(linspace(0,1,100));
        bb = B_spline(linspace(0,1,100));
        axis equal;
        axis([-0.05, 0.8,-0.05,0.9]);
        plot([R(1),G(1),B(1),R(1)], [R(2),G(2),B(2),R(2)],'k-o' );
        scatter(Ex,Ey,'kx')
        plot(ax, rr(:,1), rr(:,2),'r');
        plot(ax, gg(:,1), gg(:,2),'g');
        plot(ax, bb(:,1), bb(:,2),'b');
        title('CIE xy diagram with color coordinates of rainbow');

%         CrossProductZero([xB(1), yB(1)], R)
%         CrossProductZero([xB(1), yB(1)], G)
%         CrossProductZero([xB(1), yB(1)], B)

        tmp = ProjectToBracketedSpline(B_spline, [xB(1), yB(1)]);
        pp = B_spline(tmp);
        scatter(ax, pp(1), pp(2),'o');
        plot([xB(1),Ex], [yB(1),Ey],'b');

        scatter(x, y, '.');

        figure(3);
        clf;
        hold on;
        plot(lam, RGBlin(:,1),'r');
        plot(lam, RGBlin(:,2),'g');
        plot(lam, RGBlin(:,3),'b');
        title('raw RGB lin');

%         tmp = repmat(RGBlin',[1,1,10]);
%         RainbowPic = shiftdim(tmp,1);
%         figure(5);
%         imagesc(1:10,lam,RainbowPic);
%         title('raw RGB lin');
% 
%         tmp = repmat(RGB_lin_equalY',[1,1,10]);
%         RainbowPic = shiftdim(tmp,1);
%         figure(6);
%         imagesc(1:10,lam,RainbowPic);
%         title('equal Y RGB lin');

        tmp = repmat(RGB_equalY',[1,1,10]);
        RainbowPic = shiftdim(tmp,1);
        figure(7);
        imagesc(1:10,lam,RainbowPic);
        title('equal luminance RGB');

        tmp = repmat(RGB_vlam_Y',[1,1,10]);
        RainbowPic = shiftdim(tmp,1);
        figure(8);
        imagesc(1:10,lam,RainbowPic);
        title(sprintf('V(lambda) with 5500K Planck luminance weighted RGB, floor = %g',floor));

        ilam = 360:830;
        widelam = 300:900;
        % pl = PlanckSpectrum(widelam, 5600);
        pl = SolarSpectrum('AM15_GlobalTilt');
        pl = ResampleSpectrum(pl, widelam);
        
        figure(9);
        clf;
        hold on;
        plot(pl.lam, pl.val);
        title('AM 1.5 global tilt solar irradiance spectrum');
        im = RainbowImage(lam, RGB_vlam_Y, ilam, true, 2);
        lims = axis();
        ymin = lims(3);
        ymax = lims(4);
        ybotrel = -0.1;
        ytoprel = -0.05;
        ybot = ( 1 - ybotrel ) * ymin + ybotrel * ymax;
        ytop = ( 1 - ytoprel ) * ymin + ytoprel * ymax;
        image([ilam(1),ilam(end)], [ybot, ytop], im);
        axis([lims(1), lims(2), ybot, lims(4)]);

        figure(10);
        clf;
        im = RainbowImage(lam, RGB_vlam_Y, pl.lam, false, 1);
        plt = bar(pl.lam, pl.val,1,'LineStyle','none','EdgeColor','none','FaceColor','flat','CData',im);
        title('AM 1.5 global tilt solar irradiance spectrum');

        figure(11); 
        clf;
        hold on;
        r = TrueRainbow('floor', opts.floor);
        plot(r.lam, r.RGB(:,1),'r');
        plot(r.lam, r.RGB(:,2),'g');
        plot(r.lam, r.RGB(:,3),'b');
        title(sprintf('R,G,B values with floor = %g',r.floor));

        figure(12);
        peaks();
        rgb = r.RainbowImageFunc(420:670,false,1);
        colormap(rgb);
        colorbar;
        title('peaks() with true rainbow color map');
    end 
end

function rv = WeightedBezierSpline( p0, p1, p2, w1, uu)
    arguments
        p0 (1,2) double
        p1 (1,2) double
        p2 (1,2) double
        w1 (1,1) double
        uu (:,1) double
    end
    f0 = (1-uu).^2;
    f1 = 2 * w1 * (1-uu) .* uu;
    f2 = uu.^2;
    numer = f0 * p0 + f1 * p1 + f2 * p2;
    denom = f0 + f1 + f2;
    rv = numer ./ denom;
end

function rv = InterpolRainbow(lam, RGB, lam_query)
    rv.R = interp1(lam, RGB(:,1), lam_query(:), 'linear',0);
    rv.G = interp1(lam, RGB(:,2), lam_query(:), 'linear',0);
    rv.B = interp1(lam, RGB(:,3), lam_query(:), 'linear',0);
    rv.RGB = [rv.R(:), rv.G(:), rv.B(:)];
end

function rv = RainbowImage(lam, RGB, lam_query, horizontal, n_lines)
    tmp = InterpolRainbow(lam, RGB, lam_query);
    rgb = tmp.RGB;
    tmp = repmat(rgb',[1,1,n_lines+1]); % handle n_lines == 1
    tmp = tmp(:,:,1:n_lines);
    tmp = shiftdim(tmp,1);
    if horizontal 
        tmp = permute(tmp,[2,1,3]);
    end
    rv = tmp;
end