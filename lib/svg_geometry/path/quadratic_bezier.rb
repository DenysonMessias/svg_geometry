# -*- coding: utf-8 -*-
require File.expand_path('../command_str_params', __FILE__)
module SvgGeometry
  class Path < CommandStrParams
    class QuadraticBezier
      attr_accessor :start, :endp, :control

      def initialize(start, control, endp)
        self.start = start
        self.endp = endp
        self.control = control
      end

      def ==(other)
        [:start, :endp, :control].map { |attr| self.send(attr) == other.send(attr) }.inject(true) { |sum, cond| sum && cond }
      end

      def point_by_percent(perct)
        (self.start * ((1 - perct) ** 2)) +
        (self.control * ((2 * perct) * (1 - perct))) +
        (self.endp * (perct ** 2))
      end

      def length
        @lenght ||= calc_length
      end

      # Extraído de http://segfaultlabs.com/docs/quadratic-bezier-curve-length
      def calc_length
        p0 = self.start
        p1 = self.control
        p2 = self.endp

        a, b = Position.new(0, 0), Position.new(0,0)
        a.x = p0.x - 2*p1.x + p2.x
        a.y = p0.y - 2*p1.y + p2.y
        b.x = 2*p1.x - 2*p0.x
        b.y = 2*p1.y - 2*p0.y
        upper_a = 4*(a.x*a.x + a.y*a.y)
        upper_B = 4*(a.x*b.x + a.y*b.y)
        upper_c = b.x*b.x + b.y*b.y

        s_abs = 2*sqrt(upper_a+upper_B+upper_c)
        a_2 = sqrt(upper_a)
        a_32 = 2*upper_a*a_2
        c_2 = 2*sqrt(upper_c)
        ba = upper_B/a_2

        ((a_32 * s_abs) + (a_2 * upper_B * (s_abs-c_2)) + (4*upper_c*upper_a-upper_B*upper_B) * log((2*a_2+ba+s_abs)/(ba+c_2)) )/(4*a_32)
      end

      def to_s
        "CubicBezier: start: #{start} | endp: #{endp}"
      end

      def pretty_length
        "#{to_s} | length: #{length}"
      end
    end
  end
end
