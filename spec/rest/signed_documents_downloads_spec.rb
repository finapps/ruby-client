# frozen_string_literal: true

require 'spec_helpers/client'
require 'rest/api_request'

RSpec.describe FinApps::REST::SignedDocumentsDownloads do
  include SpecHelpers::Client

  let(:api_client) { client }
  let(:document) { FinApps::REST::SignedDocumentsDownloads.new(api_client) }

  describe '#show' do
    context 'when missing parameters' do
      subject { document.show(nil, :signature_request_id) }
      it 'raises an error when missing record id' do
        expect { subject }.to raise_error(FinAppsCore::MissingArgumentsError)
      end

      subject { document.show(:consumer_id, nil) }
      it 'raises an error when missing provider id' do
        expect { subject }.to raise_error(FinAppsCore::MissingArgumentsError)
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
