RSpec.describe FinApps::REST::Resources do
  let(:client) { FinApps::REST::Client.new :company_identifier, :company_token }
  describe '#new' do
    context 'when client is nil' do
      subject { FinApps::REST::Resources.new(nil) }
      it { expect { subject }.to raise_error(FinApps::MissingArgumentsError, 'Missing argument: client.') }
    end

    context 'when client param is set' do
      subject { FinApps::REST::Resources.new(client) }
      it { expect { subject }.not_to raise_error }
      it('assigns @client') { expect(subject.client).to eq(client) }
    end
  end

  describe '#create' do
    context 'when valid params are provided' do
      subject { FinApps::REST::Resources.new(client) }
      it { expect { subject.create }.not_to raise_error }
      it('returns an array') { expect(subject.create).to be_a(Array) }
      it('performs a post and returns the response') { expect(subject.create[0]).to respond_to(:public_id) }
      it('returns no error messages') { expect(subject.create[1]).to be_empty }
    end
  end

  describe '#show' do
    context 'when valid params are provided' do
      subject { FinApps::REST::Resources.new(client).show(:id) }
      it { expect { subject }.not_to raise_error }
      it('returns an array') { expect(subject).to be_a(Array) }
      it('performs a post and returns the response') { expect(subject[0]).to respond_to(:public_id) }
      it('returns no error messages') { expect(subject[1]).to be_empty }
    end
  end
end
