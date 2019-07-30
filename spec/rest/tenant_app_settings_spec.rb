# frozen_string_literal: true

require 'spec_helpers/client'

RSpec.describe FinApps::REST::TenantAppSettings do
  include SpecHelpers::Client
  subject { FinApps::REST::TenantAppSettings.new(client) }

  describe '#show' do
    let(:show) { subject.show }

    it { expect { show }.not_to raise_error }
    it('performs a get and returns the response') do
      expect(show[RESULTS]).to have_key(:pdf_statement_months)
    end
    it('returns no error messages') { expect(show[ERROR_MESSAGES]).to be_empty }
  end

  describe '#update' do
    let(:update) { subject.update(params) }

    context 'when missing params' do
      let(:params) { nil }
      it do
        expect { update }.to raise_error(FinAppsCore::MissingArgumentsError)
      end
    end

    context 'when valid params are provided' do
      let(:params) { { pdf_statement_months: 2 } }

      it { expect { update }.not_to raise_error }
      it('performs put and returns no content') do
        expect(update[RESULTS]).to be_nil
      end
      it('error_messages array is empty') do
        expect(update[ERROR_MESSAGES]).to be_empty
      end
    end

    context 'when invalid params are provided' do
      let(:params) { { pdf_statement_months: nil } }

      it { expect { update }.not_to raise_error }
      it('results is nil') { expect(update[RESULTS]).to be_nil }
      it('error_messages array is populated') do
        expect(update[ERROR_MESSAGES]).not_to be_empty
      end
    end
  end
end
