# frozen_string_literal: true

require 'spec_helpers/client'
require 'spec_helpers/api_request'

RSpec.describe FinApps::REST::VerixPdfDocuments do
  include SpecHelpers::Client

  let(:api_client) { client }
  let(:document) { described_class.new(api_client) }

  describe '#show' do
    subject { document.show(:record_id, :provider_id) }

    it_behaves_like 'an API request'
    it_behaves_like 'a successful request'

    context 'when missing record_id' do
      subject(:show) { document.show(nil, :provider_id) }

      it { expect { show }.to raise_error(FinAppsCore::MissingArgumentsError) }
    end

    context 'when missing provider_id' do
      subject(:show) { document.show(:record_id, nil) }

      it { expect { show }.to raise_error(FinAppsCore::MissingArgumentsError) }
    end
  end
end
