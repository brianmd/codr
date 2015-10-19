require 'spec_helper'

require 'models'
require 'plantuml_printer'

require 'ember'

$test_class_text = <<EOS
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

$test2_class_text = <<EOS
export default Test.extend({
  boolean:    DS.attr('boolean')
});
EOS

module Codr
  describe PlantUmlPrinter do
    context 'lines' do
      it 'get processed' do
        analyzer = Ember::FileAnalyzer.new(model_name: 'Test')
        lines = $test_class_text.split("\n")
        models = analyzer.process(lines)
        lines = $test2_class_text.split("\n")
        analyzer.model_name = 'Test2'
        models = analyzer.process(lines)
        expect(models.size).to eq(2)

        # note: Ember.computed is an attribute
        expect(models.first.attributes.size).to eq(5)
        expect(models.first.methods.size).to eq(1)

        printer = PlantUmlPrinter.new(models)
        result = StringIO.open do |out|
          printer.puts(out)
          out.string
        end
        expect(result).to eq(3)
      end
    end
  end
end

