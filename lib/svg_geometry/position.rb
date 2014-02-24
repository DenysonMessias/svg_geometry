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
      end
    end

    def dist(other_position)
      sqrt(((self.x - other_position.x)**2) + ((self.y - other_position.y)**2))
    end

    def to_s
      "(#{x},#{y})"
    end
  end
end
