# -*- coding: utf-8 -*-
require File.expand_path('../../command_str_params', __FILE__)

module SvgGeometry
  class Path < CommandStrParams
    module Parser

      POSSIBLE_COMMANDS = ["M","m","Z","z","L","l","H","h","V","v","C","c","S","s","Q","q","T","t","A","a"]
      REGEX_COMMANDS = /([MmZzLlHhVvCcSsQqTtAa])/
      REGEX_PARAMETERS = /[-+]?[0-9]*\.?[0-9]+(?:[eE][-+]?[0-9]+)?/

      def parse_d(pathStr)
        self.segments = []
        start_pos = current_pos = command = nil
        tokens = []

        pathStr.split(REGEX_COMMANDS).each do |elem|
          if !elem.empty?
            if POSSIBLE_COMMANDS.include?(elem)
              tokens << elem
            else
              params = elem.scan(REGEX_PARAMETERS)
              tokens += params.map { |p| p.to_f }
            end
          end
        end

        while !tokens.empty?
          last_command = command
          
          if POSSIBLE_COMMANDS.include?(tokens.first)
            command = tokens.shift
          else
            # Comando implícito, ou seja, o mesmo comando é realizado novamente
            # só que com novos atributos!
            # Exemplo: 'M 100 200 L 200 100 -100 -200'
            # Repare que o comando lineto só aparece uma vez, porém ele é executado 2x
            # na sequência
          end
          absolute = Util.is_upper(command)

          case command.upcase
            when "M"
              pos = Position.new(tokens.shift, tokens.shift)
              first_move_to = current_pos == nil


              if absolute || first_move_to
                current_pos = pos
              else
                current_pos += pos
              end

              start_pos = current_pos

              # Comandos implícitos moveto são tratados como comandos lineto. 
              # Então vamos definir comando para lineto aqui, no caso de haver mais 
              # comandos implícitos após este moveto.
              command = 'L'

              # No caso de um moveto relativo que aparece como o primeiro comando de um path,
              # os comandos implicitos seguintes (lineto's) devem ser obrigatoriamente relativos
              # Ex: 'm50,50 -4,-5 -30,-30'
              if !absolute && first_move_to
                command = 'l'
              end

            when "Z"
              self.segments << Line.new(current_pos, start_pos)

            when "L"
              pos = Position.new(tokens.shift, tokens.shift)
              pos += current_pos if !absolute

              self.segments << Line.new(current_pos, pos)
              current_pos = pos

            when "H"
              pos = Position.new(tokens.shift, current_pos.y)
              pos.x += current_pos.x if !absolute

              segments << Line.new(current_pos, pos)
              current_pos = pos

            when "V"
              pos = Position.new(current_pos.x, tokens.shift)
              pos.y += current_pos.y if !absolute

              segments << Line.new(current_pos, pos)
              current_pos = pos

            when "C"
              control1 = Position.new(tokens.shift, tokens.shift)
              control2 = Position.new(tokens.shift, tokens.shift)
              endp = Position.new(tokens.shift, tokens.shift)
              
              if !absolute
                control1 += current_pos
                control2 += current_pos
                endp += current_pos
              end
                  
              self.segments << CubicBezier.new(current_pos, control1, control2, endp)
              current_pos = endp

            when "S"
              # Curva Suave (Smooth Curve). Primeiro ponto de controle é o reflexo do segundo ponto de controle 

              control2 = Position.new(tokens.shift, tokens.shift)
              endp = Position.new(tokens.shift, tokens.shift)
              # da curva anterior.
              
              if "CcSs".include?(last_command)
                # O primeiro ponto de controle é assumido como sendo o 
                # reflexo do segundo ponto de controle no comando anterior em relação ao ponto atual.
                control1 = current_pos + current_pos - self.segments.last.control2
              else
                # Se não houver nenhum comando anterior ou se o anterior comando não foi C, C, S ou S, 
                # assumir o primeiro ponto de controle é coincidente com o ponto atual.
                control1 = current_pos
              end
                  
              
              if !absolute
                control2 += current_pos
                endp += current_pos
              end
                  
              segments << CubicBezier.new(current_pos, control1, control2, endp)
              current_pos = endp

            when "Q"
              control = Position.new(tokens.shift, tokens.shift)
              endp = Position.new(tokens.shift, tokens.shift)
              
              if !absolute
                control += current_pos
                endp += current_pos
              end
                  
              segments << QuadraticBezier.new(current_pos, control, endp)
              current_pos = endp

            when "T"
              if "QT".include?(last_command)
                control = current_pos + current_pos - self.segments.last.control
              else
                control = current_pos
              end
                  
              endp = Position.new(tokens.shift, tokens.shift)
              
              if !absolute
                control += current_pos
                endp += current_pos
              end
                  
              segments << QuadraticBezier.new(current_pos, control, endp)
              current_pos = endp

            when "A"
              radius = Position.new(tokens.shift, tokens.shift)
              rotation = tokens.shift
              arc = tokens.shift
              sweep = tokens.shift      
              endp = Position.new(tokens.shift, tokens.shift)
              
              endp += current_pos if !absolute
              
              if radius.x == 0 || radius.y == 0
                segments << Line.new(current_pos, endp)
              else
                segments << Arc.new(current_pos, radius, rotation, arc, sweep, endp)
              end

              current_pos = endp

          end
        end

        return self.segments
      end
    end
  end
end
