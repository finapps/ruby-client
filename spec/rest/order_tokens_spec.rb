# frozen_string_literal: true

require 'spec_helpers/client'

RSpec.describe FinApps::REST::OrderTokens,
               'initialized with valid FinApps::Client object' do
  include SpecHelpers::Client

  describe '#show' do
    subject(:order_tokens) { described_class.new(client) }

    let(:results) { show[RESULTS] }
    let(:error_messages) { show[ERROR_MESSAGES] }

    context 'when missing token' do
      it do
        expect { order_tokens.show(nil) }.to raise_error(
          FinAppsCore::MissingArgumentsError,
          ': token'
        )
      end
    end

    context 'with valid token' do
      let(:show) { subject.show(:valid_token) }

      it { expect { show }.not_to raise_error }
      it('results is a Hash') { expect(results).to be_a(Hash) }

      it('results contains a consumer_id') do
        expect(results).to have_key(:consumer_id)
      end

      it('error_messages array is empty') { expect(error_messages).to eq([]) }
    end

    context 'with invalid token' do
      let(:show) { subject.show(:invalid_token) }

      it { expect { show }.not_to raise_error }
      it('results is nil') { expect(results).to be_nil }

      it('error messages array is populated') do
        expect(error_messages.first.downcase).to eq('resource not found')
      end
    end
  end
end
