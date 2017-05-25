require 'spec_helpers/client'

RSpec.describe FinApps::REST::OrderNotifications do
  include SpecHelpers::Client

  describe '#update' do
    subject(:orders) { FinApps::REST::OrderNotifications.new(client)}

    context 'when missing id' do
      let(:update) {subject.update(nil)}
      it('returns missing argument error') { expect { update }.to raise_error(FinAppsCore::MissingArgumentsError) }
    end

    context 'when invalid id is provided' do
      let(:update) { subject.update(:invalid_id) }
      let(:results) { update[RESULTS] }
      let(:error_messages) { update[ERROR_MESSAGES] }

      it { expect { update }.not_to raise_error }
      it('results is nil') { expect(results).to be_nil }
      it('error messages array is populated') { expect(error_messages.first.downcase).to eq('resource not found') }
    end

    context 'for valid id' do
      let(:update) { subject.update(:valid_id) }
      let(:results) { update[RESULTS] }
      let(:error_messages) { update[ERROR_MESSAGES] }

      it { expect { update }.not_to raise_error }
      it('results is nil') { expect(results).to be_nil }
      it('error_messages array is empty') { expect(error_messages).to eq([]) }
    end
  end
end

