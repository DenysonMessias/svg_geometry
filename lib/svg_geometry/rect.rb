# encoding: utf-8

require File.expand_path('../command', __FILE__)
require 'nokogiri'
include Math

module SvgGeometry

  # Classe que representa uma Rect SVG
  # Especificação: http://www.w3.org/TR/SVG/shapes.html#RectElement
  class Rect < Command
    attr_accessor *(@attr_list = [:x, :y, :width, :height, :rx, :ry])
    @tag_name = "rect"
    @apply_transform_to = [[:x, :y]]

    # O Rect é convertido para um Path, para então fazer os calculos devidos.
    # Isto porque o Rect pode admitir curva se os valores rx e ry forem informados.
    # Mais detalhes em: http://www.w3.org/TR/SVG/shapes.html#RectElement
    def calc_path
      lrx, lry = 0, 0
      if rx == nil && ry != nil
        lrx = ry.to_f 
      elsif ry == nil && rx != nil
        lry = rx.to_f
      else
        lrx, lry = rx.to_f, ry.to_f
      end

      lrx = width/2.0 if lrx > width/2.0
      lry = height/2.0 if lry > height/2.0
      x = self.x.nil? ? 0 : self.x
      y = self.y.nil? ? 0 : self.y

      path_str = ""
      path_str += "M#{x + lrx},#{y} "
      path_str += "L#{x + width - lrx},#{y} "
      path_str += "A#{lrx},#{lry} 0 0,1 #{x + width},#{y + lry} "
      path_str += "L#{x + width},#{y + height - lry} "
      path_str += "A#{lrx},#{lry} 0 0,1 #{x + width - lrx},#{y + height} "
      path_str += "L#{x + lrx},#{y + height} "
      path_str += "A#{lrx},#{lry} 0 0,1 #{x},#{y + height - lry} "
      path_str += "L#{x},#{y + lry} "
      path_str += "A#{lrx},#{lry} 0 0,1 #{x + lrx},#{y} "

      path = SvgGeometry::Path.new(path_str)
      path.transform = self.transform
      path
    end

    def path
      @path ||= calc_path
    end

    def length
      @length ||= path.length
    end

    def point_by_percent(perct)
      path.point_by_percent(perct)
    end

    def to_polygon(length_delta)
      poly = path.to_polygon(length_delta)
      poly.transform = self.transform
      
      poly
    end
  end
end
