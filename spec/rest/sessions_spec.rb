# frozen_string_literal: true

require 'spec_helpers/client'

RSpec.describe FinApps::REST::Sessions,
               'initialized with valid FinApps::Client object' do
  include SpecHelpers::Client
  subject(:session) { described_class.new(client) }

  describe '#create' do
    let(:create) { session.create(credentials) }
    let(:results) { create[0] }
    let(:error_messages) { create[1] }

    context 'when missing email or password' do
      message = 'Invalid argument: params.'
      it do
        expect do
          session.create(email: nil, password: 'password')
        end.to raise_error(FinAppsCore::InvalidArgumentsError, message)
      end

      it do
        expect { session.create(email: 'email', password: nil) }.to raise_error(
          FinAppsCore::InvalidArgumentsError,
          message
        )
      end
    end

    context 'with invalid credentials' do
      let(:credentials) do
        {email: 'email@domain.com', password: 'invalid_password'}
      end

      it { expect { create }.not_to raise_error }
      it('results is nil') { expect(results).to be_nil }

      error_message = 'Invalid Consumer Identifier or Credentials'
      it('error_messages are populated') do
        expect(error_messages.first).to eq(error_message)
      end
    end

    context 'with valid credentials' do
      let(:credentials) do
        {email: 'email@domain.com', password: 'valid_password'}
      end

      it('results is a Hash') { expect(results).to be_a(Hash) }
      it('token value is in the result') { expect(results).to have_key(:token) }
      it('error_messages is empty') { expect(error_messages).to be_empty }
    end

    context 'with valid credentials & path argument' do
      let(:create) { subject.create(credentials, 'operators/login') }
      let(:credentials) do
        {email: 'email@domain.com', password: 'valid_password'}
      end

      it('results is a Hash') { expect(results).to be_a(Hash) }
      it('token value is in the result') { expect(results).to have_key(:token) }

      it('returns operator for operator path') do
        expect(results).to have_key(:role)
      end

      it('error_messages is empty') { expect(error_messages).to be_empty }
    end
  end

  describe '#destroy' do
    let(:destroy) { subject.destroy }
    let(:results) { destroy[0] }
    let(:error_messages) { destroy[1] }

    it { expect { destroy }.not_to raise_error }
    it('results is nil') { expect(results).to be_nil }
    it('error_messages array is empty') { expect(error_messages).to eq([]) }
  end
end
