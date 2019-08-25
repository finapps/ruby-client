# frozen_string_literal: true

require 'spec_helpers/client'
require 'rest/api_request'

RSpec.describe FinApps::REST::PlaidConsumerInstitutions do
  include SpecHelpers::Client

  # noinspection RubyBlockToMethodReference
  let(:api_client) { client }

  RSpec.shared_examples 'a request that returns institution data' do |_parameter|
    it('returns institution data') { expect(subject[RESULTS]).to have_key(:plaid_institution_id) }
  end

  describe '#create' do
    subject(:create) do
      FinApps::REST::PlaidConsumerInstitutions.new(api_client).create(
        public_token: 'le-token'
      )
    end

    it_behaves_like 'an API request'
    it_behaves_like 'a successful request'
    it_behaves_like 'a request that returns institution data'
  end

  describe '#show' do
    subject(:show) do
      FinApps::REST::PlaidConsumerInstitutions.new(api_client).show(
        :consumer_institution_id
      )
    end

    it_behaves_like 'an API request'
    it_behaves_like 'a successful request'
    it_behaves_like 'a request that returns institution data'
    context 'when requesting accounts information' do
      subject(:show) do
        FinApps::REST::PlaidConsumerInstitutions.new(api_client).show(
          :consumer_institution_id, show_accounts: true
        )
      end

      it_behaves_like 'an API request'
      it_behaves_like 'a successful request'
      it_behaves_like 'a request that returns institution data'
      it('returns institution account data') { expect(subject[RESULTS]).to have_key(:accounts) }
    end
  end

  describe '#list' do
    subject(:list) { FinApps::REST::PlaidConsumerInstitutions.new(api_client).list }

    it_behaves_like 'an API request'
    it_behaves_like 'a successful request'
    it('returns an Array of institution data') { expect(list[RESULTS].first).to have_key(:plaid_institution_id) }
  end
end
