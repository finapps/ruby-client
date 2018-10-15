# frozen_string_literal: true

class FakeClass
  include FinApps::Utils::QueryBuilder

  def build_filter(param); end
end

RSpec.describe FinApps::Utils::QueryBuilder do
  subject { FakeClass.new }

  describe '#build_query_path' do
    let(:end_point) { 'orders' }

    context 'with full params' do
      let(:params) { { page: '1', requested: '20', sort: '-date', random: 'random' } }
      it 'calls #build_filter and returns correct string' do
        allow(subject).to receive(:build_filter) { { role: 2 } }
        expect(subject).to receive(:build_filter).with(params)
        correct_string = 'orders?page=1&requested=20&sort=-date&filter=%7B%22role%22%3A2%7D'
        expect(subject.build_query_path(end_point, params)).to eq(correct_string)
      end
    end

    context 'with no params' do
      let(:params) { {} }
      it 'returns returns' do
        allow(subject).to receive(:build_filter) { {} }
        expect(subject).to receive(:build_filter).with(params)
        expect(subject.build_query_path(end_point, params)).to be_nil
      end
    end
  end
end
