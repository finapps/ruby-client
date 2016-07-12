RSpec.describe FinApps::REST::Resources do
  describe '#new' do
    context 'when client is nil' do
      subject { FinApps::REST::Resources.new(nil) }
      it { expect { subject }.to raise_error(FinApps::MissingArgumentsError, 'Missing argument: client.') }
    end

    context 'when client param is set' do
      let(:client) { FinApps::REST::Client.new :company_identifier, :company_token }
      subject { FinApps::REST::Resources.new(client) }

      it { expect { subject }.not_to raise_error }
      it('assigns @client') { expect(subject.client).to eq(client) }
    end
  end
end
