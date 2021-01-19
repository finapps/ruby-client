# frozen_string_literal: true

require 'spec_helpers/client'
require 'rest/api_request'

RSpec.describe FinApps::REST::Screenings do
  include SpecHelpers::Client

  describe '#list' do
    subject(:list) { described_class.new(client).list(params) }

    let(:results) { list[0] }
    let(:error_messages) { list[1] }

    context 'with valid params' do
      let(:params) do
        {
          page: 2,
          sort: 'date_created',
          requested: 25,
          searchTerm: 'term'
        }
      end

      context 'without searchTerm' do
        let(:params) { {searchTerm: nil, page: 2} }

        it_behaves_like 'an API request'
        it_behaves_like 'a successful request'
        it 'performs a get and returns the response' do
          expect(results).to have_key(:records)
        end

        it 'builds query and sends proper request' do
          list
          url = "#{versioned_api_path}/screenings?page=2"
          expect(WebMock).to have_requested(:get, url)
        end
      end

      # rubocop:disable RSpec/ExampleLength
      context 'with searchTerm' do
        it_behaves_like 'an API request'
        it_behaves_like 'a successful request'
        it 'performs a get and returns the response' do
          expect(results).to have_key(:records)
        end

        it 'builds query and sends proper request' do
          list
          url =
            "#{versioned_api_path}/screenings?filter=%7B%22$or%22:%5B%7B%22" \
            'consumer.public_id%22:%22term%22%7D,%7B%22consumer.email%22:%22' \
            'term%22%7D%5D%7D&page=2&requested=25&sort=date_created'

          expect(WebMock).to have_requested(:get, url)
        end
      end
      # rubocop:enable RSpec/ExampleLength
    end

    context 'with invalid params' do
      let(:params) { ['invalid array'] }

      it { expect { list }.to raise_error(FinAppsCore::InvalidArgumentsError) }
    end

    context 'with missing params' do
      let(:params) { nil }

      it_behaves_like 'an API request'
      it_behaves_like 'a successful request'
      it('performs a get and returns the response') do
        expect(results).to have_key(:records)
      end
    end
  end

  describe '#show' do
    subject(:show) { described_class.new(client).show(id) }

    let(:results) { show[0] }
    let(:error_messages) { show[1] }

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

  describe '#create' do
    subject(:create) { described_class.new(client).create(params) }

    let(:results) { create[0] }
    let(:error_messages) { create[1] }

    context 'with valid params' do
      let(:params) do
        {
          "email": 'validemail@financialapps.com',
          "first_name": 'Geo',
          "last_name": 'Metric',
          "public_id": '1234'
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
      let(:params) { {"params": 'invalid'} }

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
    let(:results) { update[0] }
    let(:error_messages) { update[1] }

    context 'with valid session id' do
      let(:id) { :valid_id }

      context 'with valid params' do
        let(:params) { {"question_id": '1234'} }

        it_behaves_like 'an API request'
        it_behaves_like 'a successful request'
        it('returns the next question') do
          expect(results).to have_key(:question)
        end
      end

      context 'with invalid params' do
        let(:params) { {"question_id": 'invalid'} }

        it_behaves_like 'an API request'
        it('results is nil') { expect(results).to be_nil }

        it('error messages array is populated') do
          expect(error_messages.first.downcase).to eq('question with id (invalid) not found ')
        end
      end
    end

    context 'with invalid session id' do
      let(:id) { :invalid_id }
      let(:params) { {"question_id": '1234'} }

      it_behaves_like 'an API request'
      it('results is nil') { expect(results).to be_nil }

      it('error messages array is populated') do
        expect(error_messages.first.downcase).to eq(
          'resource not found'
        )
      end
    end
  end
end