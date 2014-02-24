# encoding: utf-8

module SvgGeometry
  class Transform
    
    class Scale
      attr_accessor :sx, :sy

      def initialize(sx, sy=sx)
        self.sx = sx.to_f
        self.sy = sy.to_f
      end

      def transform(cur_x, cur_y)
        [cur_x * sx, cur_y * sy]
      end

      def apply(pos)
        pos.x *= sx
        pos.y *= sy

        pos
      end

      def ==(other)
        self.sx == other.sx && self.sy == other.sy
      end

      def to_svg
        "scale(#{sx}#{",#{sy}" if sy})"
      end

    end
  end
end
