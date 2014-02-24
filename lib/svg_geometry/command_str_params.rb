# encoding: utf-8

require File.expand_path('../command.rb', __FILE__)
require 'nokogiri'
include Math

module SvgGeometry

  # Classe que representa um Comando SVG com parametros string
  class CommandStrParams < Command
    class << self; attr_accessor :attr_list, :tag_name end

    def initialize(*args)
      if args[0].is_a?(String) && args[0].include?(self.class.tag_name)
        parse(args[0])
      elsif(args.any?)
        self.class.attr_list.each_with_index do |attr, i|
          send("#{attr.to_s}=", args[i]) if args[i]
        end
      end
    end

    def parse(svg_tag)
      doc = Nokogiri::XML(svg_tag)
      root = doc.root

      self.class.attr_list.each do |attr_name|
        elem_attr = root.attributes[attr_name.to_s]
        send("#{attr_name}=", elem_attr.value) if elem_attr
      end

      extract_transform(root)
    end

  end
end
