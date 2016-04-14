RSpec.describe FinApps::REST::Connection do

  let(:dummy_class) { Class.new { extend FinApps::REST::Connection } }
  valid_credentials = {:company_identifier => 'id', :company_token => 'token'}

  it { expect(dummy_class).to respond_to(:set_up_connection) }

  describe '#set_up_connection' do

    context 'when using valid company credentials' do
      subject(:set_up_connection) { dummy_class.set_up_connection(valid_credentials, {}) }
      it { expect(set_up_connection).to be_an_instance_of(Faraday::Connection) }
      it { expect(set_up_connection.headers).to include({'Accept' => 'application/json'}) }
      it { expect(set_up_connection.headers).to include({'User-Agent' => FinApps::REST::Defaults::HEADERS[:user_agent]}) }
    end



    context 'using an invalid host_url parameter' do
      subject(:set_up_connection) { dummy_class.set_up_connection(valid_credentials, {:host => 'yahoo.com'}) }
      it { expect { set_up_connection }.to raise_error(FinApps::REST::InvalidArgumentsError) }
    end

  end
end
