# This is going to be a brain-dead implementation in order to get success
# quickly. Will assume there is one class, and will read only the first level
# attributes and methods.
#
# A later rendition will likely use a lexer and parser. This brain dead version
# reads individual lines to extract what it needs.

module Codr
  module Ember
    class FileAnalyzer
      def initialize(lines=[], model_name: nil)
        @lines = lines
        @models = []
        @model_name = model_name
      end

      def process
        @lines.each{ |line| processLine(line) }
        @models
      end

      def processLine(line)
        klass = findParser(line)
        if klass
          result = klass.process(line)
          if klass==ClassDef
            @model = result
            @model.name = @model_name
            @models << @model
          else
            @model.add(result)
          end
        end
      end

      def findParser(line)
        [ClassDef, AttributeDef, PropertyDef, MethodDef].find{ |klass| klass.match?(line) }
      end
    end

    class BaseDef
      def self.match?(line)
        !regex.match(line).nil?
      end

      def self.process(line)
        m = regex.match(line)
        klass.new(name: m[1])
      end
    end

    class ClassDef < BaseDef
      def self.regex; /export.*default\s+(.*)\.extend/; end

      def self.process(line)
        m = regex.match(line)
        # TODO: okay, okay. i'm being lazy. the superclass should be a relationship
        superclass = m[1] if m and m[1]!='DS.Model'
        Codr::Model.new(superclass: superclass)
      end
    end

    class AttributeDef < BaseDef
      def self.regex; /\s*([^:]+):\s+Ember.computed/; end
      def self.klass; Codr::Attribute; end
    end

    class PropertyDef < BaseDef
      def self.regex; /\s*([^:]+):\s+DS.attr\(/; end
      def self.klass; Codr::Attribute; end
    end

    class MethodDef < BaseDef
      def self.regex; /\s*([^:]+):\s+function/; end
      def self.klass; Codr::Method; end
    end
  end
end
