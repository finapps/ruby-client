# frozen_string_literal: true

require 'spec_helpers/client'

RSpec.describe FinApps::REST::PlaidConsumerInstitutions do
  include SpecHelpers::Client

  # noinspection RubyBlockToMethodReference
  let(:api_client) { client }

  RSpec.shared_examples 'an API request' do |_parameter|
    # noinspection RubyBlockToMethodReference
    it { expect { subject }.not_to raise_error }
    it('returns an array') { expect(subject).to be_a(Array) }
  end

  describe '#create' do
    subject(:create) do
      FinApps::REST::PlaidConsumerInstitutions
        .new(api_client)
        .create(public_token: 'le-token')
    end

    context 'when valid tenant token is provided' do
      it_behaves_like 'an API request'

      it('performs a post and returns information about the institution') do
        expect(create[RESULTS]).to have_key(:_id)
      end
      it('returns no error messages') do
        expect(create[ERROR_MESSAGES]).to be_empty
      end
    end

    context 'when invalid tenant token is provided' do
      let(:api_client) { client(:invalid_tenant_token) }

      it_behaves_like 'an API request'
      it('results is nil') { expect(create[RESULTS]).to be_nil }
      it('error messages array is populated') do
        expect(create[ERROR_MESSAGES].first.downcase).to eq('resource not found')
      end
    end
  end

  describe '#list' do
    subject(:list) do
      FinApps::REST::PlaidConsumerInstitutions
        .new(api_client)
        .list
    end

    context 'when valid tenant token is provided' do
      it_behaves_like 'an API request'

      it('returns an Array of institution data') do
        result = list[RESULTS]
        expect(result).to be_an(Array)
        expect(result.first).to have_key(:_id)
      end
      it('returns no error messages') do
        expect(list[ERROR_MESSAGES]).to be_empty
      end
    end

    context 'when invalid tenant token is provided' do
      let(:api_client) { client(:invalid_tenant_token) }

      it_behaves_like 'an API request'
      it('results is nil') { expect(list[RESULTS]).to be_nil }
      it('error messages array is populated') do
        expect(list[ERROR_MESSAGES].first.downcase).to eq('resource not found')
      end
    end
  end
end
