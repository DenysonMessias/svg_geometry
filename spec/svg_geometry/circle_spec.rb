require 'svg_geometry'
include SvgGeometry

describe SvgGeometry::Circle do

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
      [[10, 15, 20391.7],
       [10, -15, 20391.7],
       [10, 0, 20391.7],
       [18293819839229283920, 15, 20391.7],
       [10, 15, -923.923],
       [10, nil, 20391.7],
       [10, 15, nil]].each do |attrs|

        circle1 = Circle.new(*attrs)
        circle2 = Circle.new(circle1.to_svg_tag)
        
        expect(circle2).to eq(circle1)
      end
    end
  end

  describe "#to_polygon" do
    it "should generate polygon properly" do
      pending
    end
  end
end
