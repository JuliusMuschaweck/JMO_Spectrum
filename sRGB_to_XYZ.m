function rv = sRGB_to_XYZ(R, G, B)
    arguments
        R (:,:) double
        G (:,:) double
        B (:,:) double
    end
    RGB = cat(2,R(:),G(:),B(:)); % n x 3
    negative = (RGB < (- 0.04045));
    positive = (RGB > (+ 0.04045));
    small = ~(negative | positive);
    RGBlin = NaN(size(RGB));
    RGBlin(small) = 25 * RGB(small) / 323;
    RGBlin(positive) = ((200 * RGB(positive) + 11) / 211) .^ 2.4; 
    RGBlin(negative) = - ((- 200 * RGB(negative) + 11) / 211) .^ 2.4; 
    
    M = [0.4124, 0.3576, 0.1805;
         0.2126, 0.7152, 0.0722;
         0.0193, 0.1192, 0.9505];
    XYZ = M * RGBlin'; % 3 x n

    rv.X = XYZ(1,:);
    rv.Y = XYZ(2,:);
    rv.Z = XYZ(3,:);
    rv.XYZ = XYZ';
end

%     M = [ 3.2406255, -1.5372080, -0.4986286;
%          -0.9689307,  1.8757561,  0.0415175;
%           0.0557101, -0.2040211,  1.0569959];
%     iM = inv(M);
%     iM = [0.412399997173099,0.357600002651009,0.180500014352339;
%           0.212599990736123,0.715199984234609,0.0722000155301504;
%           0.0193000170459133,0.119200041926217,0.950500047104164];
