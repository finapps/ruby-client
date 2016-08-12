# frozen_string_literal: true
RSpec.describe FinApps::REST::Institutions do
  let(:client) { FinApps::REST::Client.new(:company_identifier, :company_token) }
  describe '#create' do
    subject(:institutions) { FinApps::REST::Institutions.new(client) }

    context 'when missing site_id' do
      let(:create) { subject.create(nil, :params) }
      it { expect { create }.to raise_error(FinApps::MissingArgumentsError) }
    end

    context 'when missing params' do
      let(:create) { subject.create(:site_id, nil) }
      it { expect { create }.to raise_error(FinApps::MissingArgumentsError) }
    end

    context 'when valid site_id and params are provided' do
      let(:create) { subject.create("valid_site_id", :params) }

      it { expect { create }.not_to raise_error }
      it('performs a post and returns the response') { expect(create[0]).to respond_to(:user_institution) }
      it('returns no error messages') { expect(create[1]).to be_empty }
    end

    # No tests for invalid site_id/params because of API/Yodele flow
  end
end
