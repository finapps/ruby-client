# frozen_string_literal: true

RSpec.describe FinApps::REST::States do
  include SpecHelpers::Client

  describe '#list' do
    subject(:list) { described_class.new(client).list }

    it_behaves_like 'an API request'
    it_behaves_like 'a successful request'

    it('returns a list of hashes with the following keys: code, label, type') do
      expect(list[RESULTS].first.keys).to match_array(%i[code label type])
    end
  end
end
