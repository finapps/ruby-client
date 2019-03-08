# frozen_string_literal: true

require 'spec_helpers/client'

RSpec.describe FinApps::REST::ConsumersPortfolios do
  include SpecHelpers::Client
  subject { FinApps::REST::ConsumersPortfolios.new(client) }

  describe '#list' do
    let(:list) { subject.list(id, params) }
    let(:results) { list[RESULTS] }
    let(:errors) { list[ERROR_MESSAGES] }

    context 'when missing id' do
      let(:id) { nil }
      let(:params) { nil }

      it { expect { list }.to raise_error(FinAppsCore::MissingArgumentsError) }
    end

    context 'when missing params' do
      let(:id) { 'valid_id' }
      let(:params) { nil }

      it { expect { list }.not_to raise_error }
      it('returns an array') { expect(list).to be_a(Array) }
      it('performs a get and returns the response') { expect(results).to respond_to(:records) }
      it('returns no error messages') { expect(errors).to be_empty }
    end

    context 'when invalid params are provided' do
      let(:id) { 'valid_id' }
      let(:params) { %w[this is an array] }

      it { expect { list }.to raise_error(FinAppsCore::InvalidArgumentsError) }
    end

    context 'when including valid params' do
      let(:id) { 'valid_id' }
      let(:params) { { page: 2, sort: '-created_date', requested: 25 } }

      it { expect { list }.not_to raise_error }
      it('returns an array') { expect(list).to be_a(Array) }
      it('performs a get and returns the response') { expect(results).to respond_to(:records) }
      it('returns no error messages') { expect(errors).to be_empty }
      it 'builds query and sends proper request' do
        list
        url = "#{FinAppsCore::REST::Defaults::DEFAULTS[:host]}/v3/consumers/#{id}/portfolios?page=2&" \
        'requested=25&sort=-created_date'
        expect(WebMock).to have_requested(:get, url)
      end
    end
  end
end
