RSpec.describe FinApps::Middleware::TenantAuthentication do
  describe '#call' do
    fake_app = proc {|env| env }
    valid_credentials = {company_identifier: 'id', company_token: 'token'}

    context 'when company credentials were provided' do
      let(:middleware) { FinApps::Middleware::TenantAuthentication.new fake_app, valid_credentials }
      let(:request_env) { {request_headers: {}} }
      let(:expected_header_value) { "#{valid_credentials[:company_identifier]}=#{valid_credentials[:company_token]}" }

      subject(:result) { middleware.call(request_env) }

      it('does not raise') { expect { result }.not_to raise_error }

      it 'should generate the X-FinApps-Token header' do
        header = result[:request_headers][FinApps::Middleware::TenantAuthentication::TENANT_AUTHENTICATION_HEADER]
        expect(header).to eq(expected_header_value)
      end
    end
  end
end
