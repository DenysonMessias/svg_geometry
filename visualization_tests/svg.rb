require File.expand_path('../../lib/svg', __FILE__)
require 'ruby-prof'
require 'nokogiri'

include SvgGeometry

svg_file_paths = Dir[File.expand_path('../../spec/svg/files/*.svg', __FILE__)]

OUTPUT_PATH = File.expand_path('../svg/files/', __FILE__)
GENERATED_CLASS_NAME = "generated"
ONLY_CIRCLES = true
DEFAULT_CIRCLE_RADIUS = 3

@attribute_id_gen_count = 0

def generate_id
  "id_#{@attribute_id_gen_count}"
end

svg_file_paths.each do |svg_file_path|
  puts "Processando arquivo: #{svg_file_path}"
  doc = Nokogiri::XML(File.new(svg_file_path).read)

  root = doc.at_css("svg")

  width = root.attribute("width").value.to_f if root.attribute("width")
  height = root.attribute("height").value.to_f if root.attribute("height")

  circle_radius = DEFAULT_CIRCLE_RADIUS
    
  COMPATIBLE_TAGS.each do |compatible_tag|
    doc.css("#{compatible_tag.to_s}:not(.#{GENERATED_CLASS_NAME})").each do |svg_tag|
      id = svg_tag.attribute("id")
      
      if id.nil?
        id = generate_id
        svg_tag.set_attribute("id", id) 
      end

      command = SvgGeometry.parse_svg_tag(svg_tag.to_s)
      poly = command.to_polygon(20.0)
      poly.apply_transform!

      circle_radius = poly.medium_distance/10.0

      if !ONLY_CIRCLES
        node = Nokogiri::XML(poly.to_svg_tag).root
        node.set_attribute("class", GENERATED_CLASS_NAME)
        node.set_attribute("id", "ref_#{id}")
        svg_tag.add_next_sibling(node)
      end

      nodes = Nokogiri::XML(poly.to_svg_circles_group_tag(circle_radius)).css("circle")
      nodes.each do |n|
        n.set_attribute("class", GENERATED_CLASS_NAME)
        n.set_attribute("id", "ref_#{id}")
        n.set_attribute("fill", "blue")

        if ONLY_CIRCLES
          svg_tag.add_next_sibling(n)
        else
          node.add_next_sibling(n)
        end
      end

    end
  end

  File.open(File.join(OUTPUT_PATH, File.basename(svg_file_path)), 'w') {|f| f.write(doc) }
end
