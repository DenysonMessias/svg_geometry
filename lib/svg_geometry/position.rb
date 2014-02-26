module SvgGeometry
  Position = Struct.new(:x, :y) do
    def +(other_position)
      Position.new(self.x + other_position.x, self.y + other_position.y)
    end

    def -(other_position)
      Position.new(self.x - other_position.x, self.y - other_position.y)
    end

    def *(arg)
      if arg.is_a?(Numeric)
        Position.new(self.x * arg, self.y * arg)
      elsif arg.is_a?(Position)
        self.x * arg.x + self.y * arg.y
      end
    end

    def / (den)
      Position.new(self.x / den, self.y / den)
    end

    def %(other_position)
      self.x * other_position.y - self.y * other_position.x
    end

    def norm
      sqrt(self.x * self.x + self.y * self.y)
    end

    def belongs_to_segment(end_a, end_b)
      vectorial_product = (self - end_a) % (end_b - end_a)
      if (vectorial_product.abs < 1E-8)
        return self.x >= [end_a.x, end_b.x].min - 1E-8 && self.x <= [end_a.x, end_b.x].max + 1E-8 &&
                self.y >= [end_a.y, end_b.y].min - 1E-8 && y <= [end_a.y, end_b.y].max + 1E-8
      else
        return false
      end
    end

    def angle_cos(p, q)
      ((p - self) * (q - self)) / ((p - self).norm * (q - self).norm)
    end

    def dist(other_position)
      sqrt(((self.x - other_position.x)**2) + ((self.y - other_position.y)**2))
    end

    # project self on v
    def project(v)
      (v * (self * v)) / (v * v) 
    end

    def to_s
      "(#{x},#{y})"
    end

    def self.create_from_array(args)
      Position.new(args[0], args[1])
    end
  end
end
