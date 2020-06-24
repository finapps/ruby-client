# frozen_string_literal: true

require 'spec_helpers/client'
require 'rest/api_request'

RSpec.describe FinApps::REST::EsignTemplates do
  include SpecHelpers::Client
  subject(:templates) { described_class.new(client).list }

  let(:results) { templates[0] }

  describe '#list' do
    context 'when called' do
      it_behaves_like 'an API request'
      it_behaves_like 'a successful request'
      it('performs a get and returns the response') do
        expect(results[0]).to have_key(:template_id)
      end
    end
  end
end
