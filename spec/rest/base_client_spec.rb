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
    context 'when path is NOT provided' do
      it { expect { subject.send_request(nil, :get) }.to raise_error(FinApps::REST::MissingArgumentsError) }
    end
    context 'when method is NOT provided' do
      it { expect { subject.send_request('fake_path', nil) }.to raise_error(FinApps::REST::MissingArgumentsError) }
    end

    context 'for a valid get request' do
      it('returns an array of 2 items') do
        expect(subject.send_request('relevance/ruleset/names', :get)).to be_a(Array)
        expect(subject.send_request('relevance/ruleset/names', :get).size).to eq(2)
      end

      context 'if a block is provided' do
        it('gets executed with the response as a parameter') do
          expect(subject.send_request('relevance/ruleset/names', :get, &:status)[0]).to eq(200)
        end
      end
    end

    context 'for an invalid get request' do
      it('returns an array of 2 items') do
        expect(subject.send_request('not_found', :get)).to be_a(Array)
        expect(subject.send_request('not_found', :get).size).to eq(2)
      end

      context 'if a block is provided' do
        it('gets executed with the response as a parameter') do
          expect(subject.send_request('not_found', :get, &:status)[0]).to eq(404)
        end
      end
    end
  end
end
