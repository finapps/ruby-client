# frozen_string_literal: true

require 'spec_helpers/client'
require 'rest/api_request'

RSpec.describe FinApps::REST::DocumentsUploadTypes do
  include SpecHelpers::Client
  subject(:upload_types) { described_class.new(client).list }

  let(:results) { upload_types[0] }

  describe '#list' do
    context 'when called' do
      it_behaves_like 'an API request'
      it_behaves_like 'a successful request'
      it('performs a get and returns the response') do
        expect(results[0]).to have_key(:type)
      end
    end
  end
end
