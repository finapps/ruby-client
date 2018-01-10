# frozen_string_literal: true

class FakeClass
  include FinApps::Utils::QueryBuilder

  def build_filter(p); end
end

RSpec.describe FinApps::Utils::QueryBuilder do
  subject { FakeClass.new }

  describe '#build_query_path' do
    let(:end_point) { 'orders' }

    context 'with full params' do
      let(:params) { {page: '1', requested: '20', sort: '-date', filter: {"role": '1'}} }
      it 'returns correct string' do
        correct_string = 'orders?page=1&requested=20&sort=-date&filter=%7B%22role%22%3A%221%22%7D'
        expect(subject.build_query_path(end_point, params)).to eq(correct_string)
      end
    end

    context 'with partial params' do
      let(:params) { {page: '1', filter: {"role": '1'}} }
      it 'returns correct string' do
        expect(subject.build_query_path(end_point, params)).to eq('orders?page=1&filter=%7B%22role%22%3A%221%22%7D')
      end
    end
  end

  describe '#set_filter' do
    it 'sets filter key in params hash argument equal to #build_filter return' do
      orig_params = {page: 2}
      allow(subject).to receive(:build_filter) { 'foo' }
      expect(subject).to receive(:build_filter).with(orig_params)
      expect(subject.set_filter(orig_params)).to eq(orig_params.merge(filter: 'foo'))
    end
  end
end
