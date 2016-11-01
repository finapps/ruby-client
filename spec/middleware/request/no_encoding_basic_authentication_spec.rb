# frozen_string_literal: true
RSpec.describe FinApps::Middleware::NoEncodingBasicAuthentication do
  let(:valid_credentials) { VALID_CREDENTIALS }
  let(:key) { FinApps::Middleware::NoEncodingBasicAuthentication::KEY }

  describe '#call' do
    fake_app = proc {|env| env }

    context 'when credentials were provided' do
      let(:middleware) do
        FinApps::Middleware::NoEncodingBasicAuthentication.new(fake_app, VALID_CREDENTIALS[:token])
      end
      let(:expected_header) { "Basic #{valid_credentials[:token]}" }

      context 'when header was not previously set' do
        let(:request_env) { {request_headers: {}} }
        subject(:actual_header) { middleware.call(request_env)[:request_headers][key] }

        it('generates a header') { expect(actual_header).to eq(expected_header) }
      end

      context 'when header was previously set' do
        let(:existing_header) { {FinApps::Middleware::NoEncodingBasicAuthentication::KEY => 'foo'} }
        let(:request_env) { {request_headers: existing_header} }
        subject(:actual_header) { middleware.call(request_env)[:request_headers][key] }

        it('does not override existing header') { expect(actual_header).to eq('foo') }
        it('does not generate a header') { expect(actual_header).to_not eq(expected_header) }
      end
    end
  end
end
