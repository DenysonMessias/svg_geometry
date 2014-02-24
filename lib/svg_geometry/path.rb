# encoding: utf-8

require File.expand_path('../command_str_params', __FILE__)
require 'cairo'
include Math

# Módulo criado para parsear e extrair informações de um Path SVG
# Sobre o elemento Path SVG: http://www.w3.org/TR/SVG/paths.html
# 
# Autor: Airton Sampaio de Sobral (airton@ubee.in)

module SvgGeometry

  # Classe que representa um Path SVG através de uma lista de segmentos.
  # Atente para o fato de que ao manipular os segmentos manualmente a
  # lista de tamanhos de segmentos (o array lenghts) não é atualizado automaticamente.
  # Isto foi feito pensando na performance de multiplos calculos de pontos (método point).
  class Path < CommandStrParams
    include Parser

    attr_accessor *(@attr_list = [:d])
    @tag_name = "path"

    attr_accessor :segments
    
    @transformed_polygons = nil

    def initialize(*args)
      if args[0] && args[0].is_a?(Array)
        self.segments = args[0]
      else
        super(*args)
        parse_d(self.d) if self.d
      end
    end

    def ==(other)
      [:segments].map { |attr| self.send(attr) == other.send(attr) }.inject(true) { |sum, cond| sum && cond }
    end

    def pretty_length
      segments.each do |segment|
        puts segment.pretty_length
      end
      puts ""
    end

    def point(length_size)
      lens = lengths

      # Procurando o segmento que se enquadra na distancia informada
      segment_start = 0
      segments.each_with_index do |segment, i|
        segment_end = segment_start + lens[i]

        if length_size < segment_end
          perct_in_segment = (length_size - segment_start) / (segment_end - segment_start)
          return segment.point_by_percent(perct_in_segment)
        end
        segment_start = segment_end
      end

      return segments.last.point_by_percent(1.0)
    end

    def lengths
      @lenghts ||= self.segments.map { |segment| segment.length }
    end

    def length
      @lenght ||= lengths.inject(0) { |sum, len| sum + len }
    end

    def to_polygons(length_delta, path_length=self.length, sample_lines=true)
      if path_length == 0 || path_length >= Util::FIXNUM_MAX
        return [Polygon.new([])]
      end

      polygons = []
      poly = Polygon.new([])
      last_end_point = nil

      self.segments.each do |segment|
        if (last_end_point != nil) && (last_end_point.dist(segment.start) > 1E-1)
           poly.transform = self.transform
           polygons.push(poly)
           poly = Polygon.new([])
        end
        if (last_end_point == nil) || (last_end_point.dist(segment.start) > 1E-1) 
          poly.add_position(segment.start)
        end
        
        if sample_lines || !segment.is_a?(Line)
          subpath_length = segment.length

          # Numero de pontos além do ponto inicial (startpoint)
          num_positions = (subpath_length.to_f/length_delta.to_f).floor   

          delta = length_delta/subpath_length.to_f

          (1..(num_positions)).each { |i| poly.add_position(segment.point_by_percent(i * delta)); }

          last = poly.positions.last
          control_point = segment.endp

          # Tratando o caso de um ponto de controle ficar muito perto do ultimo ponto gerado
          if last
            dist = control_point.dist(last)
            if dist < length_delta && num_positions > 1
              sum_deltas = (num_positions - 1) * delta
              substitute_point = segment.point_by_percent(sum_deltas + (1 - sum_deltas)/2.0)

              last.x, last.y = substitute_point.x, substitute_point.y
            end
          end
        end
        last_end_point = segment.endp
        # Se o tamanho do subpath for divisivel com o tamanho delta, o ultimo ponto inserido já é o endpoint do segmento
        # Não sendo necessário adiciona-lo novamente. Porem esta restricao fica no metodo add_position do polygon
        # que nao permite a insercao de 2 pontos iguais consecutivamente
        poly.add_position(segment.endp)
      end

      poly.transform = self.transform
      polygons.push(poly)
      polygons
    end

    def contains(position, length_delta)
      if @transformed_polygons == nil
        @transformed_polygons = self.to_polygons(length_delta, self.length, false)
        @transformed_polygons.each do |polygon|
          polygon.apply_transform!
        end
      end
      if !@transformed_polygons[0].contains(position)
         return false
      else
         for i in (1..@transformed_polygons.length-1)
           if @transformed_polygons[i].contains(position)
             return false
           end
         end
         return true
      end
    end

    def to_polygon(length_delta, path_length=self.length)
      self.to_polygons(length_delta, path_length).first
    end

    def to_simple_polygon(length_delta, path_length=self.length)
      if path_length == 0 || path_length >= Util::FIXNUM_MAX
        return Polygon.new([])
      end

      num_positions = (path_length.to_f/length_delta.to_f).ceil
      include_last_position_manually = (path_length % length_delta > 0.005)

      position_lengths = []
      num_positions.times { |i| position_lengths << (length_delta * i) }
      position_lengths << path_length if include_last_position_manually

      poly = Polygon.new([])
      poly.transform = self.transform
      poly.positions = position_lengths.map { |length_size| self.point(length_size) }

      poly
    end
  end
end
