# frozen_string_literal: true

require 'spec_helpers/client'

RSpec.describe FinApps::REST::PlaidWebhooks do
  include SpecHelpers::Client
  subject(:create) { FinApps::REST::PlaidWebhooks.new(api_client).create }

  describe '#create' do
    context 'when valid tenant token is provided' do
      let(:api_client) {client}

      it { expect { create }.not_to raise_error }
      it('returns an array') { expect(create).to be_a(Array) }
      it('performs a post and returns the webhook url') do
        expect(create[RESULTS]).to respond_to(:url)
      end
      it('returns no error messages') { expect(create[ERROR_MESSAGES]).to be_empty }
    end

    context 'when invalid tenant token is provided' do
      let(:api_client) { client(:invalid_tenant_token) }

      before do
        create
      end

      it do
        expect(WebMock).to have_requested(:post, "https://api.financialapps.com/v3/p/webhook").
            with(:headers => {'X-Tenant-Token' => 'invalid_tenant_token'})
      end

      it { expect { create }.not_to raise_error }
      it('returns an array') { expect(create).to be_a(Array) }
      it('results is nil') { expect(create[RESULTS]).to be_nil }
      # it('error messages array is populated') do
      #   expect(create[ERROR_MESSAGES].first.downcase).to eq('resource not found')
      # end
    end
  end
end
