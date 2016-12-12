# frozen_string_literal: true
RSpec.describe FinApps::REST::Version do
  let(:client) { FinApps::REST::Client.new(:company_identifier, :company_token) }

  subject { FinApps::REST::Version.new(client) }
  describe '#show' do
    it { expect { subject.show }.not_to raise_error }
    it('returns a string') { expect(subject.show[0]).to be_a(String) }
    it('starts with the words "Version =>"') { expect(subject.show[0]).to start_with('Version =>') }
  end
end
