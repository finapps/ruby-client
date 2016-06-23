RSpec.describe FinApps::REST::Configuration do
  describe '#new' do
    it 'should have a default host' do
      config = FinApps::REST::Configuration.new(host: nil)
      expect(config.host).to eq(FinApps::REST::Defaults::DEFAULTS[:host])
    end

    it 'raises for invalid host values' do
      expect { FinApps::REST::Configuration.new(host: 'whatever') }
        .to raise_error(FinApps::REST::InvalidArgumentsError)
    end

    it 'should have a default timeout value' do
      config = FinApps::REST::Configuration.new(timeout: nil)
      expect(config.timeout).to eq(FinApps::REST::Defaults::DEFAULTS[:timeout])
    end

    it 'raises for invalid timeout values' do
      expect { FinApps::REST::Configuration.new(timeout: 'whatever') }
        .to raise_error(FinApps::REST::InvalidArgumentsError)
    end

    context 'when valid user credentials were provided' do
      let(:user_credentials) { {identifier: 1, token: 2} }
      it 'should have user_credentials' do
        config = FinApps::REST::Configuration.new(user_credentials: user_credentials)
        expect(config.user_credentials).to eq(user_credentials)
      end

      it 'user_credentials are valid' do
        config = FinApps::REST::Configuration.new(user_credentials: user_credentials)
        expect(config.valid_user_credentials?).to eq true
      end
    end

    context 'when valid user credentials were not provided' do
      let(:user_credentials) { {identifier: nil, token: nil} }

      it 'user_credentials are not valid' do
        config = FinApps::REST::Configuration.new(user_credentials: user_credentials)
        expect(config.valid_user_credentials?).to eq false
      end
    end
  end
end
