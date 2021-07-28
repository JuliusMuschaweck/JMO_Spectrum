%% PlotCameraVsDirectResult
% 
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp; 
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp;
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp; 
% <a href="GroupedList.html"> Grouped list</a> &nbsp; | &nbsp; 
% Source code: <a href = "file:../PlotCameraVsDirectResult.m"> PlotCameraVsDirectResult.m</a>
% </p>
% </html>
%
% documentation to be completed
%
function rv = PlotCameraVsDirectResult(testlamp_spec, test_refl_spectra, camera, directwhite_spec)
    % compare XYZ impression of directly illuminating 'test_refl_spectra' with 'directwhite_spec'
    % vs. using an ideal display with sRGB primaries and 'displaywhite_XYZ' white point for RGB = [1 1 1]
    % to display the sRGB output of 'camera' looking at 'testspectra' illuminated by 'testlamp_spec', applying the
    % camera's standard white balance.
    % 
    % testlamp_spec: valid spectrum
    % testspectra: cell array of valid spectra, allowed length = 1 to 24
    % camera: a TCamera object
    % directwhite_spec: a valid spectrum
    
    % scale testlamp_spec and directwhite_spec to Y == 1
    
    fignum = 1;
    pos_offset = 100;
    
    tmp = CIE1931_XYZ(testlamp_spec);
    testlamp_spec.val = testlamp_spec.val / tmp.Y;
    testlamp_spec.XYZ = CIE1931_XYZ(testlamp_spec);

    tmp = CIE1931_XYZ(directwhite_spec);
    directwhite_spec.val = directwhite_spec.val / tmp.Y;
    directwhite_spec.XYZ = CIE1931_XYZ(directwhite_spec);
    
    
    % make a RGB picture
    nh = 1536;
    nv = 1024;
    pic = ones(nv, nh, 3);
    % divided into 4x6 tiles for 24 color samples
    dnh = nh / 6;
    dnv = nv / 4;

    numspectra = length(test_refl_spectra);
    
    % apply white balance
    camera = camera.WhiteBalance(testlamp_spec);
    
    % the loop to create the picture
    idx = 0;
    for i = 1:4 % row
        for j = 1:6 % column
            idx = idx + 1; % which CRI sample
            if idx > numspectra
                break;
            end
            r0 = (i-1) * dnv + 1; % upper left corner of tile
            c0 = (j-1) * dnh + 1;
            s = test_refl_spectra{idx};
            % outer frame; look directly
            sref = MultiplySpectra(s, directwhite_spec); % the reflected spectrum
            XYZref = CIE1931_XYZ(sref);
            irgbref = XYZ_to_sRGB(XYZref.X, XYZref.Y, XYZref.Z);
            rgb_ref{i,j} = irgbref; %#ok<AGROW>
            irgb = [irgbref.R, irgbref.G, irgbref.B];
            for ii = 1:3 % assign to the tile
                pic(r0:(r0+dnv),c0:(c0+dnh),ii) = irgb(ii);
            end
            % inner square with color from camera
            sr = MultiplySpectra(s, testlamp_spec); % the reflected spectrum
            irgbtest = camera.Response(sr);
            rgb_test{i,j} = irgbtest; %#ok<AGROW>
            irgb = [irgbtest.R, irgbtest.G, irgbtest.B];
            for ii = 1:3 % assign to the tile
                pic((r0+dnv/4):(r0+3*dnv/4),(c0+dnh/4):(c0+3*dnh/4),ii) = irgb(ii);
            end
        end
    end
    
    % show the result
    fh = figure(fignum);
    fh.Position = [pos_offset pos_offset 1536 1024];
    clf;
    imagesc(pic);
    axis equal;
    axis off;
    hold on;
    idx = 0;

    for i = 1:4
        for j = 1:6
             idx = idx + 1;
             r0 = (i-1) * dnv + 1;
             c0 = (j-1) * dnh + 1;
             s = test_refl_spectra{idx};
             irgb = rgb_test{i,j}.RGB;
             irgbref = rgb_ref{i,j}.RGB;
             ixyz = sRGB_to_XYZ(irgb(1), irgb(2), irgb(3));
             ixyzref = sRGB_to_XYZ(irgbref(1), irgbref(2), irgbref(3));
             ixyz_n = sRGB_to_XYZ(1, 1, 1);
             dE = CIEDE2000_XYZ(ixyz, ixyzref, ixyz_n);
             text(c0+dnh/2, r0+dnv/2-110,     sprintf('%s',s.name), 'HorizontalAlignment','center',  'VerticalAlignment','middle','FontSize',12);
%             text(c0+dnh/2, r0+dnv/2 + 30,sprintf('%s', s.description), 'HorizontalAlignment','center',  'VerticalAlignment','middle');
             text(c0+dnh/2, r0+dnv/2 + 70,sprintf('cam. RGB: [%0.3f,%0.3f,%0.3f]', irgb(1), irgb(2), irgb(3)), 'HorizontalAlignment','center',  'VerticalAlignment','middle');
             text(c0+dnh/2, r0+dnv/2 + 90,sprintf('dir. RGB: [%0.3f,%0.3f,%0.3f]', irgbref(1), irgbref(2), irgbref(3)), 'HorizontalAlignment','center',  'VerticalAlignment','middle');
             text(c0+dnh/2, r0+dnv/2 + 110,sprintf('dE = %0.1f', dE), 'HorizontalAlignment','center',  'VerticalAlignment','middle');
        end
    end
    title(sprintf('Direct view with %s vs. camera %s with %s',directwhite_spec.name, camera.cameraname, testlamp_spec.name ),'FontSize',16);
    rv.rgb_ref = rgb_ref;
    rv.rgb_test = rgb_test;
end
