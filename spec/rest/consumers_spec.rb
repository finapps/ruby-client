# frozen_string_literal: true
require 'spec_helpers/client'

RSpec.describe FinApps::REST::Consumers, 'initialized with valid FinApps::Client object' do
  include SpecHelpers::Client
  subject(:users) { FinApps::REST::Consumers.new(client) }
  missing_public_id = 'Missing argument: public_id'

  describe '#show' do
    context 'when missing public_id' do
      it { expect { subject.show(nil) }.to raise_error(FinAppsCore::MissingArgumentsError, missing_public_id) }
    end

    context 'for valid public_id' do
      let(:show) { subject.show(:valid_public_id) }
      let(:results) { show[0] }
      let(:error_messages) { show[1] }

      it { expect { show }.not_to raise_error }
      it('results is a Hashie::Rash') { expect(results).to be_a(Hashie::Rash) }
      it('performs a get and returns the response') { expect(results).to respond_to(:public_id) }
      it('error_messages array is empty') { expect(error_messages).to eq([]) }
    end

    context 'for invalid token' do
      let(:show) { subject.show(:invalid_public_id) }
      let(:results) { show[0] }
      let(:error_messages) { show[1] }

      it { expect { show }.not_to raise_error }
      it('results is nil') { expect(results).to be_nil }
      it('error messages array is populated') { expect(error_messages.first.downcase).to eq('resource not found') }
    end
  end

  describe '#update' do
    context 'when missing public_id' do
      it { expect { subject.update(nil, {}) }.to raise_error(FinAppsCore::MissingArgumentsError, missing_public_id) }
    end

    context 'when updating user details' do
      context 'for valid public_id' do
        let(:update) { subject.update(:valid_public_id, postal_code: '33021') }
        let(:results) { update[0] }
        let(:error_messages) { update[1] }

        it { expect { update }.not_to raise_error }
        it('results is nil') { expect(results).to be_nil }
        it('error_messages array is empty') { expect(error_messages).to eq([]) }
      end

      context 'for invalid public_id' do
        let(:update) { subject.update(:invalid_public_id, postal_code: '33021') }
        let(:results) { update[0] }
        let(:error_messages) { update[1] }

        it { expect { update }.not_to raise_error }
        it('results is nil') { expect(results).to be_nil }
        it('error messages array is populated') do
          expect(error_messages.first.downcase).to eq('invalid user id specified.')
        end
      end
    end

    context 'when updating password' do
      context 'for valid public_id' do
        let(:update) { subject.update(:valid_public_id, password: 'Aa123456!', password_confirm: 'Aa123456!') }
        let(:results) { update[0] }
        let(:error_messages) { update[1] }

        it { expect { update }.not_to raise_error }
        it('results is a Hashie::Rash') { expect(results).to be_a(Hashie::Rash) }
        it('the public_id is on the results') { expect(results).to respond_to(:public_id) }
        it('the new token is on the results') { expect(results).to respond_to(:token) }
        it('error_messages array is empty') { expect(error_messages).to eq([]) }
      end

      context 'for invalid public_id' do
        let(:update) { subject.update(:invalid_public_id, password: 'Aa123456!', password_confirm: 'Aa123456!') }
        let(:results) { update[0] }
        let(:error_messages) { update[1] }

        it { expect { update }.not_to raise_error }
        it('results is nil') { expect(results).to be_nil }
        it('error messages array is populated') { expect(error_messages.first.downcase).to eq('resource not found') }
      end
    end

    describe '#destroy' do
      context 'when missing public_id' do
        it { expect { subject.destroy(nil) }.to raise_error(FinAppsCore::MissingArgumentsError, missing_public_id) }
      end

      context 'for valid public_id' do
        let(:destroy) { subject.destroy(:valid_public_id) }
        let(:results) { destroy[0] }
        let(:error_messages) { destroy[1] }

        it { expect { destroy }.not_to raise_error }
        it('results is nil') { expect(results).to be_nil }
        it('error_messages array is empty') { expect(error_messages).to eq([]) }
      end

      context 'for invalid token' do
        let(:destroy) { subject.destroy(:invalid_public_id) }
        let(:results) { destroy[0] }
        let(:error_messages) { destroy[1] }

        it { expect { destroy }.not_to raise_error }
        it('results is nil') { expect(results).to be_nil }
        it('error messages array is populated') { expect(error_messages.first.downcase).to eq('resource not found') }
      end
    end
  end
end