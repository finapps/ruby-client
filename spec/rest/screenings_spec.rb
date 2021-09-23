# frozen_string_literal: true

require 'spec_helpers/client'
require 'rest/api_request'

RSpec.describe FinApps::REST::Screenings do
  include SpecHelpers::Client

  let(:results) { subject[0] }
  let(:error_messages) { subject[1] }

  describe '#list' do
    subject(:list) { described_class.new(client).list(params) }

    context 'with valid params' do
      let(:params) { {} }

      RSpec.shared_examples 'a GET request' do
        it { expect(results).to have_key(:records) }
      end

      RSpec.shared_examples 'a correct query builder' do |filter|
        it_behaves_like 'an API request'
        it_behaves_like 'a successful request'
        it_behaves_like 'a GET request'
        it 'builds query and sends proper request' do
          list
          encoded_filter = ERB::Util.url_encode filter.to_json
          url = "#{versioned_api_path}/screenings?filter=#{encoded_filter}"

          expect(WebMock).to have_requested(:get, url)
        end
      end

      context 'without searchTerm' do
        let(:params) { {searchTerm: nil, page: 2} }

        it 'builds query and sends proper request' do
          list
          url = "#{versioned_api_path}/screenings?page=2"

          expect(WebMock).to have_requested(:get, url)
        end
      end

      context 'with from date' do
        let(:params) { {fromDate: 'from'} }

        it_behaves_like 'a correct query builder', {
          '*date_created': {'$gte': 'from'}
        }
      end

      context 'with to date' do
        let(:params) { {toDate: 'to'} }

        it_behaves_like 'a correct query builder', {
          '*date_created': {'$lt': 'to'}
        }
      end

      context 'with date range' do
        let(:params) { {fromDate: 'from', toDate: 'to'} }

        it_behaves_like 'a correct query builder', {
          '*date_created': {'$gte': 'from', '$lt': 'to'}
        }
      end

      context 'with invalid progress' do
        let(:params) { {progress: 'xyz'} }

        it 'builds query and sends proper request' do
          list
          url = "#{versioned_api_path}/screenings"

          expect(WebMock).to have_requested(:get, url)
        end
      end

      context 'with valid progress' do
        let(:params) { {progress: '10'} }

        it_behaves_like 'a correct query builder', {progress: 10}
      end

      context 'with searchTerm' do
        let(:params) { {searchTerm: 'le term'} }

        it_behaves_like 'a correct query builder', {
          '$or': [{'consumer.public_id': 'le term'},
                  {'consumer.email': 'le term'},
                  {'consumer.first_name': 'le term'},
                  {'consumer.last_name': 'le term'},
                  {'consumer.external_id': 'le term'},
                  {'consumer.first_name': 'le'},
                  {'consumer.last_name': 'le'},
                  {'consumer.first_name': 'term'},
                  {'consumer.last_name': 'term'}]
        }
      end
    end

    context 'with invalid params' do
      let(:params) { ['invalid array'] }

      it { expect { list }.to raise_error(FinAppsCore::InvalidArgumentsError) }
    end

    context 'with missing params' do
      let(:params) { nil }

      it_behaves_like 'an API request'
      it_behaves_like 'a successful request'
      it_behaves_like 'a GET request'
    end
  end

  describe '#tenant_schemas' do
    subject(:tenant_schemas) { described_class.new(client).tenant_schemas }

    it_behaves_like 'an API request'
    it_behaves_like 'a successful request'
    it 'performs a get and returns the response' do
      expect(results[0]).to have_key(:external_url)
    end

    it 'sends proper request' do
      tenant_schemas
      url = "#{versioned_api_path}/schemas"

      expect(WebMock).to have_requested(:get, url)
    end
  end

  describe '#show' do
    subject(:show) { described_class.new(client).show(id) }

    context 'with valid id' do
      let(:id) { :valid_id }

      it_behaves_like 'an API request'
      it_behaves_like 'a successful request'
      it('performs a get and returns the response') do
        expect(results).to have_key(:session)
      end
    end

    context 'with invalid id' do
      let(:id) { :invalid_id }

      it { expect(results).to be_nil }
      it { expect(error_messages).not_to be_empty }
    end

    context 'when missing id' do
      let(:id) { nil }

      it_behaves_like 'a request that raises an error'
    end
  end

  describe '#last' do
    subject(:last) { described_class.new(client).last(consumer_id) }

    context 'with valid consumer_id' do
      let(:consumer_id) { :valid_consumer_id }

      it_behaves_like 'an API request'
      it_behaves_like 'a successful request'
      it('results have an :s_id node') do
        expect(results).to have_key(:s_id)
      end
    end

    context 'with invalid consumer_id' do
      let(:consumer_id) { :invalid_consumer_id }

      it { expect(results).to be_nil }
      it { expect(error_messages).not_to be_empty }
    end

    context 'when missing consumer_id' do
      let(:consumer_id) { nil }

      it_behaves_like 'a request that raises an error'
    end
  end

  describe '#create' do
    subject(:create) { described_class.new(client).create(params) }

    context 'with valid params' do
      let(:params) do
        {
          email: 'validemail@financialapps.com',
          first_name: 'Geo',
          last_name: 'Metric',
          public_id: '1234'
        }
      end

      it_behaves_like 'an API request'
      it_behaves_like 'a successful request'
      it('results is a Hash') { expect(results).to be_a(Hash) }

      it('performs a post and returns the response') do
        expect(results).to have_key(:question)
      end
    end

    context 'with invalid params' do
      let(:params) { {params: 'invalid'} }

      it { expect { create }.not_to raise_error }
      it('results is nil') { expect(results).to be_nil }

      it('error messages array is populated') do
        expect(error_messages.first.downcase).to eq('invalid request body')
      end
    end

    context 'with missing params' do
      let(:params) { nil }

      it_behaves_like 'a request that raises an error'
    end
  end

  describe '#update' do
    subject(:update) { described_class.new(client).update(id, params) }

    let(:params) { {} }

    context 'with valid session id' do
      let(:id) { :valid_id }

      context 'with valid params' do
        let(:params) { {question_id: '1234'} }

        it_behaves_like 'an API request'
        it_behaves_like 'a successful request'
        it('returns the next question') do
          expect(results).to have_key(:question)
        end
      end

      context 'with invalid params' do
        let(:params) { {question_id: 'invalid'} }

        it_behaves_like 'an API request'
        it('results is nil') { expect(results).to be_nil }

        it('error messages array is populated') do
          expect(error_messages.first.downcase).to eq('question with id (invalid) not found ')
        end
      end
    end

    context 'with invalid session id' do
      let(:id) { :invalid_id }
      let(:params) { {question_id: '1234'} }

      it_behaves_like 'an API request'
      it('results is nil') { expect(results).to be_nil }

      it('error messages array is populated') do
        expect(error_messages.first.downcase).to eq(
          'resource not found'
        )
      end
    end
  end

  describe '#destroy' do
    subject(:destroy) { described_class.new(client).destroy(id) }

    context 'with valid session id' do
      let(:id) { :valid_id }

      it_behaves_like 'an API request'
      it_behaves_like 'a successful request'
      it('results is nil') { expect(results).to be_nil }
      it('error_messages is empty') { expect(error_messages).to be_empty }
    end

    context 'when missing session id' do
      let(:id) { nil }

      it_behaves_like 'a request that raises an error'
    end

    context 'with invalid session id' do
      let(:id) { :invalid_id }

      it_behaves_like 'an API request'
      it('results is nil') { expect(results).to be_nil }

      it('error_messages is not empty') do
        expect(error_messages).not_to be_empty
      end

      it('error messages array is populated') do
        expect(error_messages.first.downcase).to eq('session not found')
      end
    end
  end
end
