require 'svg_geometry'
include SvgGeometry

describe SvgGeometry::Polygon do

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

        poly1 = Polygon.new(str)
        poly2 = Polygon.new(poly1.to_svg_tag)
        
        expect(poly2).to eq(poly1)
      end
    end
  end

  describe "#to_polygon" do
    it "should generate polygon properly" do
      pending
    end
  end

  describe '#contains' do
    it 'should check if point is in polygon' do
      answers = [true, false, true, false]
      ["-10 -10 10 -10 10 10 -10 10",
       "-10 -10 -8 -10 -8 8 -6 8 -6 -10 -4 -10 -4 8 2 8 2 -10 4 -10 4 10 -10 10",
       "-10 -10 -8 -10 -8 8 -6 8 -6 -10 -4 -10 -4 8 -2 8 -2 -10 4 -10 4 10 -10 10",
       "-10 -10 10 -10 10 -1 -10 -1"].each_with_index do |str, i|
        poly = Polygon.new(str)
        position = Position.new(0, 0)
        expect(poly.contains(position)).to eq(answers[i])
       end
    end
  end
end
