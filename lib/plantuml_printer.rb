module Codr
  class PlantUmlPrinter
    def initialize(models)
      @models = models
    end

    def puts(out)
      @models.each do |model|
        out.puts "class #{model.name} {"
        model.attributes.each do |attr|
          out.puts "  #{attr.name}"
        end
        out.puts '--'
        model.methods.each do |method|
          out.puts "  #{method.name}"
        end
        out.puts '}'
        out.puts "#{model.superclass} <|-- #{model.name}" if model.superclass

      end
      out
    end
  end
end
