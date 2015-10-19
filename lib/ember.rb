# This is going to be a brain-dead implementation in order to get success
# quickly. Will assume there is one class, and will read only the first level
# attributes and methods.
#
# A later rendition will likely use a lexer and parser. This brain dead version
# can read individual lines to extract what it needs.

module Codr
  module Ember
    class FileAnalyzer
      def initialize(lines=[])
        @lines = lines
      end

      def process
        @lines.each do |line|
          processLine line
        end
      end

      def processLine(line)
        findParser(line)
      end

      def findParser(line)
        [ClassDef, AttributeDef, MethodDef].find{ |klass| klass.match?(line) }
      end
    end

    class BaseDef
      def self.match?(line)
        !regex.match(line).nil?
      end
    end

    class ClassDef < BaseDef
      def self.regex; /export.*default\s+(.*)\.extend/; end
    end

    class AttributeDef < BaseDef
      def self.regex; /\s*([^:]+):\s+Ember.computed/; end
    end

    class MethodDef < BaseDef
      def self.regex; /\s*([^:]+):\s+function/; end
    end
  end
end
