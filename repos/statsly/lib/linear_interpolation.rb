class LinearInterpolation

  ##
  #  Linear interpolation function
  #   x1: given independent var => y1: given dependent var
  #   x2: given independent var => y2: given dependent var
  #   xu: independent value for which y is unknown
  #   returns: linearly interpolated y
  #
  #
  def self.interpolate(y1, y2, x1, x2, xu)
    factor = (xu - x1) / (x2 - x1)
    ydiff  = (y2 - y1)
    yintp  = y1 + factor * ydiff
    yintp
  end

end
