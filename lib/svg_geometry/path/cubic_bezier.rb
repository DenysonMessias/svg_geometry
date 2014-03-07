# -*- coding: utf-8 -*-
require File.expand_path('../command_str_params', __FILE__)
require 'cairo'

module SvgGeometry
  class Path < CommandStrParams
    class CubicBezier
      attr_accessor :start, :endp, :control1, :control2, :path_flat

      def initialize(start, control1, control2, endp)
        self.start = start
        self.endp = endp
        self.control1 = control1
        self.control2 = control2
      end

      def ==(other)
        [:start, :endp, :control1, :control2].map { |attr| self.send(attr) == other.send(attr) }.inject(true) { |sum, cond| sum && cond }
      end

      def point_by_percent(perct)
        point_by_length(perct * length)
      end

      def point_by_length(distance)
        p_start = Position.new(0,0)      # start of current subpath
        p_current = Position.new(0, 0)   # current point
        p_length = 0                     # current summed length
        p_prev = nil

        path_flat.each do |command|
          p_prev = p_current.clone

          sublength = 0

          case(command.type) 
            when Cairo::PATH_MOVE_TO
              point = command.points.first
              p_start = Position.new(point.x, point.y);
              p_current = p_start.clone

            when Cairo::PATH_LINE_TO
              point = command.points.first
              diff = Position.new(point.x, point.y) - p_current;
              sublength = Math.sqrt(diff.x * diff.x + diff.y * diff.y);
              p_current = Position.new(point.x, point.y);

            when Cairo::PATH_CLOSE_PATH
              diff = p_start - p_current;
              sublength = Math.sqrt(diff.x * diff.x + diff.y * diff.y);
              p_current = p_start.clone;

          end

          diff = p_current - p_prev

          if (sublength != 0 && p_length + sublength >= distance)
            ratio = (distance - p_length) / sublength.to_f;

            return p_prev * (1.0 - ratio) + p_current * ratio;
          end

          p_length += sublength;
        end

        # requested offset is past the end of the path - return last point
        return p_current;
      end

      def cairo_ctx
        cpath = Cairo::Path.new
        ctx = cpath.move_to(start.x, start.y)
        ctx.curve_to(control1.x, control1.y, control2.x, control2.y, endp.x, endp.y)
      end

      def path_flat
        @path_flat ||= cairo_ctx.copy_path_flat
      end

      def length
        @lenght ||= calc_length
      end

      # Obs: Este metodo obtem apenas uma aproximação do tamanho da curva!
      # Ele se utiliza da soma de varios sub-segmentos da curva para obter uma
      # boa aproximação do tamanho total da curva.
      def calc_length
        cpath = path_flat
        
        last_position_x = nil
        last_position_y = nil
        current_pos_x = cpath[0].points.first.x
        current_pos_y = cpath[0].points.first.y

        cpath.inject(0) do |sum_length, command|
          last_position_x, last_position_y = current_pos_x, current_pos_y
          current_point = command.points.first
          current_pos_x, current_pos_y = current_point.x, current_point.y
          #puts "(#{current_pos_x},#{current_pos_y}) - (#{last_position_x}, #{last_position_y})"
          #puts "<path d='M#{current_pos_x},#{current_pos_y} L#{last_position_x},#{last_position_y}' stroke='red' />"

          sum_length + sqrt(((current_pos_x - last_position_x)**2) + ((current_pos_y - last_position_y)**2))
        end
      end

      def to_s
        "CubicBezier: start: #{start} | endp: #{endp} | control1: #{control1} | control2: #{control2}"
      end

      def pretty_length
        "#{to_s} | length: #{length}"
      end

    end
  end
end
