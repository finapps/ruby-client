# frozen_string_literal: true
RSpec.describe FinApps::REST::UserInstitutions do
  let(:client) { FinApps::REST::Client.new(:company_identifier, :company_token) }
  describe '#list' do
    context 'when successful' do
      subject { FinApps::REST::UserInstitutions.new(client).list }

      it('returns an array') { expect(subject).to be_a(Array) }
      it('performs a get and returns array of user institutions') { expect(subject[0]).to be_a(Array) }
      it('returns no error messages') { expect(subject[1]).to be_empty }
    end
  end

  describe '#create' do
    subject(:institutions) { FinApps::REST::UserInstitutions.new(client) }

    context 'when missing site_id' do
      let(:create) { subject.create(nil, :params) }
      it { expect { create }.to raise_error(FinApps::MissingArgumentsError) }
    end

    context 'when missing params' do
      let(:create) { subject.create(:site_id, nil) }
      it { expect { create }.to raise_error(FinApps::MissingArgumentsError) }
    end

    context 'when valid site_id and params are provided' do
      let(:create) { subject.create('valid_site_id', :params) }

      it { expect { create }.not_to raise_error }
      it('performs a post and returns the response') { expect(create[0]).to respond_to(:user_institution) }
      it('returns no error messages') { expect(create[1]).to be_empty }
    end

    # No tests for invalid site_id/params because of API/Yodlee flow
  end

  describe '#show' do
    context 'when missing id' do
      subject { FinApps::REST::UserInstitutions.new(client).show(nil) }
      it { expect { subject }.to raise_error(FinApps::MissingArgumentsError) }
    end

    context 'when valid id is provided' do
      subject { FinApps::REST::UserInstitutions.new(client).show('valid_id') }

      it { expect { subject }.not_to raise_error }
      it('returns an array') { expect(subject).to be_a(Array) }
      it('performs a get and returns the response') { expect(subject[0]).to respond_to(:_id) }
      it('returns no error messages') { expect(subject[1]).to be_empty }
    end

    context 'when invalid id is provided' do
      subject { FinApps::REST::UserInstitutions.new(client).show('invalid_id') }

      it { expect { subject }.not_to raise_error }
      it('results is nil') { expect(subject[0]).to be_nil }
      it('error messages array is populated') { expect(subject[1].first.downcase).to eq('invalid user institution id') }
    end
  end

  describe '#mfa_update' do
    context 'when missing id' do
      subject { FinApps::REST::UserInstitutions.new(client).mfa_update(nil, :params) }
      it { expect { subject }.to raise_error(FinApps::MissingArgumentsError) }
    end

    context 'when missing params' do
      subject { FinApps::REST::UserInstitutions.new(client).mfa_update(:id, nil) }
      it { expect { subject }.to raise_error(FinApps::MissingArgumentsError) }
    end

    context 'when valid id and params are provided' do
      subject { FinApps::REST::UserInstitutions.new(client).mfa_update('valid_id', :params) }

      it { expect { subject }.not_to raise_error }
      it('performs a post and returns the response') { expect(subject[0]).to respond_to(:user_institution) }
      it('returns no error messages') { expect(subject[1]).to be_empty }
    end

    context 'when invalid id is provided w/ params' do
      subject { FinApps::REST::UserInstitutions.new(client).mfa_update('invalid_id', :params) }

      it { expect { subject }.not_to raise_error }
      it('results is nil') { expect(subject[0]).to be_nil }
      it('error messages array is populated') { expect(subject[1].first.downcase).to eq('invalid user institution id') }
    end
  end

  describe '#credentials_update' do
    context 'when missing id' do
      subject { FinApps::REST::UserInstitutions.new(client).credentials_update(nil, :params) }
      it { expect { subject }.to raise_error(FinApps::MissingArgumentsError) }
    end

    context 'when missing params' do
      subject { FinApps::REST::UserInstitutions.new(client).credentials_update(:id, nil) }
      it { expect { subject }.to raise_error(FinApps::MissingArgumentsError) }
    end

    context 'when valid id and params are provided' do
      subject { FinApps::REST::UserInstitutions.new(client).credentials_update('valid_id', :params) }

      it { expect { subject }.not_to raise_error }
      it('performs a post and returns the response') { expect(subject[0]).to respond_to(:user_institution) }
      it('returns no error messages') { expect(subject[1]).to be_empty }
    end

    context 'when invalid id is provided w/ params' do
      subject { FinApps::REST::UserInstitutions.new(client).credentials_update('invalid_id', :params) }

      it { expect { subject }.not_to raise_error }
      it('results is nil') { expect(subject[0]).to be_nil }
      it('error messages array is populated') { expect(subject[1].first.downcase).to eq('invalid user institution id') }
    end
  end

  describe '#destroy' do
    context 'when missing id' do
      subject { FinApps::REST::UserInstitutions.new(client).destroy(nil) }
      it { expect { subject }.to raise_error(FinApps::MissingArgumentsError) }
    end

    context 'when valid id is provided' do
      subject { FinApps::REST::UserInstitutions.new(client).destroy('valid_id') }

      it { expect { subject }.not_to raise_error }
      it('returns an array') { expect(subject).to be_a(Array) }
      it('performs a delete and returns empty response') { expect(subject[0]).to be_nil }
      it('returns no error messages') { expect(subject[1]).to be_empty }
    end

    context 'when invalid id is provided' do
      subject { FinApps::REST::UserInstitutions.new(client).destroy('invalid_id') }

      it { expect { subject }.not_to raise_error }
      it('returns an array') { expect(subject).to be_a(Array) }
      it('results is nil') { expect(subject[0]).to be_nil }
      it('error messages array is populated') { expect(subject[1].first.downcase).to eq('invalid user institution id') }
    end
  end
end
