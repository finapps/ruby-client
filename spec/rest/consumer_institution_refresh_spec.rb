# frozen_string_literal: true

require 'spec_helpers/client'

RSpec.describe FinApps::REST::ConsumerInstitutionRefresh, 'initialized with valid FinApps::Client object' do
  include SpecHelpers::Client
  let(:refresh) { FinApps::REST::ConsumerInstitutionRefresh.new client }

  describe '#update' do
    let(:valid_params) { { token: 'valid_token' } }
    let(:invalid_params) { { token: 'invalid_token' } }

    context 'when missing id' do
      it { expect { refresh.update(nil) }.to raise_error(FinAppsCore::MissingArgumentsError) }
    end

    context 'when invalid id is provided' do
      subject { refresh.update(:invalid_consumer_institution_id) }

      it { expect { subject }.not_to raise_error }
      it('results is nil') { expect(subject[0]).to be_nil }
      it('error messages array is populated') { expect(subject[1]).not_to be_nil }
    end

    context 'when invalid params are provided' do
      subject { refresh.update(:valid_consumer_institution_id, invalid_params) }

      it { expect { subject }.not_to raise_error }
      it('results is nil') { expect(subject[0]).to be_nil }
      it('error messages array is populated') { expect(subject[1]).not_to be_nil }
    end

    context 'when valid id is provided' do
      subject { refresh.update(:valid_consumer_institution_id) }

      it { expect { subject }.not_to raise_error }
      it('returns an array') { expect(subject).to be_a(Array) }
      it('performs a PUT and returns the response') do
        expect(subject[0]).to respond_to(:consumer_institution)
      end
      it('returns no error messages') { expect(subject[1]).to be_empty }
    end
  end
end
