# frozen_string_literal: true

require 'spec_helpers/client'
require 'rest/api_request'

RSpec.describe FinApps::REST::PlaidWebhooks do
  include SpecHelpers::Client

  subject(:show) { described_class.new(api_client).show }

  let(:api_client) { client }

  describe '#show' do
    context 'when valid tenant token is provided' do
      it_behaves_like 'an API request'
      it_behaves_like 'a successful request'

      it('performs a post and returns the webhook url') do
        expect(show[RESULTS]).to have_key(:url)
      end
    end

    context 'when invalid tenant token is provided' do
      let(:api_client) { client(:invalid_tenant_token) }

      it_behaves_like 'an API request'

      it('results is nil') { expect(show[RESULTS]).to be_nil }

      it('error messages array is populated') do
        expect(show[ERROR_MESSAGES].first.downcase).to eq(
          'invalid tenant api key or secret'
        )
      end
    end
  end
end
