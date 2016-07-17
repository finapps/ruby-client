# frozen_string_literal: true
RSpec.describe HashExtensions do
  context 'when refining hash' do
    using HashExtensions

    subject { {a: true, b: false, c: nil} }

    describe '#compact' do
      it 'returns a hash with non nil values' do
        expect(subject.compact).to eq(a: true, b: false)
        expect(subject).to eq(a: true, b: false, c: nil)
      end
    end
    describe '#compact!' do
      it 'replaces current hash with non nil values' do
        expect(subject.compact!).to eq(a: true, b: false)
        expect(subject).to eq(a: true, b: false)
      end
    end
  end
end
