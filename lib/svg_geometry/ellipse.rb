# encoding: utf-8

require File.expand_path('../command', __FILE__)
require 'nokogiri'
include Math

module SvgGeometry

  # Classe que representa uma Ellipse SVG
  # Especificação: http://www.w3.org/TR/SVG/shapes.html#EllipseElement
  class Ellipse < Command
    attr_accessor *(@attr_list = [:cx, :cy, :rx, :ry])
    @tag_name = "ellipse"
    @apply_transform_to = [[:cx, :cy]]


    # Aproximação de Hudson
    # Fonte: http://paulbourke.net/geometry/ellipsecirc/
    def length
      h = ((rx - ry)**2) / ((rx + ry)**2) if !@length
      @length ||= 0.25 * PI * (rx + ry) * ((3.0 * (1.0 + h/4)) + (1.0/(1.0 - h/4.0)))
    end

    def point_by_length(length_size)
      point_by_percent(length_size/self.length)
    end

    def point_by_percent(perct)
      perct *= 2 * PI
      Position.new(cx.to_f + rx.to_f * cos(perct), cy.to_f + ry.to_f * sin(perct))
    end
  end
end
