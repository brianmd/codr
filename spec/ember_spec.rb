require 'spec_helper'
require 'ember'

$test_class_text = <<EOS
import DS from 'ember-data';

export default AnotherClass.extend({
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
    context 'line' do
      it 'discovers classes' do
        expect(subject.findParser('export default Availability.extend({')).to eq(ClassDef)
      end

      it 'discovers variables' do
        expect(subject.findParser("abc: DS.attr('boolean'),")).to eq(AttributeDef)
      end

      it 'discovers properties' do
        expect(subject.findParser("  abc: Ember.computed.equal('sdf',true)")).to eq(PropertyDef)
      end

      it 'discovers methods' do
        expect(subject.findParser("abc: function() {")).to eq(MethodDef)
      end
    end

    context 'lines' do
      it 'get processed' do
        lines = $test_class_text.split("\n")
        analyzer = FileAnalyzer.new(model_name: 'Abc')
        models = analyzer.process(lines)
        expect(models.size).to eq(1)

        expect(models.first.name).to eq(:Abc)
        expect(models.first.superclass).to eq('AnotherClass')
        # note: Ember.computed is an attribute
        expect(models.first.attributes.size).to eq(7)
        expect(models.first.methods.size).to eq(1)
      end
    end
  end
end

