# encoding: utf-8

require File.expand_path('../command', __FILE__)
require 'nokogiri'
include Math

module SvgGeometry

  # Classe que representa um Circle SvgGeometry
  # Especificação: http://www.w3.org/TR/SVG/shapes.html#CircleElement
  class Circle < Command
    attr_accessor *(@attr_list = [:cx, :cy, :r]) 
    @tag_name = "circle"
    @apply_transform_to = [[:cx, :cy]]

    def length
      @length ||= 2 * PI * r
    end

    def point_by_length(length_size)
      point_by_percent(length_size/self.length)
    end

    def point_by_percent(perct)
      perct *= 2 * PI
      Position.new(cx.to_f + r.to_f * cos(perct), cy.to_f + r.to_f * sin(perct))
    end

  end
end
