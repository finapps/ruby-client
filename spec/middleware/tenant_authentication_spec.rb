RSpec.describe FinApps::Middleware::TenantAuthentication do
  let(:valid_tenant_options) { VALID_CREDENTIALS }
  let(:key) { FinApps::Middleware::TenantAuthentication::KEY }

  describe '#call' do
    fake_app = proc {|env| env }

    context 'when company credentials were provided' do
      let(:middleware) do
        FinApps::Middleware::TenantAuthentication.new(fake_app,
                                                      VALID_CREDENTIALS[:identifier],
                                                      VALID_CREDENTIALS[:token])
      end
      let(:expected_header) { "#{valid_tenant_options[:identifier]}=#{valid_tenant_options[:token]}" }

      context 'when header was not previously set' do
        let(:request_env) { {request_headers: {}} }
        subject(:actual_header) { middleware.call(request_env)[:request_headers][key] }

        it('generates a Tenant Authentication header') { expect(actual_header).to eq(expected_header) }
      end

      context 'when header was previously set' do
        let(:existing_header) { {FinApps::Middleware::TenantAuthentication::KEY => 'foo'} }
        let(:request_env) { {request_headers: existing_header} }
        subject(:actual_header) { middleware.call(request_env)[:request_headers][key] }

        it('does not override existing Tenant Authentication header') { expect(actual_header).to eq('foo') }
        it('does not generate a Tenant Authentication header') { expect(actual_header).to_not eq(expected_header) }
      end
    end
  end
end
