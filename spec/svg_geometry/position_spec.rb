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

  describe '#belongs_to_segment' do
    it 'should check if belongs to segment' do
      p1 = Position.new(0, 0)
      p2 = Position.new(5, 5)
      p = Position.new(2, 2)
      expect(p.belongs_to_segment(p1, p2)).to eq(true)
    end
  end

  describe '#angle_cos' do
    it 'should return cos of angle' do
      p1 = Position.new(2, 2)
      p2 = Position.new(3, 2)
      p3 = Position.new(2, 3)
      expect(p1.angle_cos(p2, p3).abs).to be <= 1E-9
    end
  end

  describe '#project' do
    it 'should project vector' do
      p1 = Position.new(5, 5)
      v = Position.new(2, 0)
      projected = p1.project(v)
      expect((projected.x - 5).abs).to be <= 1E-9
      expect(projected.y.abs).to be <= 1E-9
    end
  end

  describe '#create_from_array' do
    it 'should create Position from array' do
      args = [1, 2]
      p = Position.create_from_array(args)
      expect((p.x - 1).abs).to be <= 1E-9
      expect((p.y - 2).abs).to be <= 1E-9
    end
  end
end
