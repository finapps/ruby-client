# frozen_string_literal: true

require 'spec_helpers/client'
require 'spec_helpers/api_request'

RSpec.describe FinApps::REST::Actors do
  include SpecHelpers::Client

  let(:results) { subject[RESULTS] }
  let(:error_messages) { subject[ERROR_MESSAGES] }

  describe '#show' do
    subject(:show) { described_class.new(client).show }

    context 'when authorization is not valid' do
      before { stub_unauthorized_request }

      it { expect { show }.to raise_error(FinAppsCore::ApiUnauthenticatedError) }
    end

    context 'when authorization is valid' do
      it_behaves_like 'an API request'
      it_behaves_like 'a successful request'

      it('returns a valid actor') { expect(results).to be_a(Hash) }
    end
  end

  def stub_unauthorized_request
    stub_request(:get, %r{/actor/details}).to_return(
      status: 401,
      body: {
        error_messages: ['Unauthorized'],
        results: nil
      }.to_json,
      headers: {}
    )
  end
end
