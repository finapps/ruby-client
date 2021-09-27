# frozen_string_literal: true

require 'spec_helpers/client'
require 'spec_helpers/api_request'

RSpec.describe FinApps::REST::VerixMetadata do
  include SpecHelpers::Client

  # noinspection RubyBlockToMethodReference
  let(:api_client) { client }

  describe '#show' do
    subject(:show) { described_class.new(api_client).show }

    it_behaves_like 'an API request'
    it_behaves_like 'a successful request'
    it('returns the verix environment') { expect(show[RESULTS]).to have_key(:environment) }
    it('returns the verix client id') { expect(show[RESULTS]).to have_key(:client_id) }
  end
end
