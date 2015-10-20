# This is going to be a brain-dead implementation in order to get success
# quickly. Will assume there is one class, and will read only the first level
# attributes and methods.
#
# A later rendition will likely use a lexer and parser. This brain dead version
# reads individual lines to extract what it needs.

require 'virtus'
require 'models'

module Codr
  module Ember
    class FileAnalyzer
      include Virtus.model
      attribute :model_name, Symbol

      def initialize(model_name: nil)
        @models = []
        @model_name = model_name
      end

      def process(lines)
        lines.each{ |line| processLine(line) }
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
        [ClassDef, AttributeDef, PropertyDef, MethodDef, BelongsToDef, HasManyDef]
          .find{ |klass| klass.match?(line) }
      end
    end

    class BaseDef
      def self.match?(line)
        !get_match(line).nil?
      end

      def self.process(line)
        m = get_match(line)
        klass.new(name: m[1])
      end

      def self.get_match(line)
        regex.match(line)
      end
    end

    class ClassDef < BaseDef
      def self.regex; /export.*default\s+(.*)\.extend/; end

      def self.process(line)
        m = get_match(line)
        # TODO: okay, okay. i'm being lazy. the superclass should be a relationship
        superclass = m[1] if m and m[1]!='DS.Model'
        Codr::Model.new(superclass: superclass)
      end
    end

    class AttributeTypeDef < BaseDef
      def self.klass; Codr::Attribute; end

      def self.process(line)
        m = get_match(line)
        type = m[2]
        $stderr.puts "class:#{self}:"
        type = "[#{humanize(type)}]" if type and [BelongsToDef, HasManyDef].include?(self)
        type = type+'*' if type and self==HasManyDef
        klass.new(name: m[1], type: type)
      end

      def self.humanize(str)
        str.split('-').collect{|s| s.capitalize}.join('')
      end
    end

    class PropertyDef < BaseDef
      def self.regex; /\s*([^:]+):\s+Ember.computed/; end
      def self.klass; Codr::Attribute; end
    end

    class AttributeDef < AttributeTypeDef
      def self.regex; /\s*([^:]+):\s+DS.attr\('([^']+)'/; end
    end

    class MethodDef < BaseDef
      def self.regex; /\s*([^:]+):\s+function/; end
      def self.klass; Codr::Method; end
    end

  # belongs_to: DS.belongsTo('belongs-to',  { async: true  }),
  # has_many:   DS.hasMany('has-many'),
    class BelongsToDef < AttributeTypeDef
      def self.regex; /\s*([^:]+):\s+DS.belongsTo\('([^']+)'/; end
    end

    class HasManyDef < AttributeTypeDef
      def self.regex; /\s*([^:]+):\s+DS.hasMany\('([^']+)'/; end
    end
  end
end
