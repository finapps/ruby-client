# frozen_string_literal: true

RSpec.describe FinApps::REST::OrderStatuses do
  include SpecHelpers::Client

  describe '#show' do
    context 'when missing id' do
      subject(:show) { described_class.new(client).show(nil) }

      it do
        expect { show }.to raise_error(FinAppsCore::MissingArgumentsError)
      end
    end

    context 'when valid id is provided' do
      subject(:show) { described_class.new(client).show(:valid_id) }

      it { expect { show }.not_to raise_error }

      it('performs a get and returns the response') do
        expect(show[RESULTS]).to have_key(:status)
      end

      it('returns no error messages') do
        expect(show[ERROR_MESSAGES]).to be_empty
      end
    end

    context 'when invalid id is provided' do
      subject(:show) { described_class.new(client).show(:invalid_id) }

      it { expect { show }.not_to raise_error }
      it('results is nil') { expect(show[RESULTS]).to be_nil }

      it('error messages array is populated') do
        expect(show[ERROR_MESSAGES].first.downcase).to eq(
          'resource not found'
        )
      end
    end
  end
end
