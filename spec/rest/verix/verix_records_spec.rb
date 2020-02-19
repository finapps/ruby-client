# frozen_string_literal: true

require 'spec_helpers/client'
require 'rest/api_request'

RSpec.describe FinApps::REST::VerixRecords do
  include SpecHelpers::Client

  # noinspection RubyBlockToMethodReference
  let(:api_client) { client }

  describe '#create' do
    subject(:create) do
      FinApps::REST::VerixRecords.new(api_client).create(
        code: 'authcode'
      )
    end

    it_behaves_like 'an API request'
    it_behaves_like 'a successful request'
    it('returns an id') { expect(create[RESULTS]).to have_key(:_id) }
    it('returns a consumer id') { expect(create[RESULTS]).to have_key(:consumer_id) }
    it('returns a status') { expect(create[RESULTS]).to have_key(:status) }
    it('returns an error node') { expect(create[RESULTS]).to have_key(:error) }
    it('returns a list of documents') { expect(create[RESULTS]).to have_key(:documents) }
    it('returns a list of downloaded documents') { expect(create[RESULTS]).to have_key(:downloaded_documents) }
  end

  describe '#list' do
    subject(:list) { FinApps::REST::VerixRecords.new(api_client).list }

    it_behaves_like 'an API request'
    it_behaves_like 'a successful request'
    it('returns an array') { expect(list[RESULTS]).to be_an_instance_of(Array) }
    it('returns an id') { expect(list[RESULTS].first).to have_key(:_id) }
    it('returns a status') { expect(list[RESULTS].first).to have_key(:status) }
    it('returns a consumer id') { expect(list[RESULTS].first).to have_key(:consumer_id) }
    it('returns an error node') { expect(list[RESULTS].first).to have_key(:error) }
    it('returns a list of documents') { expect(list[RESULTS].first).to have_key(:documents) }
    it('returns a list of downloaded documents') { expect(list[RESULTS].first).to have_key(:downloaded_documents) }
  end
end
