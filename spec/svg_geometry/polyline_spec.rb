require 'svg_geometry'
include SvgGeometry

describe SvgGeometry::Polyline do

  describe '#length' do
    it "should calculate length" do
      pending
    end

    it "should calculate correct length" do
      pending
    end
  end

  describe '#parse' do
    it 'should parse properly' do
      ["100.0,100.0 0,0 300.0 300.0",
       "-1,-1 -20,-20 10,10",
       "10,10",
       "192309120213912,-302.2932 -9213892183,218321738"].each do |str|

        poly1 = Polyline.new(str)
        poly2 = Polyline.new(poly1.to_svg_tag)
        
        expect(poly2).to eq(poly1)
      end
    end
  end

  describe "#to_polygon" do
    it "should generate polygon properly" do
      pending
    end
  end

  describe "#to_polygon" do
    it "should generate polygon with all start/endpoints" do
      pending
    end
  end
end
