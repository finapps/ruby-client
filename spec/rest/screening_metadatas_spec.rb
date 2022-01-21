# frozen_string_literal: true

require 'spec_helpers/client'
require 'spec_helpers/api_request'

RSpec.describe FinApps::REST::ScreeningMetadatas do
  include SpecHelpers::Client

  let(:results) { subject[RESULTS] }
  let(:error_messages) { subject[ERROR_MESSAGES] }

  describe '#show' do
    subject(:show_metadata) { described_class.new(client).show(id, key) }

    context 'with valid params' do
      let(:id) { :session_id }
      let(:key) { :key }

      before { show_metadata }

      it 'sends proper request' do
        url = "#{versioned_api_path}/screenings/session_id/meta/key"

        expect(WebMock).to have_requested(:get, url)
      end

      it_behaves_like 'an API request'
      it_behaves_like 'a successful request'
    end

    context 'with invalid params' do
      let(:id) { :something_else }
      let(:key) { :key }

      it_behaves_like 'an API request'
      it('results is nil') { expect(results).to be_nil }

      it('error messages array is populated') do
        expect(error_messages.first.downcase).to eq('the screening id was not found')
      end
    end

    context 'with missing params' do
      let(:id) { nil }
      let(:key) { nil }

      it_behaves_like 'a request that raises an error'
    end
  end

  describe '#create' do
    subject(:create_metadata) { described_class.new(client).create(id, key, value) }

    context 'with valid params' do
      let(:id) { :session_id }
      let(:key) { :key }
      let(:value) { :value }

      before { create_metadata }

      it 'sends proper request' do
        url = "#{versioned_api_path}/screenings/session_id/meta"

        expect(WebMock).to have_requested(:post, url)
      end

      it_behaves_like 'an API request'
      it_behaves_like 'a successful request'
    end

    context 'with invalid params' do
      let(:id) { :something_else }
      let(:key) { :key }
      let(:value) { :value }

      it_behaves_like 'an API request'
      it('results is nil') { expect(results).to be_nil }

      it('error messages array is populated') do
        expect(error_messages.first.downcase).to eq('the screening id was not found')
      end
    end

    context 'with missing params' do
      let(:id) { nil }
      let(:key) { nil }
      let(:value) { nil }

      it_behaves_like 'a request that raises an error'
    end
  end

  describe '#destroy' do
    subject(:destroy_metadata) { described_class.new(client).destroy(id, key) }

    context 'with valid params' do
      let(:id) { :session_id }
      let(:key) { :key }

      before { destroy_metadata }

      it 'sends proper request' do
        url = "#{versioned_api_path}/screenings/session_id/meta/key"

        expect(WebMock).to have_requested(:delete, url)
      end

      it_behaves_like 'an API request'
      it_behaves_like 'a successful request'
    end

    context 'with invalid params' do
      let(:id) { :something_else }
      let(:key) { :key }

      it_behaves_like 'an API request'
      it('results is nil') { expect(results).to be_nil }

      it('error messages array is populated') do
        expect(error_messages.first.downcase).to eq('the screening id was not found')
      end
    end

    context 'with missing params' do
      let(:id) { nil }
      let(:key) { nil }

      it_behaves_like 'a request that raises an error'
    end
  end
end
