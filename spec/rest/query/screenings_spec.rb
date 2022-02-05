# frozen_string_literal: true

require 'spec_helpers/client'
require 'spec_helpers/api_request'

RSpec.describe FinApps::REST::Query::Screenings do
  include SpecHelpers::Client

  subject(:create) { described_class.new(client).create('string') }

  describe '#create' do
    context 'when valid tenant token is provided' do
      it_behaves_like 'an API request'
      it_behaves_like 'a successful request'
      it 'sends the params in the body of the request' do
        create
        url = "#{versioned_api_path}/query/screenings"

        expect(WebMock).to have_requested(:post, url).with(body: 'string')
      end
    end
  end
end
