# frozen_string_literal: true

require 'spec_helpers/client'

RSpec.describe FinApps::REST::Orders do
  include SpecHelpers::Client

  describe '#show' do
    context 'when missing params' do
      subject(:show) { described_class.new(client).show(nil) }

      it do
        expect { show }.to raise_error(FinAppsCore::MissingArgumentsError)
      end
    end

    context 'when valid params are provided' do
      subject(:show) { described_class.new(client).show(:valid_id) }

      it { expect { show }.not_to raise_error }
      it('returns an array') { expect(show).to be_a(Array) }
      it { expect(show[RESULTS]).to have_key(:public_id) }
      it { expect(show[RESULTS]).to have_key(:consumer_id) }

      it('returns no error messages') do
        expect(show[ERROR_MESSAGES]).to be_empty
      end
    end
  end

  describe '#create' do
    context 'when missing params' do
      subject(:create) { described_class.new(client).create(nil) }

      it do
        expect { create }.to raise_error(FinAppsCore::MissingArgumentsError)
      end
    end

    context 'when valid params are provided' do
      subject(:create) { described_class.new(client).create(valid_params) }

      let(:valid_params) do
        {applicant: 'valid', institutions: 'valid', product: 'valid'}
      end

      it { expect { create }.not_to raise_error }
      it('returns an array') { expect(create).to be_a(Array) }
      it { expect(create[RESULTS]).to have_key(:public_id) }
      it { expect(create[RESULTS]).to have_key(:consumer_id) }

      it('returns no error messages') do
        expect(create[ERROR_MESSAGES]).to be_empty
      end
    end

    context 'when invalid params are provided' do
      subject(:create) { described_class.new(client).create(invalid_params) }

      let(:invalid_params) { {applicant: 'valid'} }

      it { expect { create }.not_to raise_error }
      it('results is nil') { expect(create[RESULTS]).to be_nil }

      it('error messages array is populated') do
        expect(create[ERROR_MESSAGES].first.downcase).to eq(
          'invalid request body'
        )
      end
    end
  end

  describe '#list' do
    context 'when missing params' do
      # use defaults

      subject(:list) { described_class.new(client).list }

      it { expect { list }.not_to raise_error }

      it('returns an array') { expect(list).to be_a(Array) }

      it('performs a get and returns the response') do
        expect(list[RESULTS]).to have_key(:orders)
      end

      it('returns no error messages') do
        expect(list[ERROR_MESSAGES]).to be_empty
      end
    end

    context 'when invalid params are provided' do
      subject(:list) { described_class.new(client).list(invalid_params) }

      let(:invalid_params) { %w[this is an array] }

      it do
        expect { list }.to raise_error(FinAppsCore::InvalidArgumentsError)
      end
    end

    context 'when including valid params' do
      subject(:list) { described_class.new(client).list(params) }

      let(:params) do
        {
          page: 2,
          sort: 'status',
          requested: 25,
          searchTerm: 'term',
          status: %w[1 7],
          assignment: 'valid_operator',
          consumer: 'valid_consumer_id',
          relation: %w[valid_order_id]
        }
      end

      it { expect { list }.not_to raise_error }
      it('returns an array') { expect(list).to be_a(Array) }

      it('performs a get and returns the response') do
        expect(list[RESULTS]).to have_key(:orders)
      end

      it('each order contains a consumer_id') do
        expect(list[RESULTS][:orders]).to all(have_key(:consumer_id))
      end

      it('returns no error messages') do
        expect(list[ERROR_MESSAGES]).to be_empty
      end

      it 'builds query and sends proper request' do
        list
        url = "#{versioned_api_path}/orders?" \
              'filter=%7B%22$or%22:%5B%7B%22public_id%22:%7B%22$regex%22:%22%5E' \
              'term%22,%22$options%22:%22i%22%7D%7D,%7B%22assignment.last_name%22:%22' \
              'term%22%7D,%7B%22applicant.first_name%22:%22term%22%7D,%7B%22' \
              'applicant.last_name%22:%22term%22%7D,%7B%22requestor.reference_no' \
              '%22:%7B%22$regex%22:%22%5Eterm%22,%22$options%22:%22i%22%7D%7D%5D,%22' \
              'status%22:%7B%22$in%22:%5B1,7%5D%7D,%22assignment.operator_id%22:%22' \
              'valid_operator%22,%22consumer_id%22:%22valid_consumer_id%22%7D&page=2&requested=25&sort=status'
        expect(WebMock).to have_requested(:get, url)
      end

      it 'builds query and sends proper request with searchTerm/relation exclusivity' do
        params[:searchTerm] = nil
        list
        url = "#{versioned_api_path}/orders?" \
              'filter=%7B%22status%22:%7B%22$in%22:%5B1,7%5D%7D,' \
              '%22assignment.operator_id%22:%22valid_operator%22,' \
              '%22consumer_id%22:%22valid_consumer_id%22,' \
              '%22$or%22:%5B%7B%22public_id%22:%7B%22$in%22:%5B%22valid_order_id%22%5D%7D%7D,' \
              '%7B%22original_order_id%22:%7B%22$in%22:%5B%22valid_order_id%22%5D%7D%7D%5D%7D&' \
              'page=2&requested=25&sort=status'
        expect(WebMock).to have_requested(:get, url)
      end

      it 'handles space in search term for consumer' do
        params[:searchTerm] = 'Spacing Out'
        list
        url = "#{versioned_api_path}/orders?" \
              'filter=%7B%22$or%22:%5B%7B%22public_id%22:%7B%22$regex%22:%22%5E' \
              'Spacing%20Out%22,%22$options%22:%22i%22%7D%7D,%7B%22assignment.last_name' \
              '%22:%22Spacing%20Out%22%7D,%7B%22applicant.first_name%22:%22' \
              'Spacing%20Out%22%7D,%7B%22applicant.last_name%22:%22Spacing%20Out' \
              '%22%7D,%7B%22requestor.reference_no%22:%7B%22$regex%22:%22%5ESpacing%20Out' \
              '%22,%22$options%22:%22i%22%7D%7D,%7B%22applicant.first_name%22:%22Spacing' \
              '%22%7D,%7B%22applicant.last_name%22:%22Spacing%22%7D,%7B%22applicant.first_name' \
              '%22:%22Out%22%7D,%7B%22applicant.last_name%22:%22Out%22%7D%5D,%22status' \
              '%22:%7B%22$in%22:%5B1,7%5D%7D,%22assignment.operator_id%22:%22valid_operator' \
              '%22,%22consumer_id%22:%22valid_consumer_id%22%7D&page=2&requested=25&sort=status'
        expect(WebMock).to have_requested(:get, url)
      end

      it 'builds null assignment query properly when supplied w/ empty string' do
        described_class.new(client).list(assignment: '')

        url = "#{versioned_api_path}/orders?" \
              'filter=%7B%22assignment.operator_id%22:null%7D'
        expect(WebMock).to have_requested(:get, url)
      end
    end
  end

  describe '#update' do
    subject(:orders) { described_class.new(client) }

    context 'with nil params' do
      context 'when missing id' do
        let(:update) { orders.update(nil) }

        it('returns missing argument error') do
          expect { update }.to raise_error(FinAppsCore::MissingArgumentsError)
        end
      end

      context 'when valid id is provided' do
        let(:update) { orders.update('valid_id') } # how to stub params
        let(:results) { update[RESULTS] }
        let(:error_messages) { update[ERROR_MESSAGES] }

        it { expect { update }.not_to raise_error }
        it('results is nil') { expect(results).to be_nil }
        it('error_messages array is empty') { expect(error_messages).to eq([]) }
      end

      context 'when invalid id is provided' do
        let(:update) { orders.update('invalid_id') }
        let(:results) { update[RESULTS] }
        let(:error_messages) { update[ERROR_MESSAGES] }

        it { expect { update }.not_to raise_error }
        it('results is nil') { expect(results).to be_nil }

        it('error messages array is populated') do
          expect(error_messages.first.downcase).to eq('resource not found')
        end
      end
    end

    context 'with params' do
      context 'when missing id' do
        let(:update) { orders.update(nil, params: 'valid') }

        it('does not raise error') do
          expect { update }.not_to raise_error
        end
      end

      context 'when valid params are provided' do
        let(:update) { orders.update(nil, params: 'valid') }
        let(:results) { update[RESULTS] }
        let(:error_messages) { update[ERROR_MESSAGES] }

        it { expect { update }.not_to raise_error }
        it('results is nil') { expect(results).to be_nil }
        it('error_messages array is empty') { expect(error_messages).to eq([]) }
      end

      context 'when invalid params are provided' do
        let(:update) { orders.update(nil, params: 'invalid') }
        let(:results) { update[RESULTS] }
        let(:error_messages) { update[ERROR_MESSAGES] }

        it { expect { update }.not_to raise_error }
        it('results is nil') { expect(results).to be_nil }

        it('error messages array is populated') do
          expect(error_messages.first.downcase).to eq('invalid request body')
        end
      end
    end
  end

  # Test it calls update while making rubocop happy
  describe '#create_and_submit' do
    subject(:orders) { described_class.new(client) }

    let(:create_submit) { orders.create_and_submit(params) }
    let(:params) { {params: 'valid'} }
    let(:results) { create_submit[RESULTS] }
    let(:error_messages) { create_submit[ERROR_MESSAGES] }

    it { expect { create_submit }.not_to raise_error }
    it('results is nil') { expect(results).to be_nil }

    it('error messages array is empty') do
      expect(error_messages).to eq([])
    end
  end

  describe '#destroy' do
    subject(:orders) { described_class.new(client) }

    context 'when missing id' do
      let(:destroy) { orders.destroy(nil) }

      it('returns missing argument error') do
        expect { destroy }.to raise_error(FinAppsCore::MissingArgumentsError)
      end
    end

    context 'when invalid id is provided' do
      let(:destroy) { orders.destroy(:invalid_id) }
      let(:results) { destroy[RESULTS] }
      let(:error_messages) { destroy[ERROR_MESSAGES] }

      it { expect { destroy }.not_to raise_error }
      it('results is nil') { expect(results).to be_nil }

      it('error messages array is populated') do
        expect(error_messages.first.downcase).to eq('resource not found')
      end
    end

    context 'with valid id' do
      let(:destroy) { orders.destroy(:valid_id) }
      let(:results) { destroy[RESULTS] }
      let(:error_messages) { destroy[ERROR_MESSAGES] }

      it { expect { destroy }.not_to raise_error }
      it('results is nil') { expect(results).to be_nil }
      it('error_messages array is empty') { expect(error_messages).to eq([]) }
    end
  end
end
