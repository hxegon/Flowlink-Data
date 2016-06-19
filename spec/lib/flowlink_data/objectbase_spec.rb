require_relative '../../../lib/flowlink_data/objectbase'

class TestBase < Flowlink::ObjectBase
  def self.fields
    [:foo, :bar]
  end

  def initialize
    fields.each do |f|
      self.class.send(:define_method, f.to_s) { 1 }
    end
  end
  
  def baz(n = 0)
    n == 1
  end
end

RSpec.describe Flowlink do
  describe Flowlink::ObjectBase do
    # A module to be included in host Flowlink::Product classes.

    let(:base) { TestBase.new }

    context '#to_message' do
      subject { base.to_message }
      let(:keys) { subject.keys }

      it { is_expected.to be_kind_of(Hash) }

      it 'keys are strings' do
        expect(keys.all? { |k| k.kind_of?(String) }).to eq(true)
      end

      it 'has keys matching fields' do
        expect(keys.sort).to eq(base.fields.map(&:to_s).sort)
      end

      context '#to_hash optional block' do
        it 'can add for to #to_hash to use' do
          # TODO: should this be array of arrays or hash :(
          expect(base.to_hash(['baz', 1])['baz']).to be true
        end

        it 'can override calls that #to_hash uses' do
          expect { base.to_hash([:foo, 1]) }.to raise_error(ArgumentError)
        end
      end
    end
  end
end