require 'svg_geometry'
include SvgGeometry::Util

describe SvgGeometry::Util do
  describe '#is_upper' do
    it 'should return if a string contains a character in upper case' do
      expect(Util.is_upper("A")).to eq(true)
      expect(Util.is_upper("Aasdasd")).to eq(true)
      expect(Util.is_upper("asdASdsdsd")).to eq(true)
      expect(Util.is_upper("asdasd2323")).to eq(false)
      expect(Util.is_upper("a")).to eq(false)
      expect(Util.is_upper("1")).to eq(false)
      expect(Util.is_upper("-")).to eq(false)
    end
  end

  describe '#is_lower' do
    it 'should return if a string is character is in lower case' do
      expect(Util.is_lower("A")).to eq(false)
      expect(Util.is_lower("Aasdasd")).to eq(true)
      expect(Util.is_lower("asdASdsdsd")).to eq(true)
      expect(Util.is_lower("asdasd2323")).to eq(true)
      expect(Util.is_lower("a")).to eq(true)
      expect(Util.is_lower("1")).to eq(false)
      expect(Util.is_lower("-")).to eq(false)
    end
  end

  describe '#rad_to_degrees' do
    it 'should convert radians to degrees' do
      expect(Util.rad_to_degrees(1).round(3)).to eq(57.2957795.round(3))
      expect(Util.rad_to_degrees(0)).to eq(0)
      expect(Util.rad_to_degrees(Math::PI)).to eq(180)
      expect(Util.rad_to_degrees(2 * Math::PI)).to eq(360)
      expect(Util.rad_to_degrees(-1).round(3)).to eq(-57.2957795.round(3))
      expect(Util.rad_to_degrees(-Math::PI)).to eq(-180)
      expect(Util.rad_to_degrees(-2 * Math::PI)).to eq(-360)
    end
  end

  describe '#degrees_to_rad' do
    it 'should convert degrees to radians' do
      expect(Util.degrees_to_rad(57.2957795).round(1)).to eq(1)
      expect(Util.degrees_to_rad(0)).to eq(0)
      expect(Util.degrees_to_rad(180)).to eq(Math::PI)
      expect(Util.degrees_to_rad(360)).to eq(Math::PI * 2)
      expect(Util.degrees_to_rad(-57.2957795).round(1)).to eq(-1)
      expect(Util.degrees_to_rad(-180)).to eq(-Math::PI)
      expect(Util.degrees_to_rad(-360)).to eq(Math::PI * -2)
    end
  end
end
