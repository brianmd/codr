require 'virtus'
require 'active_model'

module Codr
  class Element
    include Virtus.model
    include ActiveModel::Validations

    validate :elements_are_valid

    attribute :owner, Element
    attribute :elements, Array[Element]
    attribute :visibility, Symbol, default: :public  # :public, :protected, :private

    def elements_are_valid
      errors.add(:elements, 'All objects in :elements must be of type Element') if self.elements.find{|obj| !obj.kind_of?(Element)}
    end
  end

  class NamedElement < Element
    attribute :name, Symbol
  end

  class Project < NamedElement
    include Virtus.model
    include ActiveModel::Validations
  end

  class Attribute < NamedElement
    attribute :type, Symbol
    attribute :size, Integer
    # attribute :validations, OneToMany????
  end

  class Method < NamedElement
  end

  class Model < NamedElement
    attribute :superclass, String   # TODO: this should be a relationship

    def add(obj)
      relationship = case obj
      when Attribute
        add_attribute(obj)
      when Method
        add_method(obj)
      end
      self.elements << relationship if relationship
      relationship
    end

    def add_attribute(attr)
      AttributeRelationship.new(model: self, attribute: attr)
    end
    
    def add_method(method)
      MethodRelationship.new(model: self, method: method)
    end

    def attributes
      self.elements_of_type(AttributeRelationship)
    end

    def methods
      self.elements_of_type(MethodRelationship)
    end

    def elements_of_type(klass)
      self.elements
        .select{ |ele| ele.class==klass }
        .collect{ |obj| obj.to }
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
    attribute :from, Element
  end

  class OneToOneRelationship < Relationship
    attribute :to, Element
  end

  class OneToManyRelationship < Relationship
    attribute :to, Array[Element]
  end

  class AttributeRelationship < OneToOneRelationship
    alias_method :model, :from
    alias_method :model=, :from=
    alias_method :attribute, :to
    alias_method :attribute=, :to=
  end

  class MethodRelationship < OneToOneRelationship
    alias_method :model, :from
    alias_method :model=, :from=
    alias_method :method, :to
    alias_method :method=, :to=
  end

  class InheritanceRelationship < OneToManyRelationship
    alias_method :superclass, :from
    alias_method :superclass=, :from=
    alias_method :subclasses, :to
    alias_method :subclasses=, :to=
  end

  class CompositeRelationship < OneToOneRelationship
    alias_method :composite, :from
    attribute :superclass, Model
  end

end

