# encoding: utf-8

module SvgGeometry
  class Transform
    
    class Translate
      attr_accessor :tx, :ty

      def initialize(tx, ty=0)
        self.tx = tx.to_f
        self.ty = ty.to_f
      end

      def transform(cur_x, cur_y)
        [cur_x + tx, cur_y + ty]
      end

      def apply(pos)
        pos.x += tx
        pos.y += ty
        
        pos
      end

      def ==(other)
        self.tx == other.tx && self.ty == other.ty
      end

      def to_svg
        "translate(#{tx}#{",#{ty}" if ty})"
      end

    end
  end
end
