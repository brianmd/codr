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

module Codr::Ember
  describe FileAnalyzer do
    context 'deciphers line types' do
      it 'discovers classes' do
        expect(subject.findParser('export default Availability.extend({')).to eq(ClassDef)
      end

      it 'discovers properties' do
        expect(subject.findParser("abc: Ember.computed.equal('sdf',true)")).to eq(AttributeDef)
      end

      it 'discovers methods' do
        expect(subject.findParser("abc: function() {")).to eq(MethodDef)
      end

      it 'discovers variables' do
        expect(subject.findParser("abc: Ember.computed.equal('sdf',true)")).to eq(AttributeDef)
      end
    end

    context 'asdf' do
    end
  end
end

