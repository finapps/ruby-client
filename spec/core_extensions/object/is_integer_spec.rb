# frozen_string_literal: true
RSpec.describe ObjectExtensions do
  context 'when refining Object' do
    using ObjectExtensions

    describe '#integer?' do
      context 'for integers' do
        subject { 1 + rand(10) }
        it { expect(subject.integer?).to eq(true) }
      end
      context 'for non integers' do
        subject { rand }
        it { expect(subject.integer?).to eq(false) }
      end
    end
  end
end
