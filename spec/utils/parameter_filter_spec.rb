# frozen_string_literal: true
class FakeClass
  include ::FinApps::Utils::ParameterFilter
end

RSpec.describe FinApps::Utils::ParameterFilter do
  describe '#skip_sensitive_data' do
    context 'when provided with sensitive data' do
      let(:unfiltered_params) do
        {password: 'FinApps@123', password_confirm: 'FinApps@123', token: '123456',
         login: 'sammysosa', username: 'johnny', name: 'george'}
      end
      let(:filtered_params) do
        {password: '[REDACTED]', password_confirm: '[REDACTED]', token: '[REDACTED]',
         login: '[REDACTED]', username: '[REDACTED]', name: 'george'}
      end

      it 'filters out sensitive values' do
        expect(FakeClass.new.skip_sensitive_data(unfiltered_params)).to eq(filtered_params)
      end
    end
  end
end
