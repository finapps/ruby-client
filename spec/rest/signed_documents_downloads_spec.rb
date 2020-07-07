# frozen_string_literal: true

require 'spec_helpers/client'
require 'rest/api_request'

RSpec.describe FinApps::REST::SignedDocumentsDownloads do
  include SpecHelpers::Client

  let(:api_client) { client }
  let(:document) { described_class.new(api_client) }

  describe '#show' do
    context 'when missing parameters' do
      subject(:show) { document.show(:consumer_id, nil) }

      it 'raises an error when missing consumer id' do
        expect { show }.to raise_error(FinAppsCore::MissingArgumentsError)
      end

      it 'raises an error when missing signature request id' do
        expect { show }.to raise_error(FinAppsCore::MissingArgumentsError)
      end
    end

    subject(:show) do
      document.show(
        :consumer_id,
        :signature_request_id
      )
    end

    it_behaves_like 'an API request'
    it_behaves_like 'a successful request'
  end
end
