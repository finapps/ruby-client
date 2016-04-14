RSpec.describe FinApps::REST::Connection do

  let(:dummy_class) { Class.new { extend FinApps::REST::Connection } }
  let(:valid_credentials) { {:company_identifier => 'id', :company_token => 'token'} }

  it { expect(dummy_class).to respond_to(:set_up_connection) }

  describe '#set_up_connection' do

    context 'when using valid company credentials' do
      subject(:set_up_connection) { dummy_class.set_up_connection(valid_credentials, {}) }
      it { expect(set_up_connection).to be_an_instance_of(Faraday::Connection) }
      it { expect(set_up_connection.headers).to include({'Accept' => FinApps::REST::Defaults::HEADERS[:accept]}) }
      it { expect(set_up_connection.headers).to include({'User-Agent' => FinApps::REST::Defaults::HEADERS[:user_agent]}) }
      context 'when NOT providing user credentials' do
        it { expect(set_up_connection.builder.handlers).not_to include(Faraday::Request::BasicAuthentication) }
      end
    end

    context 'when using valid user credentials' do
      user_credentials = {:user_identifier => 'user_id', :user_token => 'user_token'}
      subject(:set_up_connection) { dummy_class.set_up_connection(valid_credentials, user_credentials) }

      it { expect(set_up_connection.builder.handlers).to include(Faraday::Request::BasicAuthentication) }
      it 'sets a proper authorization header' do
        stub_request(:get, "#{FinApps::REST::Defaults::DEFAULTS[:host]}/auth-echo").
            to_return(:status => 200,
                      :body => '',
                      :headers => {})

        response = set_up_connection.get('/auth-echo')
        expect(response.env.request_headers).to include({:Authorization => 'Basic dXNlcl9pZDp1c2VyX3Rva2Vu'})
      end
    end

    context 'using an invalid host_url parameter' do
      subject(:set_up_connection) { dummy_class.set_up_connection(valid_credentials, {:host => 'yahoo.com'}) }
      it { expect { set_up_connection }.to raise_error(FinApps::REST::InvalidArgumentsError) }
    end

  end
end
