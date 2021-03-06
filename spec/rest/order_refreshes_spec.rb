# frozen_string_literal: true

require 'spec_helpers/client'

RSpec.describe FinApps::REST::OrderRefreshes do
  include SpecHelpers::Client
  subject { described_class.new(client) }

  describe '#create' do
    context 'when missing id' do
      let(:create) { subject.create(nil) }

      it do
        expect { create }.to raise_error(FinAppsCore::MissingArgumentsError)
      end
    end

    context 'when valid id is provided' do
      let(:create) { subject.create(:valid_id) }

      it { expect { create }.not_to raise_error }
      it('returns an array') { expect(create).to be_a(Array) }
      it { expect(create[RESULTS]).to have_key(:public_id) }
      it { expect(create[RESULTS]).to have_key(:original_order_id) }

      it('returns no error messages') do
        expect(create[ERROR_MESSAGES]).to be_empty
      end
    end

    context 'when invalid id is provided' do
      let(:create) { subject.create(:invalid_id) }

      it { expect { create }.not_to raise_error }
      it('returns an array') { expect(create).to be_a(Array) }
      it('results is nil') { expect(create[RESULTS]).to be_nil }

      it('error messages array is populated') do
        expect(create[ERROR_MESSAGES].first.downcase).to eq(
          'resource not found'
        )
      end
    end
  end
end
