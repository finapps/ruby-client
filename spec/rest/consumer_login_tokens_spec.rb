# frozen_string_literal: true

require 'spec_helpers/client'

RSpec.describe FinApps::REST::ConsumerLoginTokens do
  context 'when initialized with valid FinApps::Client object' do
    include SpecHelpers::Client
    subject(:consumer_login_tokens) { described_class.new(client) }

    describe '#create' do
      let(:results) { create[0] }
      let(:error_messages) { create[1] }

      context 'when missing params' do
        let(:create) { consumer_login_tokens.create(nil) }

        error = FinAppsCore::MissingArgumentsError
        it { expect { create }.to raise_error(error) }
      end

      context 'when invalid params are provided' do
        let(:create) { consumer_login_tokens.create(params: 'invalid') }

        it { expect { create }.not_to raise_error }
        it('results is nil') { expect(results).to be_nil }

        it('error messages array is populated') do
          expect(error_messages.first.downcase).to eq('invalid request body')
        end
      end

      context 'when valid params are provided' do
        let(:create) { consumer_login_tokens.create(params: 'valid') }

        it { expect { create }.not_to raise_error }
        it('returns an array') { expect(create).to be_a(Array) }
        it { expect(results).to have_key(:public_id) }
        it { expect(results).to have_key(:external_id) }
        it { expect(results).to have_key(:tenant_id) }
        it { expect(results).to have_key(:role) }
        it { expect(results).to have_key(:memo) }
        it { expect(results).to have_key(:token) }
        it('returns no error messages') { expect(error_messages).to be_empty }
      end
    end
  end
end
