require 'svg_geometry'
include SvgGeometry
include Math

describe SvgGeometry::Transform do

  describe '#parse' do
    
    it "should parse properly" do
      transform_str = "scale(10), translate(10,10) matrix(1,2,3,4,5,6) rotate(30) skewX(20) skewY(50) scale(3,4)"
      transform = Transform.new(transform_str)

      expect(transform.transformations.length).to eq(7)
      expect(transform).to eq(Transform.new([Transform::Scale.new(10),
                                             Transform::Translate.new(10, 10),
                                             Transform::Matrix.new([1,2,3,4,5,6]),
                                             Transform::Rotate.new(30),
                                             Transform::Matrix.new([1,0,tan(Util.degrees_to_rad(20)),1,0,0]),
                                             Transform::Matrix.new([1,tan(Util.degrees_to_rad(50)),0,1,0,0]),
                                             Transform::Scale.new(3,4)]))

      transform_str = "scale(10), translate(10 10)  , matrix(1 2 3 4 5 6) rotate(30),scale(3,4),scale(3,4) skewX(20) skewY(50)"
      transform = Transform.new(transform_str)

      expect(transform.transformations.length).to eq(8)
      expect(transform).to eq(Transform.new([Transform::Scale.new(10),
                                             Transform::Translate.new(10, 10),
                                             Transform::Matrix.new([1,2,3,4,5,6]),
                                             Transform::Rotate.new(30),
                                             Transform::Scale.new(3,4),
                                             Transform::Scale.new(3,4),
                                             Transform::Matrix.new([1,0,tan(Util.degrees_to_rad(20)),1,0,0]),
                                             Transform::Matrix.new([1,tan(Util.degrees_to_rad(50)),0,1,0,0])]))
    end

  end
end
