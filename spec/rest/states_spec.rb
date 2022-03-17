# frozen_string_literal: true

RSpec.describe FinApps::REST::States do
  include SpecHelpers::Client

  describe '#list' do
    subject(:list) { described_class.new(client).list }

    it_behaves_like 'an API request'
    it_behaves_like 'a successful request'

    it('returns a list') { expect(list[RESULTS]).to be_a(Array) }
  end
end
