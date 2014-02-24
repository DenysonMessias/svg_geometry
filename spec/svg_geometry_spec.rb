require 'svg_geometry'
include SvgGeometry

describe SvgGeometry do

  let(:svg_file_paths){ Dir[File.expand_path('../svg/files/*.svg', __FILE__)] }

  describe '#parse_svg_tag' do
    
    it "should raise exception with incompatible tags" do
      expect{ SvgGeometry.parse_svg_tag("<lolaso sodk='23' asod='29103.0234' />") }.to raise_error
    end

    it "should parse all svg compatible tags" do

      svg_file_paths.each do |svg_file_path|
        doc = Nokogiri::XML(File.new(svg_file_path).read)
        
        COMPATIBLE_TAGS.each do |compatible_tag|
          doc.css("#{compatible_tag.to_s}").each do |svg_tag|
            expect(SvgGeometry.parse_svg_tag(svg_tag.to_s)).not_to be_nil
          end
        end
      end

    end

    it "should generate polygon" do

      svg_file_paths.each do |svg_file_path|
        doc = Nokogiri::XML(File.new(svg_file_path).read)
        
        COMPATIBLE_TAGS.each do |compatible_tag|
          doc.css("#{compatible_tag.to_s}").each do |svg_tag|
            command = SvgGeometry.parse_svg_tag(svg_tag.to_s)
            poly = command.to_polygon(command.length/20.0)
            
            expect(poly).not_to be_nil
          end
        end
      end

    end
  end
end
