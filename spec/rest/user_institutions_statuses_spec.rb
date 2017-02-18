# frozen_string_literal: true
require 'spec_helpers/client'

RSpec.describe FinApps::REST::UserInstitutionsStatuses do
  include SpecHelpers::Client

  RESULT = 0
  ERROR_MESSAGES = 1

  describe '#show' do
    context 'when missing id' do
      subject { FinApps::REST::UserInstitutionsStatuses.new(client).show(nil) }
      it { expect { subject }.to raise_error(FinAppsCore::MissingArgumentsError) }
    end

    context 'when valid id is provided' do
      subject { FinApps::REST::UserInstitutionsStatuses.new(client).show('valid_id') }

      it { expect { subject }.not_to raise_error }
      it('returns an array') { expect(subject).to be_a(Array) }
      it('performs a get and returns the response') { expect(subject[RESULT]).to respond_to(:_id) }
      it('returns no error messages') { expect(subject[ERROR_MESSAGES]).to be_empty }
    end

    context 'when invalid id is provided' do
      subject { FinApps::REST::UserInstitutionsStatuses.new(client).show('invalid_id') }

      it { expect { subject }.not_to raise_error }
      it('results is nil') { expect(subject[RESULT]).to be_nil }
      it('error messages array is populated') { expect(subject[ERROR_MESSAGES].first.downcase).to eq('invalid user institution id') }
    end
  end

  describe '#update' do
    context 'when successful' do
      subject { FinApps::REST::UserInstitutionsStatuses.new(client).update }

      it('returns an array') { expect(subject).to be_a(Array) }
      it('performs a get and returns array of user institutions statuses') { expect(subject[RESULT]).to be_a(Array) }
      it('returns no error messages') { expect(subject[ERROR_MESSAGES]).to be_empty }
    end
  end
end
