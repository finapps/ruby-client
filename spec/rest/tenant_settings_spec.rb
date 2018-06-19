# frozen_string_literal: true

require 'spec_helpers/client'

RSpec.describe FinApps::REST::TenantSettings do
  include SpecHelpers::Client
  subject { FinApps::REST::TenantSettings.new(client) }

  describe '#show' do
    let(:show) { subject.show }

    it { expect { show }.not_to raise_error }
    it('performs a get and returns the response') do
      expect(show[RESULTS]).to respond_to(:product)
    end
    it('returns no error messages') { expect(show[ERROR_MESSAGES]).to be_empty }
  end

  describe '#update' do
    let(:update) { subject.update(params) }

    context 'when missing params' do
      let(:params) { nil }
      it { expect { update }.to raise_error(FinAppsCore::MissingArgumentsError) }
    end

    context 'when valid params are provided' do
      let(:params) { {product: 'valid'} }

      it { expect { update }.not_to raise_error }
      it('performs put and returns no content') { expect(update[RESULTS]).to be_nil }
      it('error_messages array is empty') { expect(update[ERROR_MESSAGES]).to be_empty }
    end

    context 'when invalid params are provided' do
      let(:params) { {product: nil} }

      it { expect { update }.not_to raise_error }
      it('results is nil') { expect(update[RESULTS]).to be_nil }
      it('error_messages array is populated') { expect(update[ERROR_MESSAGES]).not_to be_empty }
    end
  end
end
