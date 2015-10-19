module Codr
  class PlantUmlPrinter
    def initialize(models)
      @models = models
    end

    def puts(out)
      @models.each do |model|
        out.puts "class Model {"
        model.attributes.each do |attr|
          out.puts "  #{attr.name}"
        end
        out.puts '--'
        model.methods.each do |method|
          out.puts "  #{method.name}"
        end
        out.puts '}'
      end
      out
    end
  end
end
