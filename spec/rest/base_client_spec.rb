RSpec.describe FinApps::REST::BaseClient do
  let(:valid_tenant_options) do
    {tenant_identifier: VALID_CREDENTIALS[:identifier],
     tenant_token: VALID_CREDENTIALS[:token]}
  end
  subject { FinApps::REST::BaseClient.new(valid_tenant_options) }

  RESPONSE = 0
  ERROR_MESSAGES = 1
  let(:return_array) { %i(RESPONSE ERROR_MESSAGES) }

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
      subject { FinApps::REST::BaseClient.new(valid_tenant_options).send_request('relevance/ruleset/names', :get) }
      let(:return_array) { %i(RESPONSE ERROR_MESSAGES) }

      it('returns an array of 2 items') do
        expect(subject).to be_a(Array)
        expect(subject.size).to eq(return_array.length)
      end

      context 'for unsupported methods' do
        subject { FinApps::REST::BaseClient.new(valid_tenant_options).send_request('users', :options) }

        it do
          expect { subject.send_request(nil, :get) }
            .to raise_error(FinApps::InvalidArgumentsError, 'Method not supported: options.')
        end
      end

      context 'for client errors' do
        subject { FinApps::REST::BaseClient.new(valid_tenant_options).send_request('client_error', :get) }

        it('the result should be nil') { expect(subject[RESPONSE]).to be_nil }
        it { expect(subject[ERROR_MESSAGES]).not_to be_nil }
        it { expect(subject[ERROR_MESSAGES]).to be_a(Array) }
        it { expect(subject[ERROR_MESSAGES].length).to be > 0 }
      end

      context 'for server errors' do
        subject { FinApps::REST::BaseClient.new(valid_tenant_options).send_request('server_error', :get) }

        it('the result should be nil') { expect(subject[RESPONSE]).to be_nil }
        it { expect(subject[ERROR_MESSAGES]).not_to be_nil }
        it { expect(subject[ERROR_MESSAGES]).to be_a(Array) }
        it { expect(subject[ERROR_MESSAGES].first).to eq 'the server responded with status 500' }
      end

      context 'for proxy errors' do
        subject { FinApps::REST::BaseClient.new(valid_tenant_options).send_request('proxy_error', :get) }

        it { expect { subject }.to raise_error(Faraday::ConnectionFailed, '407 "Proxy Authentication Required"') }
      end
    end

    context 'if a block is provided' do
      it('gets executed on the response') do
        expect(subject.send_request('relevance/ruleset/names', :get, &:status)[RESPONSE]).to eq(200)
        expect(subject.send_request('relevance/ruleset/names', :get) {|r| r.body.length }[RESPONSE]).to eq(45)
      end
    end
  end
end
