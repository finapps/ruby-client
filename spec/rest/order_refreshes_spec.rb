require 'spec_helpers/client'

RSpec.describe FinApps::REST::OrderRefreshes do
  include SpecHelpers::Client
  subject { FinApps::REST::OrderRefreshes.new(client) }

  describe '#create' do
    context 'when missing id' do
      let(:create) { subject.create(nil) }
      it { expect { create }.to raise_error(FinAppsCore::MissingArgumentsError)}
    end

    context 'when valid id is provided' do
      let(:create) { subject.create(:valid_id) }
      it { expect { create }.not_to raise_error }
      it('returns an array') { expect(create).to be_a(Array) }
      it('performs a post and returns new refreshed order response') do
        expect(create[RESULTS]).to respond_to(:public_id)
        expect(create[RESULTS]).to respond_to(:original_order_id)
      end
      it('returns no error messages') { expect(create[ERROR_MESSAGES]).to be_empty }
    end
  end
end
