# frozen_string_literal: true
RSpec.describe FinApps::REST::Resources do
  let(:client) { FinApps::REST::Client.new :company_identifier, :company_token }
  describe '#new' do
    context 'when client is nil' do
      subject { FinApps::REST::Resources.new(nil) }
      it { expect { subject }.to raise_error(FinApps::MissingArgumentsError, 'Missing argument: client.') }
    end

    context 'when client is not a FinApps::REST::Client object' do
      subject { FinApps::REST::Resources.new(1) }
      it { expect { subject }.to raise_error(FinApps::InvalidArgumentsError, 'Invalid argument: client.') }
    end

    context 'when client param is set' do
      subject { FinApps::REST::Resources.new(client) }
      it { expect { subject }.not_to raise_error }
      it('assigns @client') { expect(subject.client).to eq(client) }
    end
  end

  describe '#create' do
    context 'when valid params are provided' do
      subject { FinApps::REST::Resources.new(client).create }
      it { expect { subject }.not_to raise_error }
      it('returns an array') { expect(subject).to be_a(Array) }
      it('performs a post and returns the response') { expect(subject[0]).to respond_to(:public_id) }
      it('returns no error messages') { expect(subject[1]).to be_empty }
    end
  end

  describe '#update' do
    context 'when valid params are provided' do
      subject { FinApps::REST::Resources.new(client).update }
      it { expect { subject }.not_to raise_error }
      it('returns an array') { expect(subject).to be_a(Array) }
      it('performs a put and returns the response') { expect(subject[0]).to respond_to(:public_id) }
      it('returns no error messages') { expect(subject[1]).to be_empty }
    end
  end

  describe '#show' do
    context 'when valid params are provided' do
      subject { FinApps::REST::Resources.new(client).show(:id) }
      it { expect { subject }.not_to raise_error }
      it('returns an array') { expect(subject).to be_a(Array) }
      it('performs a get and returns the response') { expect(subject[0]).to respond_to(:public_id) }
      it('returns no error messages') { expect(subject[1]).to be_empty }
    end
  end

  describe '#destroy' do
    context 'when valid params are provided' do
      subject { FinApps::REST::Resources.new(client).destroy(:id) }
      it { expect { subject }.not_to raise_error }
      it('returns an array') { expect(subject).to be_a(Array) }
      it('performs a delete and returns an empty response') { expect(subject[0]).to be_empty }
      it('returns no error messages') { expect(subject[1]).to be_empty }
    end
  end
end
