%% Octave_xyz2rgb
% 
% <html>
%  <p style="font-size:75%;">Navigate to: &nbsp; 
% <a href="JMOSpectrumLibrary.html"> Home</a> &nbsp; | &nbsp;
% <a href="AlphabeticList.html"> Alphabetic list</a> &nbsp; | &nbsp; 
% <a href="GroupedList.html"> Grouped list</a>
% Source code: <a href = "file:../Octave_xyz2rgb.m"> Octave_xyz2rgb.m</a></html>
% </p>
% </html>
%
% A GNU Octave routine by Hartmut Gimpel to convert CIE XYZ to RGB
% Superseded by my own <XYZ_to_sRGB.html XYZ_to_sRGB>
%

% ## Copyright (C) 2015 Hartmut Gimpel
% ##
% ## This program is free software; you can redistribute it and/or
% ## modify it under the terms of the GNU General Public License as
% ## published by the Free Software Foundation; either version 3 of the
% ## License, or (at your option) any later version.
% ##
% ## This program is distributed in the hope that it will be useful, but
% ## WITHOUT ANY WARRANTY; without even the implied warranty of
% ## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
% ## General Public License for more details.
% ##
% ## You should have received a copy of the GNU General Public License
% ## along with this program; if not, see
% ## <http:% ##www.gnu.org/licenses/>.

% ## -*- texinfo -*-
% ## @deftypefn  {Function File} {@var{rgb} =} xyz2rgb (@var{xyz})
% ## @deftypefnx {Function File} {@var{rgb_map} =} xyz2rgb (@var{xyz_map})
% ## Transform a colormap or image from CIE XYZ to sRGB color space.
% ##
% ## A color in the CIE XYZ color space consists of three values X, Y and Z.
% ## Those values are designed to be colorimetric, meaning that their values
% ## do not depend on the display device hardware.
% ##
% ## A color in the RGB space consists of red, green, and blue intensities.
% ## The output RGB values are calculated to be nonlinear sRGB values
% ## with the white point D65. This means the output values are in the
% ## colorimetric (sRGB) colorspace.
% ##
% ## Input values of class single and double are acceptecd.
% ## The shape and the class of the input are conserved.
% ##
% ## note: outside the definition range (0<=R, G, B<=1) this function might
% ##           return different (but also nonsense) values than Matlab.
% ##
% ## @seealso{rgb2xyz, rgb2lab, rgb2hsv, rgb2ind, rgb2ntsc}
% ## @end deftypefn

% ## Author: Hartmut Gimpel <hg_code@gmx.de>
% ## algorithm taken from the following book:
% ## Burger, Burge "Digitale Bildverarbeitung", 3rd edition (2015)

function rgb = Octave_xyz2rgb (xyz)

  if (nargin ~= 1)
    print_usage ();
  end

  [xyz, cls, sz, is_im, is_nd, is_int] ...
    = colorspace_conversion_input_check ("xyz2rgb", "XYZ", xyz, 1);
  % #  only accept single and double inputs because valid xyz values can be >1

  % ## transform from CIE XYZ to linear sRGB values with whitepoint D65
  % ## (source of matrix: book of Burger)
  matrix_xyz2rgb_D65 = ...
    [3.240479, -1.537150, -0.498535;
    -0.969256, 1.875992, 0.041556;
    0.055648, -0.204043, 1.057311];

%   # Matlab uses the following slightly different conversion matrix
%   # matrix_xyz2rgb_D65 = ...
%   #  [3.2406, -1.5372, -0.4986;
%   #  -0.9689, 1.8758, 0.0415;
%   #  0.0557, -0.2040, 1.0570];

  rgb_lin = xyz * matrix_xyz2rgb_D65';

  % ## transform from linear sRGB values to non-linear sRGB values
  % ##  (modified gamma transform)
  rgb = rgb_lin;
  mask = rgb_lin <= 0.0031308;
  rgb(mask) = 12.92 .* rgb_lin(mask);
  rgb(! mask) = 1.055 .* (rgb_lin(! mask) .^ (1/2.4)) -0.055;

  rgb = colorspace_conversion_revert (rgb, cls, sz, is_im, is_nd, is_int, 0);

endfunction

% ## Test pure colors, gray and some other colors
% ## (This set of test values is taken from the book by Burger.)
%!assert (xyz2rgb ([0, 0, 0]), [0 0 0], 1e-3)
%!assert (xyz2rgb ([0.4125, 0.2127, 0.0193]), [1 0 0], 1e-3)
%!assert (xyz2rgb ([0.7700, 0.9278, 0.1385]), [1 1 0], 1e-3)
%!assert (xyz2rgb ([0.3576, 0.7152, 0.1192]), [0 1 0], 1e-3)
%!assert (xyz2rgb ([0.5380, 0.7873, 1.0694]), [0 1 1], 1e-3)
%!assert (xyz2rgb ([0.1804, 0.07217, 0.9502]), [0 0 1], 1e-3)
%!assert (xyz2rgb ([0.5929, 0.28484, 0.9696]), [1 0 1], 1e-3)
%!assert (xyz2rgb ([0.9505, 1.0000, 1.0888]), [1 1 1], 1e-3)
%!assert (xyz2rgb ([0.2034, 0.2140, 0.2330]), [0.5 0.5 0.5], 1e-3)
%!assert (xyz2rgb ([0.2155, 0.1111, 0.0101]), [0.75 0 0], 1e-3)
%!assert (xyz2rgb ([0.0883, 0.0455, 0.0041]), [0.5 0 0], 1e-3)
%!assert (xyz2rgb ([0.0210, 0.0108, 0.0010]), [0.25 0 0], 1e-3)
%!assert (xyz2rgb ([0.5276, 0.3812, 0.2482]), [1 0.5 0.5], 1e-3)

% ## Test tolarant input checking on floats
%!assert (xyz2rgb ([1.5 1 1]), [1.5712, 0.7109   0.9717], 1e-3)

%!test
%! xyz_map = rand (64, 3);
%! assert (rgb2xyz (xyz2rgb (xyz_map)), xyz_map, 3e-4);
%!test
%! xyz_img = rand (64, 64, 3);
%! assert (rgb2xyz (xyz2rgb (xyz_img)), xyz_img, 3e-4);

% ## support sparse input  (the only useful xyz value with zeros is black)
%!assert (xyz2rgb (sparse ([0 0 0])), [0 0 0], 1e-3)

% ## conserve class of single input
%!assert (class (xyz2rgb (single([0.5 0.5 0.5]))), 'single')

% ## Test input validation
%!error xyz2rgb ()
%!error xyz2rgb (1,2)
%!error <invalid data type 'cell'> xyz2rgb ({1})
%!error <XYZ must be a colormap or XYZ image> xyz2rgb (ones (2,2))

% ## Test ND input
%!test
%! xyz = rand (16, 16, 3, 5);
%! rgb = zeros (size (xyz));
%! for i = 1:5
%!   rgb(:,:,:,i) = xyz2rgb (xyz(:,:,:,i));
%! endfor
%! assert (xyz2rgb (xyz), rgb)
