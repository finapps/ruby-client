# frozen_string_literal: true

require 'spec_helpers/client'

RSpec.describe FinApps::REST::PlaidConsumerInstitutions do
  include SpecHelpers::Client

  # noinspection RubyBlockToMethodReference
  let(:api_client) { client }

  RSpec.shared_examples 'an API request' do |_parameter|
    # noinspection RubyBlockToMethodReference
    it { expect { subject }.not_to raise_error }
    it('returns an array') { expect(subject).to be_a(Array) }
  end

  RSpec.shared_examples 'a successful request' do |_parameter|
    it('returns no error messages') { expect(subject[ERROR_MESSAGES]).to be_empty }
  end

  RSpec.shared_examples 'a request that returns institution data' do |_parameter|
    it('returns institution data') { expect(subject[RESULTS]).to have_key(:_id) }
  end

  describe '#create' do
    subject(:create) do
      FinApps::REST::PlaidConsumerInstitutions
        .new(api_client)
        .create(public_token: 'le-token')
    end

    it_behaves_like 'an API request'
    it_behaves_like 'a successful request'
    it_behaves_like 'a request that returns institution data'
  end

  describe '#show' do
    subject(:show) do
      FinApps::REST::PlaidConsumerInstitutions
        .new(api_client)
        .show(:consumer_institution_id)
    end

    it_behaves_like 'an API request'
    it_behaves_like 'a successful request'
    it_behaves_like 'a request that returns institution data'
  end

  describe '#list' do
    subject(:list) do
      FinApps::REST::PlaidConsumerInstitutions
        .new(api_client)
        .list
    end

    it_behaves_like 'an API request'
    it_behaves_like 'a successful request'
    it('returns an Array of institution data') { expect(list[RESULTS].first).to have_key(:_id) }
  end
end
