# frozen_string_literal: true

require 'spec_helpers/client'

RSpec.describe FinApps::REST::DocumentsOrdersNotifications do
  include SpecHelpers::Client

  describe '#create' do
    subject(:notifications) { described_class.new(client) }

    context 'when missing id' do
      let(:create) { subject.create(nil) }

      it('returns missing argument error') do
        expect { create }.to raise_error(FinAppsCore::MissingArgumentsError)
      end
    end

    context 'when invalid id is provided' do
      let(:create) { subject.create(:invalid_id) }
      let(:results) { create[RESULTS] }
      let(:error_messages) { create[ERROR_MESSAGES] }

      it { expect { create }.not_to raise_error }
      it('results is nil') { expect(results).to be_nil }

      it('error messages array is populated') do
        expect(error_messages.first.downcase).to eq('order id is invalid')
      end
    end

    context 'with valid id' do
      let(:create) { subject.create(:valid_id) }
      let(:results) { create[RESULTS] }
      let(:error_messages) { create[ERROR_MESSAGES] }

      it { expect { create }.not_to raise_error }
      it('results is nil') { expect(results).to be_nil }
      it('error_messages array is empty') { expect(error_messages).to eq([]) }
    end
  end
end
