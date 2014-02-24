# encoding: utf-8

require 'nokogiri'
include Math

module SvgGeometry

  # Classe que representa um Comando SVG genérico
  class Command
    class << self; attr_accessor :attr_list, :tag_name, :apply_transform_to end

    @attr_list = [] #Precisa ser sobrescrito!
    @tag_name = "command"  #Precisa ser sobrescrito!

    attr_accessor :transform
    
    def initialize(*args)
      if args[0].is_a? String
        parse(args[0])
      elsif args.any?
        self.class.attr_list.each_with_index do |attr, i|
          send("#{attr.to_s}=", args[i].to_f) if args[i]
        end
      end
    end

    def apply_transform
      self.class.apply_transform_to.each do |tuple|
        x, y = self.transform.transform(send(tuple[0]).to_f, send(tuple[1]).to_f)

        send("#{tuple[0].to_s}=", x)
        send("#{tuple[1].to_s}=", y)
      end
    end

    def extract_transform(root)
      transf_attr = root.attributes["transform"]
      self.transform = Transform.new(transf_attr.value) if transf_attr
    end

    def parse(svg_tag)
      doc = Nokogiri::XML(svg_tag)
      root = doc.root

      self.class.attr_list.each do |attr_name|
        elem_attr = root.attributes[attr_name.to_s]
        send("#{attr_name}=", elem_attr.value.to_f) if elem_attr
      end

      extract_transform(root)
    end

    def to_polygon(length_delta)
      if length == 0 || length >= Util::FIXNUM_MAX
        return Polygon.new([])
      end

      poly = Polygon.new([])
      poly.add_position(point_by_percent(0))

      num_positions = (length/length_delta.to_f).floor
      delta = length_delta/length
      (1..num_positions).each { |i| poly.add_position(point_by_percent(i * delta)) }
      poly.add_position(point_by_percent(1))

      poly.transform = self.transform
      poly
    end

    def ==(other)
      self.class.attr_list.map { |attr| self.send(attr) == other.send(attr) }.inject(true) { |sum, cond| sum && cond }
    end

    def to_svg_tag
      "<#{self.class.tag_name} #{self.transform.to_svg_attribute if self.transform } #{self.class.attr_list.map { |attr| "#{attr}='#{send(attr)}' " if send(attr) }.join('')} />"
    end
  end
end
