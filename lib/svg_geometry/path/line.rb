require File.expand_path('../../command_str_params', __FILE__)

module SvgGeometry
  class Path < CommandStrParams
    class Line
      attr_accessor :start, :endp

      def initialize(start, endp)
        self.start = start
        self.endp = endp
      end

      def ==(other)
        [:start, :endp].map { |attr| self.send(attr) == other.send(attr) }.inject(true) { |sum, cond| sum && cond }
      end

      def point_by_percent(perct)
        vector = self.endp - self.start
        self.start + (vector * perct)
      end

      def length
        @lenght ||= calc_length
      end

      def calc_length
        sqrt(((self.endp.x - self.start.x)**2) + ((self.endp.y - self.start.y)**2))
      end

      def to_s
        "LineTo: start: #{start} | endp: #{endp}"
      end

      def pretty_length
        "#{to_s} | length: #{length}"
      end

    end
  end
end
