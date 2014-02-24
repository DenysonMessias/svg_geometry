# encoding: utf-8

include Math

module SvgGeometry
  class Transform
    
    class Matrix
      attr_accessor :m

      def initialize(m)
        self.m = m
      end

      def transform(cur_x, cur_y)
        x = m[0] * cur_x + m[2] * cur_y + m[4]
        y = m[1] * cur_x + m[3] * cur_y + m[5]
        [x, y]
      end

      def apply(pos)
        x = m[0] * pos.x + m[2] * pos.y + m[4]
        y = m[1] * pos.x + m[3] * pos.y + m[5]
        pos.x, pos.y = x, y

        pos
      end

      def ==(other)
        self.m == other.m
      end

      def to_svg
        "matrix(#{m.join(',')})"
      end

    end
  end
end
