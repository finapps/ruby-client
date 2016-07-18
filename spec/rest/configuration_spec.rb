# frozen_string_literal: true
RSpec.describe FinApps::REST::Configuration do
  describe '#new' do
    context 'for invalid timeout configuration' do
      subject { FinApps::REST::Configuration.new(timeout: 'whatever') }
      it { expect { subject }.to raise_error(FinApps::InvalidArgumentsError, 'Invalid argument. {timeout: whatever}') }
    end

    context 'for missing timeout configuration' do
      subject { FinApps::REST::Configuration.new(timeout: nil) }
      it 'should have a default timeout value' do
        expect(subject.timeout).to eq(FinApps::REST::Defaults::DEFAULTS[:timeout])
      end
    end

    context 'for invalid host configuration' do
      subject { FinApps::REST::Configuration.new(host: 'whatever') }
      it { expect { subject }.to raise_error(FinApps::InvalidArgumentsError, 'Invalid argument. {host: whatever}') }
    end

    context 'for missing host configuration' do
      subject { FinApps::REST::Configuration.new(host: nil) }
      it 'should have a default host value' do
        expect(subject.host).to eq(FinApps::REST::Defaults::DEFAULTS[:host])
      end
    end
  end
end
