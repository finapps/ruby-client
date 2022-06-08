# frozen_string_literal: true

RSpec.describe FinApps::REST::EdmTransmissions do
  include SpecHelpers::Client

  RSpec.shared_examples 'an EdmTransmission response' do
    it_behaves_like 'an API request'
    it_behaves_like 'a successful request'

    it('returns a hash with the correct keys') do
      expect(subject[RESULTS].keys)
        .to(match_array(%i[transmission_id date_created date_modified status
                           document_order_id documents]))
    end
  end

  describe '#create' do
    subject(:list) { described_class.new(client).create(:order_id, params) }

    let(:params) { {external_id: '12345'} }

    it_behaves_like 'an EdmTransmission response'
  end

  describe '#show' do
    subject(:show) { described_class.new(client).show(:transmission_id) }

    it_behaves_like 'an EdmTransmission response'
  end
end
