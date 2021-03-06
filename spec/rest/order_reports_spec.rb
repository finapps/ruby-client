# frozen_string_literal: true

require 'spec_helpers/client'

RSpec.describe FinApps::REST::OrderReports do
  include SpecHelpers::Client

  let(:order_report) { described_class.new client }

  describe '#show' do
    context 'when missing id' do
      subject(:show) { order_report.show(nil, :pdf) }

      it do
        expect { show }.to raise_error(FinAppsCore::MissingArgumentsError)
      end
    end

    context 'when missing format' do
      subject(:show) { order_report.show(:valid_id, nil) }

      it do
        expect { show }.to raise_error(FinAppsCore::MissingArgumentsError)
      end
    end

    context 'when invalid format is provided' do
      subject(:show) { order_report.show(:valid_id, :xml) }

      it do
        expect { show }.to raise_error(FinAppsCore::InvalidArgumentsError)
      end
    end

    context 'when valid params are provided' do
      subject(:show) { order_report.show(:valid_id, :json) }

      it { expect { show }.not_to raise_error }

      it('performs a get and returns the response') do
        expect(show[0]).to have_key(:days_requested)
      end

      it('returns no error messages') { expect(show[1]).to be_empty }
    end

    context 'when invalid id is provided' do
      subject(:show) { order_report.show(:invalid_id, :json) }

      it { expect { show }.not_to raise_error }
      it('results is nil') { expect(show[0]).to be_nil }

      it('error messages array is populated') do
        expect(show[1].first.downcase).to eq('resource not found')
      end
    end
  end
end
