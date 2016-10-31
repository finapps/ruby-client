# frozen_string_literal: true
RSpec.describe FinApps::Middleware::NoEncodingBasicAuthentication do
  let(:valid_credentials) { VALID_CREDENTIALS }

  describe '.header' do
    it 'does not encode the values' do
      actual_token = FinApps::Middleware::NoEncodingBasicAuthentication.header(valid_credentials[:token])
      expect(actual_token).to eq("Basic #{valid_credentials[:token]}")
    end
  end
end
