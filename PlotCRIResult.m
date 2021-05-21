%% PlotCRIResult
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
function PlotCRIResult(lamp, fignum, titlestr, pos_offset)
    load('CRISpectra.mat');
    XYZ0 = CIE1931_XYZ(lamp);
    
    % xyz2rgb uses D65 as default white point
    rgb0 = rgb(XYZ0, 1/XYZ0.Y,'d65');
    
    % make a 1024 x 1024 RGB picture
    n = 1024;
    pic = ones(n, n, 3);
    % divided into 4x4 tiles for 16 color samples
    dn = n / 4;
    
    % reference spectrum
    [cct, duv] = CCT(lamp);
    if duv > 0.05
        warning('lamp too far away from Planck, CCT = %g, d_uv = %g',cct, duv);
    end
    if cct < 5000
        whitepoint = 'd50';
        refspec = PlanckSpectrum(360:830, cct);
    elseif cct < 2 / (1/5000 + 1/5500) % 5238K, mean invT
        whitepoint = 'd50';
        refspec = CIE_Illuminant_D(cct);
    elseif cct < 2 / (1/5500 + 1/6500) % 5958K, mean invT
        whitepoint = 'd55';
        refspec = CIE_Illuminant_D(cct);
    else
        whitepoint = 'd65';
        refspec = CIE_Illuminant_D(cct);
    end
    refXYZ0 = CIE1931_XYZ(refspec);
    
    % the loop to create the picture
    idx = 0;
    for i = 1:4 % row
        for j = 1:4 % column
            idx = idx + 1; % which CRI sample
            r0 = (i-1) * dn + 1; % upper left corner of tile
            c0 = (j-1) * dn + 1;
            s = CRISpectra(idx);
            % outer frame with reference color
            sref = MultiplySpectra(s, refspec); % the reflected spectrum
            XYZref = CIE1931_XYZ(sref);
            irgbref = rgb(XYZref, 1/refXYZ0.Y,whitepoint); % and its sRGB values
            cri_rgb_ref{i,j} = irgbref;
            for ii = 1:3 % assign to the tile
                pic(r0:(r0+dn),c0:(c0+dn),ii) = irgbref(ii);
            end
            % inner square with lamp color
            sr = MultiplySpectra(s, lamp); % the reflected spectrum
            XYZ = CIE1931_XYZ(sr);
            irgb = rgb(XYZ, 1/XYZ0.Y, whitepoint); % and its sRGB values
            cri_rgb{i,j} = irgb;
            for ii = 1:3 % assign to the tile
                pic((r0+dn/4):(r0+3*dn/4),(c0+dn/4):(c0+3*dn/4),ii) = irgb(ii);
            end
        end
    end
    
    % show the result
    fh = figure(fignum);
    fh.Position = [pos_offset pos_offset 1000 1000];
    clf;
    imagesc(pic);
    axis equal;
    axis off;
    hold on;
    idx = 0;
    cri = CRI;
    icri = cri.FullCRI(lamp);
    for i = 1:4
        for j = 1:4
            idx = idx + 1;
            s = CRISpectra(idx);
            r0 = (i-1) * dn + 1;
            c0 = (j-1) * dn + 1;
            irgb = cri_rgb{i,j};
            irgbref = cri_rgb_ref{i,j};
            text(c0+dn/2, r0+dn/2,sprintf('%s',s.name), 'HorizontalAlignment','center',  'VerticalAlignment','middle','FontSize',20);
            text(c0+dn/2, r0+dn/2 + 30,sprintf('%s', s.description), 'HorizontalAlignment','center',  'VerticalAlignment','middle');
            text(c0+dn/2, r0+dn/2 + 55,sprintf('lamp RGB: [%0.3f,%0.3f,%0.3f]', irgb(1), irgb(2), irgb(3)), 'HorizontalAlignment','center',  'VerticalAlignment','middle');
            text(c0+dn/2, r0+dn/2 + 80,sprintf('ref. RGB: [%0.3f,%0.3f,%0.3f]', irgbref(1), irgbref(2), irgbref(3)), 'HorizontalAlignment','center',  'VerticalAlignment','middle');
            text(c0+dn/2, r0+dn/2 + 105,sprintf('R%g = %0.1f', idx, icri.Ri(idx)), 'HorizontalAlignment','center',  'VerticalAlignment','middle');
        end
    end
    title(sprintf('%s, Ra = %0.1f',titlestr,icri.Ra));
end

function rv = rgb(XYZ, scale, whitepoint)
    % replace xyz2rgb with the function from GNU Octave's image package if you don't have the image processing toolbox
    % of Matlab
    % https://octave.sourceforge.io/image/index.html
    % NB: the Octave function knows only d65
    rv = xyz2rgb([XYZ.X, XYZ.Y, XYZ.Z] * scale,'WhitePoint',whitepoint);
    rv (rv>1) = 1;
    rv (rv<0) = 0;
end

