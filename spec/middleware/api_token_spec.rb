RSpec.describe FinApps::Middleware::ApiToken do

  describe '#call' do

    fake_app = Proc.new { |env| env }
    valid_credentials = {:company_identifier => 'id', :company_token => 'token'}

    context 'when company_identifier is NOT provided' do
      let(:api_token) { FinApps::Middleware::ApiToken.new fake_app, valid_credentials.select { |x| x!= :company_identifier } }
      it { expect { api_token.call({}) }.to raise_error(FinApps::REST::MissingArgumentsError) }
    end

    context 'when company_token is NOT provided' do
      let(:api_token) { FinApps::Middleware::ApiToken.new fake_app, valid_credentials.select { |x| x!= :company_token } }
      it { expect { api_token.call({}) }.to raise_error(FinApps::REST::MissingArgumentsError) }
    end

    context 'when company credentials were provided' do

      let(:api_token) { FinApps::Middleware::ApiToken.new fake_app, valid_credentials }
      let(:expected_header_value) { "#{valid_credentials[:company_identifier]}=#{valid_credentials[:company_token]}" }
      subject(:call) { api_token.call({:request_headers => {}}) }

      it { expect { call }.not_to raise_error }
      it 'should generate the X-FinApps-Token header' do
        expect(call[:request_headers]['X-FinApps-Token']).to eq(expected_header_value)
      end
    end

  end
end

