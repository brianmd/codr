require 'spec_helper'
require 'ember'

describe Codr::EmberFileAnalyzer do
  context 'deciphers line types' do
    it 'discovers classes' do
      expect(subject.findLineType('export default Availability.extend({')).to eq(:class_def)
    end

    it 'discovers properties' do
      expect(subject.findLineType("abc: Ember.computed.equal('sdf',true)")).to eq(:property)
    end

    it 'discovers methods' do
      expect(subject.findLineType("abc: function() {")).to eq(:method_or_property)
    end

    it 'discovers variables' do
      expect(subject.findLineType("abc: Ember.computed.equal('sdf',true)")).to eq(:property)
    end
  end
end

