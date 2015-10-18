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

    it 'not yet', :pending do
    end
  end
end

