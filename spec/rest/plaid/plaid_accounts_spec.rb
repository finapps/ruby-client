# frozen_string_literal: true

require 'spec_helpers/client'
require 'rest/api_request'

RSpec.describe FinApps::REST::PlaidAccounts do
  include SpecHelpers::Client

  # noinspection RubyBlockToMethodReference
  let(:api_client) { client }

  RSpec.shared_examples 'a request that returns account data' do |_parameter|
    it('returns accounts data') do
      expect(subject[RESULTS]).to have_key(:balances)
    end
  end

  describe '#show' do
    subject(:show) do
      described_class.new(api_client).show(
        :account_id
      )
    end

    it_behaves_like 'an API request'
    it_behaves_like 'a successful request'
    it_behaves_like 'a request that returns account data'
  end

  describe '#list' do
    subject(:list) { described_class.new(api_client).list }

    it_behaves_like 'an API request'
    it_behaves_like 'a successful request'
    it('returns an Array of institution data') {
      expect(list[RESULTS].first).to have_key(:plaid_institution_id)
    }

    it('returns institution account data') {
      expect(list[RESULTS].first).to have_key(:accounts)
    }
  end
end
