module Codr
  class PlantUmlPrinter

    def initialize(models)
      @models = models
    end

    def puts(out)
      out.puts '@startuml'
      out.puts
      @models.each do |model|
        out.puts "class #{model.name} {"
        model.attributes.each do |attr|
          if attr.type
            unless attr.type.to_s.start_with?('[')
              out.puts "  #{attr.name} : #{attr.type}"
            end
          else
            out.puts "  #{attr.name}"
          end
        end
        out.puts '  --'
        model.methods.each do |method|
          out.puts "  #{method.name}"
        end
        out.puts '}'
        out.puts "#{model.superclass} <|-- #{model.name}" if model.superclass

        # handle belongsTo/hasMany relationships
        model.attributes.each do |attr|
          if attr.type
            m = /\[([^\]]+)/.match(attr.type)
            if m
              if attr.type.to_s.end_with?('*')
                # hasMany
                # out.puts "#{m[1]} \"0..*\" *- #{model.name}"
                out.puts "#{model.name} *--> \"#{attr.name}\" #{m[1]}"
              else
                # belongsTo
                out.puts "#{model.name} --> \"#{attr.name}\" #{m[1]}"
              end
            end
          end
        end
        out.puts
      end
      out.puts
      out.puts '@enduml'
      out
    end
  end
end

