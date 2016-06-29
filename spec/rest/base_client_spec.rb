RSpec.describe FinApps::REST::BaseClient do
  let(:valid_tenant_options) { {tenant_credentials: VALID_CREDENTIALS} }
  subject { FinApps::REST::BaseClient.new(valid_tenant_options) }

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
    it 'should raise FinApps::MissingArgumentsError if method is NOT provided' do
      expect { subject.send_request(nil, :get) }.to raise_error(FinApps::MissingArgumentsError)
    end

    it 'should raise FinApps::MissingArgumentsError if path is NOT provided' do
      expect { subject.send_request('fake_path', nil) }.to raise_error(FinApps::MissingArgumentsError)
    end

    context 'when method and path are provided' do
      let(:return_array) { %i(response error_messages) }
      it('returns an array of 2 items') do
        expect(subject.send_request('relevance/ruleset/names', :get)).to be_a(Array)
        expect(subject.send_request('relevance/ruleset/names', :get).size).to eq(return_array.length)
      end

      context 'if a block is provided' do
        it('gets executed on the response') do
          expect(subject.send_request('relevance/ruleset/names', :get, &:status)[0]).to eq(200)
          expect(subject.send_request('relevance/ruleset/names', :get) {|r| r.body.length }[0]).to eq(45)
        end
      end

      context 'for client errors' do
        it('the result should be nil') { expect(subject.send_request('error', :get)[0]).to be_nil }
        it { expect(subject.send_request('error', :get)[1]).not_to be_nil }
        it { expect(subject.send_request('error', :get)[1]).to be_a(Array) }
        it { expect(subject.send_request('error', :get)[1].length).to be > 0 }
      end
    end
  end
end
