# frozen_string_literal: true
RSpec.describe FinApps::REST::UserInstitutionsForms do
  let(:client) { FinApps::REST::Client.new(:company_identifier, :company_token) }
  describe '#show' do
    context 'when missing site id' do
      subject { FinApps::REST::UserInstitutionsForms.new(client).show(nil) }
      it('raises missing argument error') { expect { subject }.to raise_error(FinAppsCore::MissingArgumentsError) }
    end

    context 'when valid site id provided' do
      subject { FinApps::REST::UserInstitutionsForms.new(client).show('valid_id') }

      it { expect { subject }.not_to raise_error }
      it('performs a get and returns the login html') { expect(subject[0]).to respond_to(:login_form_html) }
      it('returns no error messages') { expect(subject[1]).to be_empty }
    end

    context 'when invalid site id provided' do
      subject { FinApps::REST::UserInstitutionsForms.new(client).show('invalid_id') }

      it { expect { subject }.not_to raise_error }
      it('results is nil') { expect(subject[0]).to be_nil }
      it('error messages array is populated') { expect(subject[1].first.downcase).to eq('invalid institution id') }
    end
  end
end
