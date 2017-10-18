# frozen_string_literal: true

RSpec.describe FinApps::REST::UserInstitutionsForms do
  include SpecHelpers::Client

  describe '#show' do
    context 'when missing site id' do
      subject { FinApps::REST::UserInstitutionsForms.new(client).show(nil) }
      it('raises missing argument error') { expect { subject }.to raise_error(FinAppsCore::MissingArgumentsError) }
    end

    context 'when valid site id provided' do
      subject { FinApps::REST::UserInstitutionsForms.new(client).show('valid_id') }

      it { expect { subject }.not_to raise_error }
      it('performs a get and returns the login html') { expect(subject[RESULTS]).to respond_to(:login_form_html) }
      it('returns no error messages') { expect(subject[ERROR_MESSAGES]).to be_empty }
    end

    context 'when invalid site id provided' do
      subject { FinApps::REST::UserInstitutionsForms.new(client).show('invalid_id') }

      it { expect { subject }.not_to raise_error }
      it('results is nil') { expect(subject[RESULTS]).to be_nil }
      it('error messages array is populated') do
        expect(subject[ERROR_MESSAGES].first.downcase).to eq('invalid institution id')
      end
    end
  end
end
