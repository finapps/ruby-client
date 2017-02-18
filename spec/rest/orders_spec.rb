# frozen_string_literal: true
RSpec.describe FinApps::REST::Orders do
  include SpecHelpers::Client
  
  RESULTS = 0
  ERROR_MESSAGES = 1

  describe '#show' do
    context 'when missing params' do
      subject { FinApps::REST::Orders.new(client).show(nil) }
      it { expect { subject }.to raise_error(FinAppsCore::MissingArgumentsError) }
    end

    context 'when valid params are provided' do
      subject { FinApps::REST::Orders.new(client).show(:valid_id) }

      it { expect { subject }.not_to raise_error }
      it('returns an array') { expect(subject).to be_a(Array) }
      it('performs a get and returns the response') do
        expect(subject[RESULTS]).to respond_to(:public_id)
        expect(subject[RESULTS]).to respond_to(:consumer_id)
      end
      it('returns no error messages') { expect(subject[ERROR_MESSAGES]).to be_empty }
    end
  end

  describe '#create' do
    context 'when missing params' do
      subject { FinApps::REST::Orders.new(client).create(nil) }
      it { expect { subject }.to raise_error(FinAppsCore::MissingArgumentsError) }
    end

    context 'when valid params are provided' do
      subject { FinApps::REST::Orders.new(client).create(valid_params) }
      let(:valid_params) { {applicant: 'valid', institutions: 'valid', product: 'valid'} }

      it { expect { subject }.not_to raise_error }
      it('returns an array') { expect(subject).to be_a(Array) }
      it('performs a post and returns the response') do
        expect(subject[RESULTS]).to respond_to(:public_id)
        expect(subject[RESULTS]).to respond_to(:consumer_id)
      end
      it('returns no error messages') { expect(subject[ERROR_MESSAGES]).to be_empty }
    end

    context 'when invalid params are provided' do
      subject { FinApps::REST::Orders.new(client).create(invalid_params) }
      let(:invalid_params) { {applicant: 'valid'} }

      it { expect { subject }.not_to raise_error }
      it('results is nil') { expect(subject[RESULTS]).to be_nil }
      it('error messages array is populated') { expect(subject[ERROR_MESSAGES].first.downcase).to eq('invalid request body') }
    end
  end

  describe '#list' do
    context 'when missing params' do
      # use defaults

      subject { FinApps::REST::Orders.new(client).list(nil) }
      it { expect { subject }.not_to raise_error }

      it('returns an array') { expect(subject).to be_a(Array) }
      it('performs a get and returns the response') { expect(subject[RESULTS]).to respond_to(:orders) }
      it('returns no error messages') { expect(subject[ERROR_MESSAGES]).to be_empty }
    end

    context 'when including partial params' do
      subject { FinApps::REST::Orders.new(client).list(params) }
      let(:params) { {page: 2, sort: 'status'} }

      it { expect { subject }.not_to raise_error }
      it('returns an array') { expect(subject).to be_a(Array) }
      it('performs a get and returns the response') { expect(subject[RESULTS]).to respond_to(:orders) }
      it('each order contains a consumer_id') { expect(subject[RESULTS].orders).to all(respond_to(:consumer_id)) }
      it('returns no error messages') { expect(subject[ERROR_MESSAGES]).to be_empty }
    end
  end

  describe '#update' do
    subject(:orders) { FinApps::REST::Orders.new(client) }

    context 'when missing id' do
      let(:update) { subject.update(nil, :params) }
      it('returns missing argument error') { expect { update }.to raise_error(FinAppsCore::MissingArgumentsError) }
    end

    context 'when missing params' do
      let(:update) { subject.update(:id, nil) }
      it('returns missing argument error') { expect { update }.to raise_error(FinAppsCore::MissingArgumentsError) }
    end

    context 'when valid id and params are provided' do
      let(:update) { subject.update('valid_id', accounts: 'valid_account') } # how to stub params
      let(:results) { update[RESULTS] }
      let(:error_messages) { update[ERROR_MESSAGES] }

      it { expect { update }.not_to raise_error }
      it('results is nil') { expect(results).to be_nil }
      it('error_messages array is empty') { expect(error_messages).to eq([]) }
    end

    context 'when invalid id is provided' do
      let(:update) { subject.update('invalid_id', :params) }
      let(:results) { update[RESULTS] }
      let(:error_messages) { update[ERROR_MESSAGES] }

      it { expect { update }.not_to raise_error }
      it('results is nil') { expect(results).to be_nil }
      it('error messages array is populated') { expect(error_messages.first.downcase).to eq('resource not found') }
    end

    context 'when invalid params are provided' do
      let(:update) { subject.update('valid_id', accounts: 'invalid_account') }
      let(:results) { update[RESULTS] }
      let(:error_messages) { update[ERROR_MESSAGES] }

      it { expect { update }.not_to raise_error }
      it('results is nil') { expect(results).to be_nil }
      it('error messages array is populated') { expect(error_messages.first.downcase).to eq('invalid request body') }
    end
  end
end
