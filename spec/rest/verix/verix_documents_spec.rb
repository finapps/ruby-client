# frozen_string_literal: true

require 'spec_helpers/client'
require 'rest/api_request'

RSpec.describe FinApps::REST::VerixDocuments do
  include SpecHelpers::Client

  let(:api_client) { client }
  let(:document) { described_class.new(api_client) }

  describe '#list' do
    context 'when missing parameters' do
      subject { document.list(nil) }

      it 'raises an error when missing record id' do
        expect { subject }.to raise_error(FinAppsCore::MissingArgumentsError)
      end
    end

    subject { document.list(:record_id) }

    it_behaves_like 'an API request'
    it_behaves_like 'a successful request'
  end

  describe '#show' do
    context 'when missing record_id' do
      subject(:show) { document.show(nil, :document_id) }

      it { expect { show }.to raise_error(FinAppsCore::MissingArgumentsError) }
    end

    context 'when missing document_id' do
      subject(:show) { document.show(:record_id, nil) }

      it { expect { show }.to raise_error(FinAppsCore::MissingArgumentsError) }
    end

    subject { document.show(:record_id, :document_id) }

    it_behaves_like 'an API request'
    it_behaves_like 'a successful request'
  end
end
