# encoding: utf-8

include Math

module SvgGeometry

  # Classe que representa o atributo Transform SVG
  class Transform
    AVAILABLE_TRANSFORMATIONS = [:matrix, :scale, :rotate, :skewX, :skewY]

    REGEX_TRANSFORMATIONS = /(\w+\((([-+]?[0-9]*\.?[0-9]+(?:[eE][-+]?[0-9]+)?)*\s*,?\s*)+\))+/
    REGEX_TRANSFORM_NAME = /([a-zA-Z]+)/
    REGEX_PARAMETERS = /[-+]?[0-9]*\.?[0-9]+(?:[eE][-+]?[0-9]+)?/

    attr_accessor :transformations

    def initialize(*args)
      if args[0].is_a?(String)
        parse(args[0])
      elsif args[0].is_a?(Array)
        self.transformations = args[0]
      end
    end

    def parse(str)
      self.transformations = []

      transforms = str.scan(REGEX_TRANSFORMATIONS)
      transforms.each do |transform_array|
        transform_str = transform_array.first

        transform_name = transform_str.scan(REGEX_TRANSFORM_NAME).first.first
        transform_params = transform_str.scan(REGEX_PARAMETERS)

        case transform_name
          when "matrix"
            self.transformations << Matrix.new(transform_params.map{ |el| el.to_f })

          when "scale"
            self.transformations << Scale.new(*(transform_params.map{ |el| el.to_f }))

          when "translate"
            self.transformations << Translate.new(*(transform_params.map{ |el| el.to_f }))

          when "rotate"
            self.transformations << Rotate.new(*(transform_params.map{ |el| el.to_f }))

          when "skewX"
            self.transformations << Matrix.new([1, 0, tan(Util.degrees_to_rad(transform_params[0].to_f)), 1, 0, 0])

          when "skewY"
            self.transformations << Matrix.new([1, tan(Util.degrees_to_rad(transform_params[0].to_f)), 0, 1, 0, 0])

        end

      end

      self.transformations.reverse!
    end

    def ==(other)
      self.transformations == other.transformations
    end

    def transform(cur_x, cur_y)
      self.transformations.inject([cur_x, cur_y]) { |pos, transf| pos = transf.transform(*pos) }
    end

    def apply(pos)
      self.transformations.inject(pos) { |pos, transf| transf.apply(pos) }
    end

    def to_svg_attribute
      "transform='#{self.transformations.map { |t| t.to_svg }.join(' ')}'"
    end 

  end
end
