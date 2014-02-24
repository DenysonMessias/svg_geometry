# encoding: utf-8

require File.expand_path('../command', __FILE__)
require 'nokogiri'
include Math

module SvgGeometry

  # Classe que representa uma Line SVG
  # Especificação: http://www.w3.org/TR/SVG/shapes.html#LineElement
  class Line < Command
    attr_accessor *(@attr_list = [:x1, :y1, :x2, :y2])
    @tag_name = "line"
    @apply_transform_to = [[:x1, :y1], [:x2, :y2]]

    def length
      @length ||= sqrt(((x2 - x1)**2) + ((y2 - y1)**2))
    end

    def point_by_length(length_size)
      point_by_percent(length_size/self.length)
    end

    def point_by_percent(perct)
      Position.new(x1 + (x2 - x1) * perct, y1 + (y2 - y1) * perct)
    end

  end
end
