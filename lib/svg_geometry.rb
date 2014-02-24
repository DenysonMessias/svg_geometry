Dir[File.expand_path('../svg_geometry/**/*.rb', __FILE__)].each { |file| require file }
require File.expand_path('../svg_geometry/util', __FILE__)

require 'nokogiri'
require "svg_geometry/version"

module SvgGeometry
  COMPATIBLE_TAGS = [:circle, :ellipse, :line, :path, :polygon, :polyline, :rect]

  def self.parse_svg_tag(svg_tag)
    doc = Nokogiri::XML(svg_tag)
    tag_name = doc.root.name

    if COMPATIBLE_TAGS.include?(tag_name.to_sym)
      svg_command = Object.const_get(tag_name.capitalize).new(svg_tag)
    else
      raise "Incompatible Tag. No support was created for this tag yet, or is not a SVG valid Tag. Compatible Tags: #{COMPATIBLE_TAGS}"
    end
  end

end
