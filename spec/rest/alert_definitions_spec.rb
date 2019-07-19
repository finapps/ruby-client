# frozen_string_literal: true

require 'spec_helpers/client'

RSpec.describe FinApps::REST::AlertDefinitions do
  include SpecHelpers::Client
  subject { FinApps::REST::AlertDefinitions.new(client) }

  describe '#list' do
    let(:list) { subject.list(params) }
    let(:results) { list[RESULTS] }
    let(:errors) { list[ERROR_MESSAGES] }

    context 'when missing params' do
      let(:params) { nil }

      it { expect { list }.not_to raise_error }
      it('returns an array') { expect(list).to be_a(Array) }
      it('performs a get and returns the response') { expect(results).to respond_to(:records) }
      it('returns no error messages') { expect(errors).to be_empty }
    end

    context 'when invalid params are provided' do
      let(:params) { %w[this is an array] }

      it { expect { list }.to raise_error(FinAppsCore::InvalidArgumentsError) }
    end

    context 'when including valid params' do
      let(:params) { { page: 2, sort: '-created_date', requested: 25 } }

      it { expect { list }.not_to raise_error }
      it('returns an array') { expect(list).to be_a(Array) }
      it('performs a get and returns the response') { expect(results).to respond_to(:records) }
      it('returns no error messages') { expect(errors).to be_empty }
      it 'builds query and sends proper request' do
        list
        url = "#{versioned_api_path}/portfolio/alerts/definitions?page=2&requested=25&" \
        'sort=-created_date'
        expect(WebMock).to have_requested(:get, url)
      end
    end
  end

  describe '#show' do
    let(:show) { subject.show(id) }
    let(:results) { show[RESULTS] }
    let(:errors) { show[ERROR_MESSAGES] }

    context 'when missing params' do
      let(:id) { nil }

      it { expect { show }.to raise_error(FinAppsCore::MissingArgumentsError) }
    end

    context 'when valid id is provided' do
      let(:id) { 'valid_id' }

      it { expect { show }.not_to raise_error(FinAppsCore::MissingArgumentsError) }
      it('returns an array') { expect(show).to be_a(Array) }
      it('performs a get and returns the response') do
        expect(results).to respond_to(:_id)
        expect(results).to respond_to(:rule_name)
      end
      it('returns no error messages') { expect(errors).to be_empty }
    end

    context 'when invalid id is provided' do
      let(:id) { 'invalid_id' }

      it { expect { show }.not_to raise_error }
      it('results is nil') { expect(results).to be_nil }
      it('error messages array is populated') do
        expect(errors.first.downcase).to eq('resource not found')
      end
    end
  end
end
