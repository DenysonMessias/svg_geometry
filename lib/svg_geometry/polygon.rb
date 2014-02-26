# encoding: utf-8

require File.expand_path('../command_str_params', __FILE__)
require 'nokogiri'
include Math

module SvgGeometry

  # Classe que representa um Polygon SVG
  class Polygon < CommandStrParams
    attr_accessor *(@attr_list = [:points])
    @tag_name = "polygon"

    attr_accessor :positions

    DEFAULT_STYLE_ATTRIBUTE = "style='fill:lime;stroke:purple;stroke-width:1'"
    REGEX_PARAMETERS = /[-+]?[0-9]*\.?[0-9]+(?:[eE][-+]?[0-9]+)?/

    def initialize(*args)
      if args[0] && args[0].is_a?(Array)
        self.positions = args[0]
      else
        super(*args)
        parse_points(self.points)
      end
    end

    def apply_transform!
      if self.transform 
        self.positions.map! { |pos| self.transform.apply(pos) }
        self.transform = nil
      end

      self
    end

    def ==(other)
      self.positions == other.positions
    end

    def parse_points(points_str)
      coords = points_str.scan(REGEX_PARAMETERS)

      self.positions = []

      (0..(coords.length/2 - 1)).each do |i|
        self.positions << Position.new(coords[2 * i].to_f, coords[(2 * i) + 1].to_f)
      end
    end

    def add_position(position)
      self.positions << position if position != self.positions.last
    end

    def length
      @length ||= path.length
    end

    def medium_distance
      dist = 0
      count = 0
      (0..(self.positions.length - 1 - 1)).each do |i|
        dist += positions[i].dist(positions[i + 1])
        count += 1
      end
      
      dist.to_f/count.to_f
    end

    def calc_path
      p = Path.new([])
      (0..(self.positions.length - 1 - 1)).each do |i|
        p.segments << Path::Line.new(positions[i].clone, positions[i+1].clone)
      end

      # Completando o polygon, adicionando uma linha do ultimo ponto até o primeiro
      p.segments << Path::Line.new(positions.last.clone, positions.first.clone)
      
      p.transform = self.transform
      p
    end

    def path
      @path ||= calc_path
    end

    def point_by_length(distance)
      path.point(distance)      
    end

    def to_polygon(length_delta)
      poly = path.to_polygon(length_delta)
      poly.transform = self.transform

      poly
    end

    def contains(position)
      count = 0
      j = self.positions.length-1
      for i in (0..self.positions.length-1)
        p1 = positions[j]
        p2 = positions[i]
        if position.belongs_to_segment(p1, p2)
          return true
        end
        if p2.y > position.y && p1.y <= position.y 
          if (p2 - p1) % (position - p1) < 1E-8
            count = count + 1
          end
        elsif p1.y > position.y && p2.y <= position.y
          if (p1 - p2) % (position - p2) < 1E-8
            count = count + 1
          end
        end
        j = i
      end
      (count % 2) == 1
    end

    def containsRect(rect)
      
    end

    def to_svg_points
      positions.map { |position| "#{position.x},#{position.y}" }.join(" ")
    end

    def to_svg_tag
      "<#{self.class.tag_name} #{self.transform.to_svg_attribute if self.transform } points='#{to_svg_points}' />"
    end

    def to_svg_circles_group_tag(radius=3)
      "<g>" + self.positions.map { |pos| Circle.new(pos.x, pos.y, radius).to_svg_tag }.join("\n") + "</g>"
    end

    def to_svg_tag_with_circles
      "<#{self.class.tag_name} #{self.transform.to_svg_attribute if self.transform } points='#{to_svg_points}' />" +
      to_svg_circles_group_tag
    end
  end

end
