require_relative '../lib/flowlink.rb'

class TestBase < Flowlink::ObjectBase
  def self.fields
    [:foo, :bar]
  end

  def initialize
    fields.each do |f|
      self.class.send(:define_method, f.to_s) { 1 }
    end
  end
end

RSpec.describe Flowlink do
  describe Flowlink::Product do
    # An abstract class that raises NotImplementedError for all required
    # Flowlink product fields.

    it 'has required fields as methods' do
      subject.fields.each do |field|
        expect(subject.methods.include?(field)).to be(true), "expected a defined method named #{field}."
      end
    end

    it 'raises NotImplementedErrors for all field methods' do
      subject.fields.each do |field|
        expect { eval "subject.#{field}" }.to raise_error(NotImplementedError),
                                              "expected Product##{field} to raise NotImplementedError."
      end
    end

    # describe '#fields'
  end

  describe Flowlink::ObjectBase do
    # A module to be included in host Flowlink::Product classes.

    let(:base) { TestBase.new }

    describe '#to_message' do
      subject { base.to_message }
      let(:keys) { subject.keys }

      it { is_expected.to be_kind_of(Hash) }
  
      it 'keys are strings' do
        expect(keys.all? { |k| k.kind_of?(String) }).to eq(true)
      end

      it 'has keys matching fields' do
        expect(keys.sort).to eq(base.fields.map(&:to_s).sort)
      end
    end
  end
end
