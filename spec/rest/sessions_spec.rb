# frozen_string_literal: true

require 'spec_helpers/client'

RSpec.describe FinApps::REST::Sessions, 'initialized with valid FinApps::Client object' do
  include SpecHelpers::Client

  describe '#create' do
    subject { FinApps::REST::Sessions.new(client) }
    let(:create) { subject.create(credentials) }
    let(:results) { create[0] }
    let(:error_messages) { create[1] }

    context 'when missing email or password' do
      message = 'Invalid argument: params.'
      it do
        expect { subject.create(email: nil, password: 'password') }
          .to raise_error(FinAppsCore::InvalidArgumentsError, message)
      end
      it do
        expect { subject.create(email: 'email', password: nil) }
          .to raise_error(FinAppsCore::InvalidArgumentsError, message)
      end
    end

    context 'for invalid credentials' do
      let(:credentials) { {email: 'email@domain.com', password: 'invalid_password'} }

      it { expect { create }.not_to raise_error }
      it('results is nil') { expect(results).to be_nil }
      error_message = 'Invalid User Identifier or Credentials'
      it('error_messages are populated') { expect(error_messages.first).to eq(error_message) }
    end

    context 'for valid credentials' do
      let(:credentials) { {email: 'email@domain.com', password: 'valid_password'} }

      it('results is a Hashie::Rash') { expect(results).to be_a(Hashie::Mash::Rash) }
      it('token value is in the result') { expect(results).to respond_to(:token) }
      it('error_messages is empty') { expect(error_messages).to be_empty }
    end

    context 'for valid credentials & path argument' do
      let(:create) { subject.create(credentials, 'operators/login') }
      let(:credentials) { {email: 'email@domain.com', password: 'valid_password'} }

      it('results is a Hashie::Rash') { expect(results).to be_a(Hashie::Mash::Rash) }
      it('token value is in the result') { expect(results).to respond_to(:token) }
      it('returns operator for operator path') { expect(results).to respond_to(:role) }
      it('error_messages is empty') { expect(error_messages).to be_empty }
    end
  end
end
