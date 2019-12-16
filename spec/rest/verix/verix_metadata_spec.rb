# frozen_string_literal: true

require 'spec_helpers/client'
require 'rest/api_request'

RSpec.describe FinApps::REST::VerixMetadata do
  include SpecHelpers::Client

  # noinspection RubyBlockToMethodReference
  let(:api_client) { client }

  describe '#list' do
    subject(:list) { FinApps::REST::VerixMetadata.new(api_client).list }

    it_behaves_like 'an API request'
    it_behaves_like 'a successful request'
    it('returns the verix environment') { expect(list[RESULTS]).to have_key(:environment) }
    it('returns the verix client id') { expect(list[RESULTS]).to have_key(:client_id) }
  end
end