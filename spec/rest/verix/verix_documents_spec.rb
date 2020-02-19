# frozen_string_literal: true

require 'spec_helpers/client'
require 'rest/api_request'

RSpec.describe FinApps::REST::VerixDocuments do
  include SpecHelpers::Client

  let(:api_client) { client }
  let(:document) { FinApps::REST::VerixDocuments.new(api_client) }

  describe '#list' do
    context 'when missing parameters' do
      subject { document.list(nil) }
      it 'raises an error when missing record id' do
        expect { subject }.to raise_error(FinAppsCore::MissingArgumentsError)
      end
    end

    subject(:list) do
      document.list(
        :record_id
      )
    end
    it_behaves_like 'an API request'
    it_behaves_like 'a successful request'
  end

  describe '#show' do
    context 'when missing parameters' do
      subject { document.show(nil, :document_id) }
      it 'raises an error when missing record id' do
        expect { subject }.to raise_error(FinAppsCore::MissingArgumentsError)
      end

      subject { document.show(:record_id, nil) }
      it 'raises an error when missing document id' do
        expect { subject }.to raise_error(FinAppsCore::MissingArgumentsError)
      end
    end

    subject(:show) do
      document.show(
        :record_id,
        :document_id
      )
    end

    it_behaves_like 'an API request'
    it_behaves_like 'a successful request'
  end
end
