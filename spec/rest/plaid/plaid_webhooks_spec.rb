# frozen_string_literal: true

require 'spec_helpers/client'

RSpec.describe FinApps::REST::PlaidWebhooks do
  include SpecHelpers::Client

  let(:api_client) { client }
  subject(:create) { FinApps::REST::PlaidWebhooks.new(api_client).create }

  describe '#create' do
    RSpec.shared_examples 'an API request' do |_parameter|
      it { expect { create }.not_to raise_error }
      it('returns an array') { expect(create).to be_a(Array) }
    end

    context 'when valid tenant token is provided' do
      it_behaves_like 'an API request'

      it('performs a post and returns the webhook url') do
        expect(create[RESULTS]).to have_key(:url)
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
        expect(create[ERROR_MESSAGES].first.downcase).to eq(
          'resource not found'
        )
      end
    end
  end
end
