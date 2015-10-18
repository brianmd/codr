require 'spec_helper'
require 'ember'

test_class_text = <<EOS
import DS from 'ember-data';

export default DS.Model.extend({
  boolean:    DS.attr('boolean'),
  date:       DS.attr('date'),
  integer:    DS.attr('string'),
  string:     DS.attr('string'),

  belongs_to: DS.belongsTo('belongs-to',  { async: true  }),
  has_many:   DS.hasMany('has-many'),

  computed_as_property: Ember.computed('cartLineItems.@each.valid', {
    get() {
      return this.get('cartLineItems').isEvery('valid', true);
    }
  }),

  property_as_function: function() {
    return this.get('cartLineItems').filterBy('orderable', true);
  }.property('cartLineItems.@each.orderable'),

  validations: {
    make_sure_does_not_become_an_attribute:    { 'email-address': true },
  }
}
});
EOS

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

  context 'asdf' do
  end
end

