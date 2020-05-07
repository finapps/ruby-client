# frozen_string_literal: true

require 'spec_helpers/client'

RSpec.describe FinApps::REST::DocumentsOrders, 'initialize with valid FinApps::Client object' do
  include SpecHelpers::Client
  subject(:doc_orders) { FinApps::REST::DocumentsOrders.new(client) }
  missing_order_id = ': order_id'

  describe '#list' do
    let(:list) { subject.list(params) }
    let(:results) { list[0] }
    let(:error_messages) { list[1] }

    context 'with valid params' do
      let(:params) do
        {
          page: 2,
          sort: 'tag',
          requested: 25,
          searchTerm: 'term',
          consumer: 'valid_consumer_id'
        }
      end
      context 'without searchTerm' do
        let(:params) { { "searchTerm": nil, "page": 2 } }
        it { expect { list }.to_not raise_error }
        it('returns an array') { expect(list).to be_a(Array) }
        it 'performs a get and returns the response' do
          expect(results).to have_key(:records)
        end
        it 'returns no error messages' do
          expect(error_messages).to be_empty
        end
        it 'builds query and sends proper request' do
          list
          url = "#{versioned_api_path}/documents/orders?page=2"
          expect(WebMock).to have_requested(:get, url)
        end
      end
      context 'with search term' do
        it { expect { list }.to_not raise_error }
        it('returns an array') { expect(list).to be_a(Array) }
        it 'performs a get and returns the response' do
          expect(results).to have_key(:records)
        end
        it 'returns no error messages' do
          expect(error_messages).to be_empty
        end
        it 'builds query and sends proper request' do
          list
          url =
            "#{versioned_api_path}/documents/orders?filter=%7B%22$or%22:%5B%7B%22order_id%22:%7B%22$regex%22:"\
            '%22%5Eterm%22,%22$options%22:%22i%22%7D%7D,%7B%22applicant.last_name%22:%22term%22%7D,'\
            '%7B%22reference_no%22:%7B%22$regex%22:%22%5Eterm%22,%22$options%22:%22i%22%7D%7D%5D,'\
            '%22consumer_id%22:%22valid_consumer_id%22%7D&page=2&requested=25&sort=tag'
          expect(WebMock).to have_requested(:get, url)
        end
      end
    end

    context 'with invalid params' do
      let(:params) { ['invalid array'] }
      it { expect { list }.to raise_error(FinAppsCore::InvalidArgumentsError) }
    end

    context 'with missing params' do
      let(:params) { nil }
      it { expect { list }.to_not raise_error }
      it('performs a get and returns the response') do
        expect(results).to have_key(:records)
      end
      it('returns an array of records') { expect(results[:records]).to be_a(Array) }
      it('returns no error messages') { expect(error_messages).to be_empty }
    end
  end

  describe '#show' do
    context 'with valid id' do
      let(:show) { subject.show(:valid_order_id) }
      let(:results) { show[0] }
      let(:error_messages) { show[1] }

      it { expect { show }.not_to raise_error }
      it('results is a Hash') { expect(results).to be_a(Hash) }
      it('performs a get and returns the response') do
        expect(results).to have_key(:order_id)
      end
      it('error_messages array is empty') { expect(error_messages).to eq([]) }
    end

    context 'with invalid id' do
      let(:show) { subject.show(:invalid_order_id) }
      let(:results) { show[0] }
      let(:error_messages) { show[1] }

      it { expect(results).to be_nil }
      it { expect(error_messages).to_not be_empty }
    end

    context 'when missing id' do
      it 'raises error' do
        expect { subject.show(nil) }.to raise_error(
          FinAppsCore::MissingArgumentsError,
          missing_order_id
        )
      end
    end
  end

  describe '#create' do
    let(:create) { subject.create(params) }
    let(:results) { create[0] }
    let(:error_messages) { create[1] }

    context 'with valid params' do
      let(:params) do
        {
          "applicant": {
            "email": 'validemail@financialapps.com',
            "first_name": 'Emily',
            "last_name": 'Macs',
            "role": 'patient'
          },
          "esign_documents": [
            'temp-id'
          ],
          "reference_no": 'REFNO',
          "tag": 'new'
        }
      end
      it { expect { create }.not_to raise_error }
      it('results is a Hash') { expect(results).to be_a(Hash) }
      it('performs a post and returns the response') do
        expect(results).to have_key(:order_id)
      end
      it('error_messages array is empty') { expect(error_messages).to eq([]) }
    end

    context 'with invalid params' do
      let(:params) do
        {
          "applicant": {
            "email": 'validemail@financialapps.com',
            "first_name": 'Emily',
            "last_name": 'Macs',
            "role": 'patient'
          },
          "reference_no": 'REFNO'
        }
      end
      it { expect { create }.not_to raise_error }
      it('results is nil') { expect(results).to be_nil }
      it('error messages array is populated') do
        expect(error_messages.first.downcase).to eq('invalid request body')
      end
    end

    context 'with missing  params' do
      it 'raises an error' do
        expect { subject.create(nil) }.to raise_error(
          FinAppsCore::MissingArgumentsError
        )
      end
    end
  end

  describe '#update' do
    context 'with valid id' do
      let(:update) { subject.update(:valid_order_id, params) }
      let(:results) { update[0] }
      let(:error_messages) { update[1] }

      context 'with valid params' do
        let(:params) { { "tag": 'pending' } }
        it { expect { update }.not_to raise_error }
        it('results is nil') { expect(results).to be_nil }
        it('error_messages array is empty') { expect(error_messages).to eq([]) }
      end

      context 'with invalid params' do
        let(:params) { { "tag": 'invalid' } }
        it { expect { update }.not_to raise_error }
        it('results is nil') { expect(results).to be_nil }
        it('error messages array is populated') do
          expect(error_messages.first.downcase).to eq('invalid request body')
        end
      end
    end

    context 'with invalid id' do
      let(:update) { subject.update(:invalid_order_id, applicant: { first_name: 'Quasar' }) }
      let(:results) { update[0] }
      let(:error_messages) { update[1] }

      it { expect { update }.not_to raise_error }
      it('results is nil') { expect(results).to be_nil }
      it('error messages array is populated') do
        expect(error_messages.first.downcase).to eq(
          'order id is invalid'
        )
      end
    end

    context 'with missing id' do
      it 'raises an error' do
        expect { subject.update(nil, {}) }.to raise_error(
          FinAppsCore::MissingArgumentsError,
          missing_order_id
        )
      end
    end
  end

  describe '#destroy' do
    context 'with valid id' do
      let(:destroy) { subject.destroy(:valid_order_id) }
      let(:results) { destroy[0] }
      let(:error_messages) { destroy[1] }

      it { expect { destroy }.not_to raise_error }
      it('results is nil') { expect(results).to be_nil }
      it('error_messages array is empty') { expect(error_messages).to eq([]) }
    end

    context 'with invalid id' do
      let(:destroy) { subject.destroy(:invalid_order_id) }
      let(:results) { destroy[0] }
      let(:error_messages) { destroy[1] }

      it { expect { destroy }.not_to raise_error }
      it('results is nil') { expect(results).to be_nil }
      it('error messages array is populated') do
        expect(error_messages.first.downcase).to eq('resource not found')
      end
    end

    context 'with missing id' do
      it do
        expect { subject.destroy(nil) }.to raise_error(
          FinAppsCore::MissingArgumentsError,
          missing_order_id
        )
      end
    end
  end
end
