RSpec.describe FinApps::REST::Client do
  subject { FinApps::REST::BaseClient.new }

  describe '#new' do
    it 'assigns @config' do
      expect(subject.config).to be_a(FinApps::REST::Configuration)
    end
  end

  describe '#connection' do
    it 'created a Faraday connection object' do
      expect(subject.connection).to be_a(Faraday::Connection)
    end

    it 'memoizes the results' do
      first = subject.connection
      second = subject.connection
      expect(first.object_id).to eq(second.object_id)
    end
  end

  describe '#send_request' do
    context 'when path is NOT provided' do
      it { expect { subject.send_request(nil, :get) }.to raise_error(FinApps::REST::MissingArgumentsError) }
    end
    context 'when method is NOT provided' do
      it { expect { subject.send_request('/fake_path/', nil) }.to raise_error(FinApps::REST::MissingArgumentsError) }
    end

    context 'when a get request is provided' do
      it { expect { subject.send_request('/', :get) }.to raise_error(FinApps::REST::MissingArgumentsError) }
    end
  end
end
