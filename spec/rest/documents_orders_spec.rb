# frozen_string_literal: true

require 'spec_helpers/client'
require 'rest/api_request'

RSpec.describe FinApps::REST::DocumentsOrders do
  include SpecHelpers::Client

  RSpec.shared_examples 'a request that raises an error' do |_parameter|
    it do
      expect { subject }.to raise_error(
        FinAppsCore::MissingArgumentsError
      )
    end
  end

  describe '#list' do
    subject(:list) { described_class.new(client).list(params) }

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
        let(:params) { {searchTerm: nil, page: 2} }

        it_behaves_like 'an API request'
        it_behaves_like 'a successful request'
        it 'performs a get and returns the response' do
          expect(results).to have_key(:records)
        end

        it 'builds query and sends proper request' do
          list
          url = "#{versioned_api_path}/documents/orders?page=2"
          expect(WebMock).to have_requested(:get, url)
        end
      end

      context 'with search term' do
        it_behaves_like 'an API request'
        it_behaves_like 'a successful request'
        it 'performs a get and returns the response' do
          expect(results).to have_key(:records)
        end

        it 'builds query and sends proper request' do
          list
          url =
            "#{versioned_api_path}/documents/orders?"\
            'filter=%7B%22$or%22:%5B%7B%22applicant.email%22:'\
            '%22term%22%7D,%7B%22applicant.first_name%22:%22term%22%7D,'\
            '%7B%22applicant.last_name%22:'\
            '%22term%22%7D,%7B%22reference_no%22:%7B%22$regex%22:%22%5Eterm%22,'\
            '%22$options%22:%22i%22%7D%7D%5D,'\
            '%22consumer_id%22:%22valid_consumer_id%22%7D&'\
            'page=2&requested=25&sort=tag '

          expect(WebMock).to have_requested(:get, url)
        end

        context 'with search term containing spaces' do
          let(:params) { {"searchTerm": 'Blue Jay', "page": 2} }

          it 'builds query and sends proper request' do
            list
            url =
              "#{versioned_api_path}/documents/orders?"\
              'filter=%7B%22$or%22:%5B%7B%22applicant.email%22:'\
              '%22Blue%20Jay%22%7D,'\
              '%7B%22applicant.first_name%22:%22Blue%20Jay%22%7D,'\
              '%7B%22applicant.last_name%22:'\
              '%22Blue%20Jay%22%7D,'\
              '%7B%22reference_no%22:%7B%22$regex%22:%22%5EBlue%20Jay%22,'\
              '%22$options%22:'\
              '%22i%22%7D%7D,%7B%22applicant.first_name%22:%22Blue%22%7D,'\
              '%7B%22applicant.last_name%22:%22Blue%22%7D,'\
              '%7B%22applicant.first_name%22:%22Jay%22%7D,'\
              '%7B%22applicant.last_name%22:%22Jay%22%7D%5D%7D&page=2'

            expect(WebMock).to have_requested(:get, url)
          end
        end
      end

      context 'when filtering by open status ordes' do
        let(:params) { {status: 1} }

        it_behaves_like 'an API request'
        it_behaves_like 'a successful request'
        it { expect(list.first[:records]).not_to be_empty }
      end

      context 'when filtering by closed status ordes' do
        let(:params) { {status: 2, searchTerm: 'term'} }

        it_behaves_like 'an API request'
        it_behaves_like 'a successful request'
        it { expect(results[:records]).to be_empty }
      end
    end

    context 'with invalid params' do
      let(:params) { ['invalid array'] }

      it { expect { list }.to raise_error(FinAppsCore::InvalidArgumentsError) }
    end

    context 'with missing params' do
      let(:params) { nil }

      it_behaves_like 'an API request'
      it_behaves_like 'a successful request'
      it('performs a get and returns the response') do
        expect(results).to have_key(:records)
      end
    end
  end

  describe '#show' do
    subject(:show) { described_class.new(client).show(id) }

    let(:results) { show[0] }
    let(:error_messages) { show[1] }

    context 'with valid id' do
      context 'when id is an identifier' do
        let(:id) { :valid_order_id }

        it_behaves_like 'an API request'
        it_behaves_like 'a successful request'
        it('has an order_id node in the response') do
          expect(results).to have_key(:order_id)
        end
      end

      context 'when id is a token' do
        let(:id) { '0123456abc.0123456abc.0123456abc' }

        it_behaves_like 'an API request'
        it_behaves_like 'a successful request'
        it('has an order node in the response') do
          expect(results).to have_key(:order)
        end

        it('has a consumer node in the response') do
          expect(results).to have_key(:consumer)
        end
      end
    end

    context 'with invalid id' do
      let(:id) { :invalid_order_id }

      it { expect(results).to be_nil }
      it { expect(error_messages).not_to be_empty }
    end

    context 'when missing id' do
      let(:id) { nil }

      it_behaves_like 'a request that raises an error'
    end
  end

  describe '#create' do
    subject(:create) { described_class.new(client).create(params) }

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

      it_behaves_like 'an API request'
      it_behaves_like 'a successful request'
      it('results is a Hash') { expect(results).to be_a(Hash) }

      it('performs a post and returns the response') do
        expect(results).to have_key(:order_id)
      end
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
      let(:params) { nil }

      it_behaves_like 'a request that raises an error'
    end
  end

  describe '#update' do
    subject(:update) { described_class.new(client).update(id, params) }

    let(:params) { {} }
    let(:results) { update[0] }
    let(:error_messages) { update[1] }

    context 'with valid id' do
      let(:id) { :valid_order_id }

      context 'with valid params' do
        let(:params) { {"tag": 'pending'} }

        it_behaves_like 'an API request'
        it_behaves_like 'a successful request'
        it('results is nil') { expect(results).to be_nil }
      end

      context 'with invalid params' do
        let(:params) { {"tag": 'invalid'} }

        it_behaves_like 'an API request'
        it('results is nil') { expect(results).to be_nil }

        it('error messages array is populated') do
          expect(error_messages.first.downcase).to eq('invalid request body')
        end
      end
    end

    context 'with invalid id' do
      let(:id) { :invalid_order_id }
      let(:params) { {applicant: {first_name: 'Quasar'}} }

      it_behaves_like 'an API request'
      it('results is nil') { expect(results).to be_nil }

      it('error messages array is populated') do
        expect(error_messages.first.downcase).to eq(
          'order id is invalid'
        )
      end
    end

    context 'with missing id' do
      let(:id) { nil }

      it_behaves_like 'a request that raises an error'
    end
  end

  describe '#destroy' do
    subject(:destroy) { described_class.new(client).destroy(id) }

    let(:results) { destroy[0] }
    let(:error_messages) { destroy[1] }

    context 'with valid id' do
      let(:id) { :valid_order_id }

      it_behaves_like 'an API request'
      it_behaves_like 'a successful request'
      it('results is nil') { expect(results).to be_nil }
    end

    context 'with invalid id' do
      let(:id) { :invalid_order_id }

      it_behaves_like 'an API request'
      it('results is nil') { expect(results).to be_nil }

      it('error messages array is populated') do
        expect(error_messages.first.downcase).to eq('resource not found')
      end
    end

    context 'with missing id' do
      let(:id) { nil }

      it_behaves_like 'a request that raises an error'
    end
  end

  describe '#show_signing_url' do
    subject(:sign_url) { described_class.new(client).show_signing_url(order_id, signature_id) }

    let(:results) { sign_url[0] }
    let(:error_messages) { sign_url[1] }
    let(:order_id) { :valid_order_id }
    let(:signature_id) { :valid_signature_id }

    context 'with valid order id' do
      context 'with valid signature id' do
        it_behaves_like 'an API request'
        it_behaves_like 'a successful request'
        it('performs a get and returns the response') do
          expect(results).to have_key(:sign_url)
        end
      end

      context 'with invalid signature id' do
        let(:signature_id) { :invalid_signature_id }

        it { expect(results).to be_nil }
        it { expect(error_messages).not_to be_empty }
      end
    end

    context 'with invalid order id' do
      let(:order_id) { :invalid_order_id }

      it { expect(results).to be_nil }
      it { expect(error_messages).not_to be_empty }
    end

    context 'with missing order id' do
      let(:order_id) { nil }

      it_behaves_like 'a request that raises an error'
    end

    context 'with missing signature id' do
      let(:signature_id) { nil }

      it_behaves_like 'a request that raises an error'
    end
  end
end
