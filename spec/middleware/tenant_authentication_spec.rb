RSpec.describe FinApps::Middleware::TenantAuthentication do
  describe '#call' do
    fake_app = proc {|env| env }
    valid_credentials = {company_identifier: 'id', company_token: 'token'}

    context 'when company credentials were provided' do
      let(:middleware) { FinApps::Middleware::TenantAuthentication.new fake_app, valid_credentials }
      let(:generated_header) { "#{valid_credentials[:company_identifier]}=#{valid_credentials[:company_token]}" }

      context 'when header was not previously set' do
        let(:request_env) { {request_headers: {}} }
        subject(:header) do
          middleware.call(request_env)[:request_headers][FinApps::Middleware::TenantAuthentication::KEY]
        end

        it('generates a Tenant Authentication header') { expect(header).to eq(generated_header) }
      end

      context 'when header was previously set' do
        let(:existing_header) { {FinApps::Middleware::TenantAuthentication::KEY => 'foo'} }
        let(:request_env) { {request_headers: existing_header} }
        subject(:header) do
          middleware.call(request_env)[:request_headers][FinApps::Middleware::TenantAuthentication::KEY]
        end

        it('does not override existing Tenant Authentication header') { expect(header).to eq('foo') }
        it('does not generate a Tenant Authentication header') { expect(header).to_not eq(generated_header) }
      end
    end
  end
end
