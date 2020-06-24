# frozen_string_literal: true

require 'spec_helpers/client'
require 'rest/api_request'

RSpec.describe FinApps::REST::PlaidAccountPermissions do
  include SpecHelpers::Client

  # noinspection RubyBlockToMethodReference
  let(:api_client) { client }

  RSpec.shared_examples 'a request that returns no content' do |_parameter|
    it('returns no content') do
      expect(subject[RESULTS]).to be_nil
    end

    it('returns no error messages') do
      expect(subject[ERROR_MESSAGES]).to be_empty
    end
  end

  describe '#create' do
    subject(:show) do
      described_class.new(api_client)
                     .create(:account_id)
    end

    it_behaves_like 'an API request'
    it_behaves_like 'a successful request'
    it_behaves_like 'a request that returns no content'
  end

  describe '#destroy' do
    subject(:destroy) do
      described_class.new(api_client)
                     .destroy(:account_id)
    end

    it_behaves_like 'an API request'
    it_behaves_like 'a successful request'
    it_behaves_like 'a request that returns no content'
  end
end
