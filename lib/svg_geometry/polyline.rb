# encoding: utf-8

require File.expand_path('../polygon', __FILE__)
require 'nokogiri'
include Math

module SvgGeometry
  # Classe que representa um Polyline SVG
  class Polyline < Polygon
    attr_accessor *(@attr_list = [:points])
    @tag_name = "polyline"

    def calc_path
      p = Path.new([])
      (0..(self.positions.length - 1 - 1)).each do |i|
        p.segments << Path::Line.new(positions[i].clone, positions[i+1].clone)
      end
      
      p
    end
  end
end
