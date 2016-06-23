RSpec.describe FinApps::REST::Configuration do
  describe '#new' do
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
      subject { FinApps::REST::Configuration.new(user_credentials: user_credentials) }
      it('should have user_credentials') { expect(subject.user_credentials).to eq(user_credentials) }
      it('user_credentials are valid') { expect(subject.valid_user_credentials?).to eq true }
    end

    context 'for missing user credentials' do
      let(:user_credentials) { nil }
      subject { FinApps::REST::Configuration.new(user_credentials: user_credentials) }

      it('user_credentials are not valid') { expect(subject.valid_user_credentials?).to eq false }
    end

    context 'for invalid user credentials' do
      let(:user_credentials) { {identifier: nil, token: nil} }
      subject { FinApps::REST::Configuration.new(user_credentials: user_credentials) }

      it('user_credentials are not valid') { expect(subject.valid_user_credentials?).to eq false }
    end

    context 'when valid host is provided' do
      subject { FinApps::REST::Configuration.new(host: nil) }

      it('should have a default host') { expect(subject.host).to eq(FinApps::REST::Defaults::DEFAULTS[:host]) }
      it('versioned_url should include version') do
        expect(subject.versioned_url).to eq("#{subject.host}/v#{FinApps::REST::Defaults::API_VERSION}")
      end
    end
  end
end
