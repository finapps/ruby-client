# frozen_string_literal: true
class FakeClass
  include FinApps::Utils::QueryBuilder
end

RSpec.describe FinApps::Utils::QueryBuilder do
  describe '#build_query_path' do
    subject { FakeClass.new }
    let(:end_point) { 'orders' }

    context 'with full params' do
      let(:params) { {page: '1', requested: '20', sort: '-date', filter: '{"role": "1"}'} }
      it 'returns correct string' do
        correct_string = 'orders?page=1&requested=20&sort=-date&filter=%7B%22role%22%3A%20%221%22%7D'
        expect(subject.build_query_path(end_point, params)).to eq(correct_string)
      end
    end

    context 'with partial params' do
      let(:params) { {page: '1', filter: '{"role": "1"}'} }
      it 'returns correct string' do
        expect(subject.build_query_path(end_point, params)).to eq('orders?page=1&filter=%7B%22role%22%3A%20%221%22%7D')
      end
    end
  end
end
