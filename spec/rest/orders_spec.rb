# frozen_string_literal: true
RSpec.describe FinApps::REST::Orders do
  let(:client) { FinApps::REST::Client.new(:company_identifier, :company_token) }
  describe '#show' do
    context 'when missing params' do
      subject { FinApps::REST::Orders.new(client).show(nil) }
      it { expect { subject }.to raise_error(FinApps::MissingArgumentsError) }
    end

    context 'when valid params are provided' do
      subject { FinApps::REST::Orders.new(client).show(:id) }

      it { expect { subject }.not_to raise_error }
      it('returns an array') { expect(subject).to be_a(Array) }
      it('performs a post and returns the response') { expect(subject[0]).to respond_to(:public_id) }
      it('returns no error messages') { expect(subject[1]).to be_empty }
    end
  end

  describe '#list' do
    context 'when missing params' do
      # use defaults

      subject { FinApps::REST::Orders.new(client).list(nil) }
      it { expect { subject }.not_to raise_error }

      it('returns an array') { expect(subject).to be_a(Array) }
      it('performs a get and returns the response') { expect(subject[0]).to respond_to(:orders) }
      it('returns no error messages') { expect(subject[1]).to be_empty }
    end
  end

  describe '#update' do
    subject(:orders) { FinApps::REST::Orders.new(client) }

    context 'when missing id' do
      let(:update) { subject.update(nil, :params) }
      it ('returns missing argument error') { expect { update }.to raise_error(FinApps::MissingArgumentsError) }
    end

    context 'when missing params' do
      let(:update) { subject.update(:id, nil) }
      it ('returns missing argument error') { expect { update }.to raise_error(FinApps::MissingArgumentsError) }
    end

    context 'when valid id and params are provided' do
      let(:update) { subject.update(:id, accounts: []) } #how to stub params
      let(:results) { update[0] }
      let(:error_messages) { update[1] }

      it { expect { update }.not_to raise_error }
      it('results is nil') { expect(results).to be_nil }
      it('error_messages array is empty') { expect(error_messages).to eq([]) }
    end

    context 'when invalid id is provided' do
      let(:update) { subject.update(:invalid_id, accounts: []) }
      let(:results) { update[0] }
      let(:error_messages) { update[1] }

      it { expect { update }.not_to raise_error }
      it('results is nil') { expect(results).to be_nil }
      it('error messages array is populated') { expect(error_messages.first.downcase).to eq('the server responded with status 404') }
    end

    context 'when invalid params are provided' do
      let(:update) { subject.update(:id, :invalid_params) }
      let(:results) { update[0] }
      let(:error_messages) { update[1] }

      it { expect { update }.not_to raise_error }
      it('results is nil') { expect(results).to be_nil }
      it('error messages array is populated') { expect(error_messages.first.downcase).to eq('the server responded with status 400') }

    end
  end
end
