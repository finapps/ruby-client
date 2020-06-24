# frozen_string_literal: true

require 'cgi'

class FakeClass
  include FinApps::Utils::QueryBuilder

  def build_filter(params)
    params&.key?(:role) ? {role: params[:role]} : {}
  end
end

RSpec.describe FinApps::Utils::QueryBuilder do
  subject(:fake_class) { FakeClass.new }

  describe '#build_query_path' do
    let(:end_point) { 'orders' }

    context 'with full params' do
      let(:params) do
        {
          page: '1',
          requested: '20',
          sort: '-date',
          random: 'random',
          role: 2
        }
      end
      let(:escaped_filter) { "filter=#{CGI.escape({role: 2}.to_json)}" }

      it 'includes a page value in the query string' do
        value = 'page=1'
        expect(fake_class.build_query_path(end_point, params)).to include(value)
      end

      it 'includes a requested value in the query string' do
        value = 'requested=20'
        expect(fake_class.build_query_path(end_point, params)).to include(value)
      end

      it 'includes a sort value in the query string' do
        value = 'sort=-date'
        expect(fake_class.build_query_path(end_point, params)).to include(value)
      end

      it 'includes a filter value in the query string' do
        value = escaped_filter
        expect(fake_class.build_query_path(end_point, params)).to include(value)
      end

      it 'builds a properly formatted query string' do
        expected = "orders?page=1&requested=20&sort=-date&#{escaped_filter}"
        expect(fake_class.build_query_path(end_point, params)).to eq(expected)
      end
    end

    context 'with no params' do
      let(:params) { {} }

      it 'returns root' do
        expect(fake_class.build_query_path(end_point, params)).to eq(end_point)
      end
    end
  end
end
