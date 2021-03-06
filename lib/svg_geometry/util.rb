module SvgGeometry
  module Util
    FIXNUM_MAX = (2**(0.size * 8 -2) -1)
    
    def self.is_upper(c)
      !/[[:upper:]]/.match(c).nil?
    end

    def self.is_lower(c)
      !/[[:lower:]]/.match(c).nil?
    end

    def self.rad_to_degrees(rad)
      (rad * 180.0)/Math::PI
    end

    def self.degrees_to_rad(degrees)
      (degrees * Math::PI)/180.0
    end

    def self.angle_of_vector(vector)
      atan2(vector.y, vector.x)
    end

    def self.calc_vector_angle(ux, uy, vx, vy)
      ta = atan2(uy, ux);
      tb = atan2(vy, vx);
      if (tb >= ta)
        return tb-ta;
      end
      return 2 * PI - (ta-tb);
    end
  end
end
