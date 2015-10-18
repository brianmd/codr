require 'spec_helper'

require 'models'

module Codr
  describe Model do
    it 'handles attributes' do
      subject.add Attribute.new(name: :test, type: :string)
      expect(subject.elements.size).to eq(1)
      expect(subject.attributes.size).to eq(1)
      expect(subject.attributes.class).to eq(Array)
      expect(subject.attributes.first.class).to eq(Attribute)
      expect(subject.attributes.first.name).to eq(:test)
      expect(subject.attributes.first.type).to eq(:string)
    end

    it 'handles methods' do
      subject.add Method.new(name: :test_method)
      expect(subject.elements.size).to eq(1)
      expect(subject.methods.size).to eq(1)
      expect(subject.methods.class).to eq(Array)
      expect(subject.methods.first.class).to eq(Method)
      expect(subject.methods.first.name).to eq(:test_method)
    end

    it 'not yet', :pending do
    end
  end
end

