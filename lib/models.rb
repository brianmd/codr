require 'virtus'

module Codr
  class Element
    include Virtus.model

    attribute :owner, Element
    attribute :elements, Array[Element]
    attribute :visibility, String  # :public, :protected, :private

    # def add(to)
      # self.to = to
      # to.from = self
    # end
  end

  class NamedElement < Element
    attribute :name, Symbol
  end

  class Attribute < NamedElement
    attribute :type, Symbol
  end

  class Model < NamedElement
    # attribute :attrs, Array[Attribute]

    def add(attr)
      add_attribute(attr)
    end

    def add_attribute(attr)
      relationship = AttributeRelationship.new(model: self, attribute: attr)
      self.elements << relationship
    end
    
    def attributes
      self.elements
        .select{ |ele| ele.class==AttributeRelationship }
        .collect{ |attr| attr.attribute }
    end
  end

  class Namespace < NamedElement
  end



  class MultiplicityElement < Element
    alias_method :element, :owner
    attribute :is_ordered, Boolean
    attribute :is_unique, Boolean
    attribute :lower, Integer
    attribute :upper, Integer   # use BigDecimal so can represent infinity (use -1 for now)?
  end

  ################  Relationships  ##################

  class Relationship < Element
  end

  class DirectedRelationship < Relationship
    attribute :from, Element
    attribute :to, Element
  end

  class AttributeRelationship < DirectedRelationship
    alias_method :model, :from
    alias_method :model=, :from=
    alias_method :attribute, :to
    alias_method :attribute=, :to=
  end

  class CompositeRelationship < DirectedRelationship
    alias_method :composite, :from
    attribute :superclass, Model
  end

  class Superclass < DirectedRelationship
    alias_method :superclass, :from
    attribute :subclass, Model
  end

end

