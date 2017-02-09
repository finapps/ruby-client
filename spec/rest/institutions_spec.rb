# frozen_string_literal: true
RSpec.describe FinApps::REST::Institutions do
  let(:client) { FinApps::REST::Client.new(:company_identifier, :company_token) }

  describe '#list' do
    subject(:institutions) { FinApps::REST::Institutions.new(client) }

    context 'when search_term is missing' do
      let(:list) { subject.list(nil) }
      it { expect { list }.to raise_error(FinAppsCore::MissingArgumentsError) }
    end

    context 'when proper search_term is provided' do
      let(:list) { subject.list(:search_term) }

      it { expect { list }.not_to raise_error }
      it('returns an array') { expect(list).to be_a(Array) }
      it('performs a get and returns institution array') { expect(list[0]).to be_a(Array) }
      it('returns no error messages') { expect(list[1]).to be_empty }
    end
  end
end
