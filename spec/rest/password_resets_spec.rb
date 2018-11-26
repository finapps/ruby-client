# frozen_string_literal: true

RSpec.describe FinApps::REST::PasswordResets do
  include SpecHelpers::Client

  describe '#create' do
    context 'when missing id' do
      subject { FinApps::REST::PasswordResets.new(client).create(nil) }
      it { expect { subject }.to raise_error(FinAppsCore::MissingArgumentsError) }
    end

    context 'when invalid id is provided' do
      subject { FinApps::REST::PasswordResets.new(client).create(:invalid_user_id) }

      it { expect { subject }.not_to raise_error }
      it('results is nil') { expect(subject[0]).to be_nil }
      it('error messages array is populated') { expect(subject[1]).not_to be_nil }
    end

    context 'when valid id is provided' do
      subject { FinApps::REST::PasswordResets.new(client).create(:valid_user_id) }

      it { expect { subject }.not_to raise_error }
      it('returns an array') { expect(subject).to be_a(Array) }
      it('performs a post and returns the response') { expect(subject[0]).to respond_to(:token) }
      it('returns no error messages') { expect(subject[1]).to be_empty }
    end
  end

  describe '#update' do
    let(:valid_params) { { token: 'valid_token' } }
    let(:invalid_params) { { token: 'invalid_token' } }

    context 'when missing id' do
      subject { FinApps::REST::PasswordResets.new(client).update(nil, :params) }
      it { expect { subject }.to raise_error(FinAppsCore::MissingArgumentsError) }
    end

    context 'when missing params' do
      subject { FinApps::REST::PasswordResets.new(client).update(:valid_user_id, nil) }
      it { expect { subject }.to raise_error(FinAppsCore::MissingArgumentsError) }
    end

    context 'when invalid id is provided' do
      subject { FinApps::REST::PasswordResets.new(client).update(:invalid_user_id, valid_params) }

      it { expect { subject }.not_to raise_error }
      it('results is nil') { expect(subject[0]).to be_nil }
      it('error messages array is populated') { expect(subject[1]).not_to be_nil }
    end

    context 'when invalid params are provided' do
      subject { FinApps::REST::PasswordResets.new(client).update(:valid_user_id, invalid_params) }

      it { expect { subject }.not_to raise_error }
      it('results is nil') { expect(subject[0]).to be_nil }
      it('error messages array is populated') { expect(subject[1]).not_to be_nil }
    end

    context 'when valid params are provided' do
      subject { FinApps::REST::PasswordResets.new(client).update(:valid_user_id, valid_params) }

      it { expect { subject }.not_to raise_error }
      it('returns an array') { expect(subject).to be_a(Array) }
      it('performs a post and returns the response') { expect(subject[0]).to respond_to(:token) }
      it('returns no error messages') { expect(subject[1]).to be_empty }
    end
  end
end
