function PlotTLCIResult(TLCI_details, fignum, titlestr, pos_offset, fontsize)
    arguments
        TLCI_details
        fignum = 1
        titlestr = 'TLCI of some spectrum'
        pos_offset = 0
        fontsize = 8
    end
    % make a 1024 x 1536 RGB picture
    n = 1024;
    pic = ones(n, n*1.5, 3);
    % divided into 4x6 tiles for 16 color samples
    dn = n / 4;
    
    idx = 0;
    for i = 1:3 % 4 % row
        for j = 1:6 % column
            idx = idx + 1; % which CRI sample
            r0 = (i-1) * dn + 1; % upper left corner of tile
            c0 = (j-1) * dn + 1;
            irgbref = TLCI_details.RGB_Cprime_ref(idx,:);
            TLCI_rgb_ref{i,j} = irgbref;
            for ii = 1:3 % assign to the tile
                pic(r0:(r0+dn),c0:(c0+dn),ii) = irgbref(ii);
            end
            % inner square with lamp color
            irgb =  TLCI_details.RGB_Cprime_test(idx,:);
            TLCI_rgb_test{i,j} = irgb;
            for ii = 1:3 % assign to the tile
                pic((r0+dn/4):(r0+3*dn/4),(c0+dn/4):(c0+3*dn/4),ii) = irgb(ii);
            end
        end
    end
    
    % show the result
    fh = figure(fignum);
    fh.Position = [pos_offset pos_offset 1200 800];
    clf;
    imagesc(pic);
    axis equal;
    axis off;
    hold on;
    idx = 0;
    for i = 1:3 % 4
        for j = 1:6
            idx = idx + 1;
%            s = CRISpectra(idx);
            r0 = (i-1) * dn + 1;
            c0 = (j-1) * dn + 1;
            irgb = TLCI_rgb_test{i,j};
            irgbref = TLCI_rgb_ref{i,j};
%            text(c0+dn/2, r0+dn/2,sprintf('%s',s.name), 'HorizontalAlignment','center',  'VerticalAlignment','middle','FontSize',20);
%            text(c0+dn/2, r0+dn/2 + 30,sprintf('%s', s.description), 'HorizontalAlignment','center',  'VerticalAlignment','middle');
            text(c0+dn/2, r0+dn/2 + 70,sprintf('lamp RGB: [%0.3f,%0.3f,%0.3f]', irgb(1), irgb(2), irgb(3)), 'HorizontalAlignment','center',  'VerticalAlignment','middle','FontSize',fontsize);
            text(c0+dn/2, r0+dn/2 + 90,sprintf('ref. RGB: [%0.3f,%0.3f,%0.3f]', irgbref(1), irgbref(2), irgbref(3)), 'HorizontalAlignment','center',  'VerticalAlignment','middle','FontSize',fontsize);
            if idx <= 18
                text(c0+dn/2, r0+dn/2 + 110,sprintf('Q%g = %0.1f', idx, TLCI_details.Qi(idx)), 'HorizontalAlignment','center',  'VerticalAlignment','middle','FontSize',fontsize);
            end
        end
    end
    title(sprintf('%s, Qa = %0.1f',titlestr,TLCI_details.Qa));
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

