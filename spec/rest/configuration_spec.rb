RSpec.describe FinApps::REST::Configuration do
  describe '#new' do
    it 'raises for missing tenant credentials' do
      expect { FinApps::REST::Configuration.new({}) }
        .to raise_error(FinApps::MissingArgumentsError, 'Missing tenant_credentials.')
    end

    it 'raises for invalid tenant credentials (identifier)' do
      expect { FinApps::REST::Configuration.new(tenant_credentials: {token: :token}) }
        .to raise_error(FinApps::MissingArgumentsError, 'Missing tenant_credentials.')
    end

    it 'raises for invalid tenant credentials (token)' do
      expect { FinApps::REST::Configuration.new(tenant_credentials: {identifier: :identifier}) }
        .to raise_error(FinApps::MissingArgumentsError, 'Missing tenant_credentials.')
    end

    context 'for valid tenant credentials' do
      let(:valid_tenant_options) { {tenant_credentials: VALID_CREDENTIALS} }

      context 'when valid user credentials were provided' do
        let(:valid_creds) { valid_tenant_options.merge(user_credentials: VALID_CREDENTIALS) }
        subject { FinApps::REST::Configuration.new(valid_creds) }
        it('should have user_credentials') { expect(subject.user_credentials).to eq(VALID_CREDENTIALS) }
        it('user_credentials are valid') { expect(subject.valid_user_credentials?).to eq true }
      end

      context 'for missing user credentials' do
        subject { FinApps::REST::Configuration.new(valid_tenant_options) }
        it('user_credentials are not valid') { expect(subject.valid_user_credentials?).to eq false }
      end

      context 'for invalid user credentials (token)' do
        let(:invalid_user_creds) { {identifier: :identifier, token: ''} }
        subject { FinApps::REST::Configuration.new(valid_tenant_options.merge(user_credentials: invalid_user_creds)) }

        it('user_credentials are not valid') { expect(subject.valid_user_credentials?).to eq false }
      end

      context 'for invalid user credentials (identifier)' do
        let(:invalid_user_creds) { {identifier: '', token: :token} }
        subject { FinApps::REST::Configuration.new(valid_tenant_options.merge(user_credentials: invalid_user_creds)) }

        it('user_credentials are not valid') { expect(subject.valid_user_credentials?).to eq false }
      end

      it 'raises for invalid timeout values' do
        expect { FinApps::REST::Configuration.new(valid_tenant_options.merge(timeout: 'whatever')) }
          .to raise_error(FinApps::InvalidArgumentsError, 'Invalid argument. {timeout: whatever}')
      end

      context 'for valid timeout' do
        subject { FinApps::REST::Configuration.new(valid_tenant_options.merge(timeout: nil)) }
        it 'should have a default timeout value' do
          config = FinApps::REST::Configuration.new(valid_tenant_options.merge(timeout: nil))
          expect(config.timeout).to eq(FinApps::REST::Defaults::DEFAULTS[:timeout])
        end
      end

      it 'raises for invalid host values' do
        expect { FinApps::REST::Configuration.new(valid_tenant_options.merge(host: 'whatever')) }
          .to raise_error(FinApps::InvalidArgumentsError, 'Invalid argument. {host: whatever}')
      end

      context 'for valid host' do
        subject { FinApps::REST::Configuration.new(valid_tenant_options.merge(host: nil)) }

        it('should have a default host') { expect(subject.host).to eq(FinApps::REST::Defaults::DEFAULTS[:host]) }
      end
    end
  end
end
