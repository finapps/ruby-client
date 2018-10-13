# frozen_string_literal: true

RSpec.describe FinApps::REST::OrderTokens, 'initialized with valid FinApps::Client object' do
  include SpecHelpers::Client

  describe '#show' do
    subject(:order_tokens) { FinApps::REST::OrderTokens.new(client) }
    let(:results) { show[RESULTS] }
    let(:error_messages) { show[ERROR_MESSAGES] }

    context 'when missing token' do
      it { expect { subject.show(nil) }.to raise_error(FinAppsCore::MissingArgumentsError, ': token') }
    end

    context 'for valid token' do
      let(:show) { subject.show(:valid_token) }
      it { expect { show }.not_to raise_error }
      it('results is a Hashie::Rash') { expect(results).to be_a(Hashie::Mash::Rash) }
      it('results contains a consumer_id') { expect(results).to respond_to(:consumer_id) }
      it('error_messages array is empty') { expect(error_messages).to eq([]) }
    end

    context 'for invalid token' do
      let(:show) { subject.show(:invalid_token) }
      it { expect { show }.not_to raise_error }
      it('results is nil') { expect(results).to be_nil }
      it('error messages array is populated') { expect(error_messages.first.downcase).to eq('resource not found') }
    end
  end
end
