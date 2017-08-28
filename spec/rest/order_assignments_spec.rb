require 'spec_helpers/client'

RSpec.describe FinApps::REST::OrderAssignments do
  include SpecHelpers::Client

  describe '#update' do
    subject(:order_assignments) { FinApps::REST::OrderAssignments.new(client) }

    context 'when missing id' do
      let(:update) { subject.update(nil) }
      it('returns missing argument error') { expect { update }.to raise_error(FinAppsCore::MissingArgumentsError) }
    end
  end
end