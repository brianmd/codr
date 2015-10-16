# This is going to be a brain-dead implementation in order to get success
# quickly. Will assume there is one class, and will read only the first level
# attributes and methods.
#
# A later rendition will likely use a lexer and parser. This brain dead version
# can read individual lines to extract what it needs.

module Codr
  class EmberFileAnalyzer
    def initialize(lines=[])
      @lines = lines
    end

    def process
      @lines.each do |line|
        processLine line
      end
    end

    def processLine(line)
      findLineType(line)
    end

    def findLineType(line)
      case line
      when /export.*default.*extend/
        :class_def
      when /Ember.computed/
        :property
      when /function/
        :method_or_property
      end
    end
  end
end
