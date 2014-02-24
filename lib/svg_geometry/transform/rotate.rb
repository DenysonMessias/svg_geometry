# encoding: utf-8

include Math

module SvgGeometry
  class Transform
    
    class Rotate
      attr_accessor :angle, :cx, :cy

      def initialize(angle, cx=nil, cy=nil)
        self.angle = Util.degrees_to_rad(angle)
        self.cx = cx
        self.cy = cy
      end

      def t1
        @t1 ||= Translate.new(cx, cy)
      end

      def t2
        @t2 ||= Translate.new(-cx, -cy)
      end

      def cos_angle
        @cos_angle ||= cos(angle)
      end

      def sin_angle
        @sin_angle ||= sin(angle)
      end

      def transform(cur_x, cur_y)
        cur_x, cur_y = t1.transform(cur_x, cur_y) if cx != nil || cy != nil

        x = cos_angle * cur_x - sin_angle * cur_y
        y = sin_angle * cur_x + cos_angle * cur_y

        x, y = t1.transform(x, y) if cx != nil || cy != nil

        [x,y]
      end

      def apply(pos)
        t1.apply(pos) if cx != nil || cy != nil

        x = cos_angle * pos.x - sin_angle * pos.y
        y = sin_angle * pos.x + cos_angle * pos.y
        pos.x, pos.y = x, y

        t2.apply(pos) if cx != nil || cy != nil
        
        pos
      end

      def ==(other)
        self.angle == other.angle && self.cx == other.cx && self.cy == other.cy
      end

      def to_svg
        "rotate(#{Util.rad_to_degrees(angle)}#{",#{cx}" if cx}#{",#{cy}" if cy})"
      end

    end
  end
end
