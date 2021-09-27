# frozen_string_literal: true

require 'spec_helpers/client'
require 'spec_helpers/api_request'

RSpec.describe FinApps::REST::DocumentsUploads do
  include SpecHelpers::Client

  describe '#show' do
    let(:upload) { described_class.new(client) }

    context 'when missing doc id' do
      subject(:show) { upload.show(:consumer_id, nil) }

      it 'raises an error' do
        expect { show }.to raise_error(FinAppsCore::MissingArgumentsError)
      end
    end

    context 'when missing consumer id' do
      subject(:show) { upload.show(nil, :doc_id) }

      it 'raises an error' do
        expect { show }.to raise_error(FinAppsCore::MissingArgumentsError)
      end
    end

    context 'when thumbnail is not included' do
      subject(:show) do
        upload.show(
          :consumer_id,
          :doc_id
        )
      end

      it_behaves_like 'an API request'
      it_behaves_like 'a successful request'
    end

    context 'when thumbnail is included' do
      subject(:show) do
        upload.show(
          :consumer_id,
          :doc_id,
          true
        )
      end

      it_behaves_like 'an API request'
      it_behaves_like 'a successful request'
    end
  end

  describe '#destroy' do
    subject(:destroy) { described_class.new(client).destroy(order_id, doc_id) }

    let(:results) { destroy[0] }
    let(:error_messages) { destroy[1] }

    context 'with valid id' do
      let(:order_id) { :valid_order_id }
      let(:doc_id) { :valid_doc_id }

      it_behaves_like 'an API request'
      it_behaves_like 'a successful request'
      it('results is nil') { expect(results).to be_nil }
    end

    context 'with invalid order id' do
      let(:order_id) { :invalid_order_id }
      let(:doc_id) { :valid_doc_id }

      it_behaves_like 'an API request'
      it('results is nil') { expect(results).to be_nil }

      it('error messages array is populated') do
        expect(error_messages.first.downcase).to eq('resource not found')
      end
    end

    context 'with invalid doc id' do
      let(:order_id) { :valid_order_id }
      let(:doc_id) { :invalid_doc_id }

      it_behaves_like 'an API request'
      it('results is nil') { expect(results).to be_nil }

      it('error messages array is populated') do
        expect(error_messages.first.downcase).to eq('resource not found')
      end
    end

    context 'with missing id' do
      let(:order_id) { nil }
      let(:doc_id) { nil }

      it do
        expect { destroy }.to raise_error(
          FinAppsCore::MissingArgumentsError
        )
      end
    end
  end

  describe '#destroy_by_consumer' do
    subject(:destroy_by_consumer) do
      described_class.new(client).destroy_by_consumer(consumer_id, document_id)
    end

    let(:results) { destroy_by_consumer[0] }
    let(:error_messages) { destroy_by_consumer[1] }

    context 'with valid params' do
      let(:consumer_id) { :valid_consumer_id }
      let(:document_id) { :valid_document_id }

      it_behaves_like 'an API request'
      it_behaves_like 'a successful request'
      it('results is nil') { expect(results).to be_nil }
    end

    context 'with invalid consumer_id' do
      let(:consumer_id) { :invalid_consumer_id }
      let(:document_id) { :valid_document_id }

      it_behaves_like 'an API request'
      it('results is nil') { expect(results).to be_nil }

      it('error messages array is populated') do
        expect(error_messages.first.downcase).to eq('resource not found')
      end
    end

    context 'with invalid document id' do
      let(:consumer_id) { :valid_consumer_id }
      let(:document_id) { :invalid_document_id }

      it_behaves_like 'an API request'
      it('results is nil') { expect(results).to be_nil }

      it('error messages array is populated') do
        expect(error_messages.first.downcase).to eq('resource not found')
      end
    end

    context 'with missing id' do
      let(:consumer_id) { nil }
      let(:document_id) { nil }

      it do
        expect { destroy_by_consumer }.to raise_error(
          FinAppsCore::MissingArgumentsError
        )
      end
    end
  end
end
