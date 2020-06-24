# frozen_string_literal: true

require 'spec_helpers/client'

RSpec.describe FinApps::REST::OrderAssignments do
  include SpecHelpers::Client

  describe '#update' do
    subject(:order_assignments) { described_class.new(client) }

    let(:results) { update[RESULTS] }
    let(:error_messages) { update[ERROR_MESSAGES] }

    context 'when missing id' do
      let(:update) { subject.update(nil, []) }

      it('returns missing argument error') do
        expect { update }.to raise_error(FinAppsCore::MissingArgumentsError)
      end
    end

    context 'when missing params' do
      let(:update) { subject.update(:valid_id, nil) }

      it('returns missing argument error') do
        expect { update }.to raise_error(FinAppsCore::MissingArgumentsError)
      end
    end

    context 'with invalid params' do
      let(:update) { subject.update(:valid_id, params: 'params') }

      it('returns invalid argument error') do
        expect { update }.to raise_error(FinAppsCore::InvalidArgumentsError)
      end
    end

    context 'with invalid operator' do
      let(:update) { subject.update(:invalid_id, %w[invalid]) }

      it { expect { update }.not_to raise_error }
      it('results is nil') { expect(results).to be_nil }

      it('error messages array is populated') do
        expect(error_messages.first.downcase).to eq('resource not found')
      end
    end

    context 'with valid params' do
      let(:update) { subject.update(:valid_id, %w[valid]) }

      it { expect { update }.not_to raise_error }
      it('results is nil') { expect(results).to be_nil }
      it('error_messages array is empty') { expect(error_messages).to eq([]) }
    end
  end
end
