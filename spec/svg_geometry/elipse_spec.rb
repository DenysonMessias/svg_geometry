require 'svg_geometry'
include SvgGeometry

describe SvgGeometry::Ellipse do

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
      [[10, 15, 20391.7, -9242],
       [10, -15, nil, 0],
       [10, 0, 15, 230],
       [18293819839229283920, 1, 0, 0],
       [10, 15, nil, nil],
       [nil, nil, 20391.7, 102],
       [-1, -1, -1, -1]].each do |attrs|

        ellipse1 = Ellipse.new(*attrs)
        ellipse2 = Ellipse.new(ellipse1.to_svg_tag)

        expect(ellipse2).to eq(ellipse1)
      end
    end
  end

  describe "#to_polygon" do
    it "should generate polygon properly" do
      pending
    end
  end
end
