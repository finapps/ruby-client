# frozen_string_literal: true
RSpec.describe FinApps::REST::UserInstitutionsStatuses do
  let(:client) { FinApps::REST::Client.new(:company_identifier, :company_token) }
  describe '#show' do
    context 'when missing ui_id' do
      subject { FinApps::REST::UserInstitutionsStatuses.new(client).show(nil) }
      it { expect { subject }.to raise_error(FinApps::MissingArgumentsError) }
    end

    context 'when valid ui_id is provided' do
      subject { FinApps::REST::UserInstitutionsStatuses.new(client).show('valid_ui_id') }

      it { expect { subject }.not_to raise_error }
      it('returns an array') { expect(subject).to be_a(Array) }
      it('performs a get and returns the response') { expect(subject[0]).to respond_to(:_id) }
      it('returns no error messages') { expect(subject[1]).to be_empty }
    end

    context 'when invalid ui_id is provided' do
      subject { FinApps::REST::UserInstitutionsStatuses.new(client).show('invalid_ui_id') }

      it { expect { subject }.not_to raise_error }
      it('results is nil') { expect(subject[0]).to be_nil }
      it('error messages array is populated') { expect(subject[1].first.downcase).to eq('invalid user institution id') }
    end
  end
end
