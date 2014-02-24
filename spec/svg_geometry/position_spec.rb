require 'svg_geometry'
include SvgGeometry

describe SvgGeometry::Position do

  describe '#+' do
    it 'should sum 2 positions' do
      x1,y1,x2,y2 = rand(), rand(), rand(), rand()

      pos1 = Position.new(x1, y1)
      pos2 = Position.new(x2, y2)
      sum = pos1 + pos2

      expect(sum.x).to eq(x1 + x2)
      expect(sum.y).to eq(y1 + y2)
    end
  end

  describe '#-' do
    it 'should subtract 2 positions' do
      x1,y1,x2,y2 = rand(), rand(), rand(), rand()

      pos1 = Position.new(x1, y1)
      pos2 = Position.new(x2, y2)
      sub = pos1 - pos2

      expect(sub.x).to eq(x1 - x2)
      expect(sub.y).to eq(y1 - y2)
    end
  end

  describe '#*' do
    it 'should multiply a position by a scalar' do
      x1,y1,scalar = rand(), rand(), rand()

      pos = Position.new(x1, y1)
      mult = pos * scalar

      expect(mult.x).to eq(x1 * scalar)
      expect(mult.y).to eq(y1 * scalar)
    end
  end
end
