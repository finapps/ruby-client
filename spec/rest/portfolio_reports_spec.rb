# frozen_string_literal: true

require 'spec_helpers/client'

RSpec.describe FinApps::REST::PortfolioReports do
  include SpecHelpers::Client
  subject { described_class.new(client) }

  describe '#list' do
    let(:list) { subject.list(params) }
    let(:results) { list[RESULTS] }
    let(:errors) { list[ERROR_MESSAGES] }

    context 'when missing params' do
      let(:params) { nil }

      it { expect { list }.not_to raise_error }
      it('returns an array') { expect(list).to be_a(Array) }

      it('performs a get and returns the response') do
        expect(results).to have_key(:records)
      end

      it('returns no error messages') { expect(errors).to be_empty }
    end

    context 'when invalid params are provided' do
      let(:params) { %w[this is an array] }

      it { expect { list }.to raise_error(FinAppsCore::InvalidArgumentsError) }
    end

    context 'when including valid params' do
      let(:params) { {page: 2, sort: '-created_date', requested: 25} }

      it { expect { list }.not_to raise_error }
      it('returns an array') { expect(list).to be_a(Array) }

      it('performs a get and returns the response') do
        expect(results).to have_key(:records)
      end

      it('returns no error messages') { expect(errors).to be_empty }

      it 'builds query and sends proper request' do
        list
        url =
          "#{versioned_api_path}/portfolio/reports?page=2&requested=25&" \
          'sort=-created_date'
        expect(WebMock).to have_requested(:get, url)
      end
    end
  end
end
