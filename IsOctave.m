function rv = IsOctave()
% function rv = IsOctave() determines if program is running under GNU Octave
persistent x;
  if (isempty (x))
    x = (exist ('OCTAVE_VERSION', 'builtin') == 5);
  end
  rv = x;
end