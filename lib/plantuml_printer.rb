module Codr
  class PlantUmlPrinter

    # TODO: move this elsewhere. It isn't a responsibility of this class
    def self.process_directory(path)
      require 'pathname'
      require 'ember'
      $stderr.puts path
      analyzer = Ember::FileAnalyzer.new
      models = []
      path.children.select{|f| f.file? && f.to_s.end_with?('.js')}.each do |file|
        $stderr.puts file
        analyzer.model_name = file.basename.to_s[0..-4]
          .split('-')
          .collect{|token| token.capitalize}
          .join('')

        lines = file.readlines
        models = analyzer.process(lines)
      end
      result = StringIO.open do |out|
        PlantUmlPrinter.new(models).puts out
        out.string
      end
      Pathname.new('/Users/bmd/Dropbox/summit/uml/examples/brown-truck.txt').open('w') do |out|
        out.puts result
      end
      result
    end

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
            out.puts "  #{attr.name} : #{attr.type}"
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
        out.puts
      end
      out.puts
      out.puts '@enduml'
      out
    end
  end
end

$stderr.puts Codr::PlantUmlPrinter.process_directory(Pathname.new('/Users/bmd/code/summit/brown-truck/app/models'))

