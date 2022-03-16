# frozen_string_literal: true

RSpec.describe FinApps::REST::Locations do
  include SpecHelpers::Client

  describe '#list' do
    subject(:list) { described_class.new(client).list }

    it_behaves_like 'an API request'
    it_behaves_like 'a successful request'

    it { expect(list[RESULTS]).to all(have_key(:name)) }
    it { expect(list[RESULTS]).to all(have_key(:state)) }
  end
end
