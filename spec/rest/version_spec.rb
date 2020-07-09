# frozen_string_literal: true

RSpec.describe FinApps::REST::Version do
  include SpecHelpers::Client

  subject(:version) { described_class.new(client) }

  describe '#show' do
    it { expect { version.show }.not_to raise_error }
    it('returns a string') { expect(version.show[0]).to be_a(String) }

    it('starts with the words "Version =>"') do
      expect(version.show[0]).to start_with('Version =>')
    end
  end
end
