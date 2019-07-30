# frozen_string_literal: true

require 'spec_helpers/client'

RSpec.describe FinApps::REST::OperatorsPasswordResets,
               'initialized with valid FinApps::Client object' do
  include SpecHelpers::Client
  subject(:operators_password_resets) do
    FinApps::REST::OperatorsPasswordResets.new(client)
  end

  describe '#create' do
    let(:results) { create[0] }
    let(:error_messages) { create[1] }

    context 'when missing params' do
      let(:create) { subject.create(nil) }

      it do
        expect { create }.to raise_error(FinAppsCore::MissingArgumentsError)
      end
    end

    context 'for invalid params' do
      let(:create) { subject.create(params: 'invalid params') }

      it do
        expect { create }.to raise_error(FinAppsCore::InvalidArgumentsError)
      end
    end

    context 'for valid params' do
      let(:create) { subject.create(email: 'valid email') }

      it { expect { create }.not_to raise_error }
      it('returns an array') { expect(create).to be_a(Array) }
      it('performs a post and returns the response') do
        expect(results).to have_key(:public_id)
        expect(results).to have_key(:token)
        expect(results).to have_key(:expiry_date)
      end
      it('returns no error messages') { expect(error_messages).to be_empty }
    end
  end

  describe '#update' do
    let(:results) { update[0] }
    let(:error_messages) { update[1] }

    context 'when missing params' do
      let(:update) { subject.update(nil) }

      it do
        expect { update }.to raise_error(FinAppsCore::MissingArgumentsError)
      end
    end

    context 'for invalid params' do
      let(:update) { subject.update(params: 'invalid') }

      it { expect { update }.not_to raise_error }
      it('results is nil') { expect(results).to be_nil }
      it('error messages array is populated') do
        expect(error_messages.first.downcase).to eq('invalid request body')
      end
    end

    context 'for valid params' do
      let(:update) { subject.update(params: 'valid') }

      it { expect { update }.not_to raise_error }
      it('returns an array') { expect(update).to be_a(Array) }
      it('performs a post and returns the response') do
        expect(results).to have_key(:public_id)
        expect(results).to have_key(:role)
      end
      it('returns no error messages') { expect(error_messages).to be_empty }
    end
  end
end
