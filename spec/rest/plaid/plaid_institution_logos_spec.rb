# frozen_string_literal: true

require 'spec_helpers/client'
require 'spec_helpers/api_request'

RSpec.describe FinApps::REST::PlaidInstitutionLogos do
  include SpecHelpers::Client

  # noinspection RubyBlockToMethodReference
  let(:api_client) { client }

  describe '#show' do
    subject(:show) do
      described_class.new(api_client).show(
        :inst_id
      )
    end

    it_behaves_like 'an API request'
    it_behaves_like 'a successful request'
  end
end
