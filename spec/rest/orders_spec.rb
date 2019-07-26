# frozen_string_literal: true

require 'spec_helpers/client'

RSpec.describe FinApps::REST::Orders do
  include SpecHelpers::Client

  describe '#show' do
    context 'when missing params' do
      subject { FinApps::REST::Orders.new(client).show(nil) }
      it do
        expect { subject }.to raise_error(FinAppsCore::MissingArgumentsError)
      end
    end

    context 'when valid params are provided' do
      subject { FinApps::REST::Orders.new(client).show(:valid_id) }

      it { expect { subject }.not_to raise_error }
      it('returns an array') { expect(subject).to be_a(Array) }
      it('performs a get and returns the response') do
        expect(subject[RESULTS]).to respond_to(:public_id)
        expect(subject[RESULTS]).to respond_to(:consumer_id)
      end
      it('returns no error messages') do
        expect(subject[ERROR_MESSAGES]).to be_empty
      end
    end
  end

  describe '#create' do
    context 'when missing params' do
      subject { FinApps::REST::Orders.new(client).create(nil) }
      it do
        expect { subject }.to raise_error(FinAppsCore::MissingArgumentsError)
      end
    end

    context 'when valid params are provided' do
      subject { FinApps::REST::Orders.new(client).create(valid_params) }
      let(:valid_params) do
        { applicant: 'valid', institutions: 'valid', product: 'valid' }
      end

      it { expect { subject }.not_to raise_error }
      it('returns an array') { expect(subject).to be_a(Array) }
      it('performs a post and returns the response') do
        expect(subject[RESULTS]).to respond_to(:public_id)
        expect(subject[RESULTS]).to respond_to(:consumer_id)
      end
      it('returns no error messages') do
        expect(subject[ERROR_MESSAGES]).to be_empty
      end
    end

    context 'when invalid params are provided' do
      subject { FinApps::REST::Orders.new(client).create(invalid_params) }
      let(:invalid_params) { { applicant: 'valid' } }

      it { expect { subject }.not_to raise_error }
      it('results is nil') { expect(subject[RESULTS]).to be_nil }
      it('error messages array is populated') do
        expect(subject[ERROR_MESSAGES].first.downcase).to eq(
          'invalid request body'
        )
      end
    end
  end

  describe '#list' do
    context 'when missing params' do
      # use defaults

      subject { FinApps::REST::Orders.new(client).list }
      it { expect { subject }.not_to raise_error }

      it('returns an array') { expect(subject).to be_a(Array) }
      it('performs a get and returns the response') do
        expect(subject[RESULTS]).to respond_to(:orders)
      end
      it('returns no error messages') do
        expect(subject[ERROR_MESSAGES]).to be_empty
      end
    end

    context 'when invalid params are provided' do
      subject { FinApps::REST::Orders.new(client).list(invalid_params) }
      let(:invalid_params) { %w[this is an array] }

      it do
        expect { subject }.to raise_error(FinAppsCore::InvalidArgumentsError)
      end
    end

    context 'when including valid params' do
      subject { FinApps::REST::Orders.new(client).list(params) }
      let(:params) do
        {
          page: 2,
          sort: 'status',
          requested: 25,
          searchTerm: 'term',
          status: %w[1 7],
          assignment: 'valid_operator',
          relation: %w[valid_order_id]
        }
      end

      it { expect { subject }.not_to raise_error }
      it('returns an array') { expect(subject).to be_a(Array) }
      it('performs a get and returns the response') do
        expect(subject[RESULTS]).to respond_to(:orders)
      end
      it('each order contains a consumer_id') do
        expect(subject[RESULTS].orders).to all(have_key('consumer_id'))
      end
      it('returns no error messages') do
        expect(subject[ERROR_MESSAGES]).to be_empty
      end
      it 'builds query and sends proper request' do
        subject
        url =
          "#{versioned_api_path}/orders?filter=%7B%22$or%22:%5B%7B%22public_id%22:" \
            '%7B%22$regex%22:%22%5Eterm%22,%22$options%22:%22i%22%7D%7D,%7B%22applicant.last_name%22:%22term%22%7D' \
            ',%7B%22assignment.last_name%22:%22term%22%7D,%7B%22requestor.reference_no%22:%7B%22$regex%22:%22%5E' \
            'term%22,%22$options%22:%22i%22%7D%7D%5D,%22status%22:%7B%22$in%22:%5B1,7%5D%7D,%22assignment.' \
            'operator_id%22:%22valid_operator%22%7D&page=2&requested=25&sort=status'
        expect(WebMock).to have_requested(:get, url)
      end
      it 'builds query and sends proper request with searchTerm/relation exclusivity' do
        params[:searchTerm] = nil
        subject
        url =
          "#{versioned_api_path}/orders?filter=%7B%22status%22:%7B%22$in%22:%5B1," \
            '7%5D%7D,%22assignment.operator_id%22:%22valid_operator%22,%22$or%22:%5B%7B%22public_id%22:%7B%22$in' \
            '%22:%5B%22valid_order_id%22%5D%7D%7D,%7B%22original_order_id%22:%7B%22$in%22:%5B%22valid_order_id%22' \
            '%5D%7D%7D%5D%7D&page=2&requested=25&sort=status'
        expect(WebMock).to have_requested(:get, url)
      end
      it 'builds null assignment query properly when supplied w/ empty string' do
        FinApps::REST::Orders.new(client).list(assignment: '')

        url =
          "#{versioned_api_path}/orders?filter=%7B%22assignment.operator_id%22:null%7D"
        expect(WebMock).to have_requested(:get, url)
      end
    end
  end

  describe '#update' do
    subject(:orders) { FinApps::REST::Orders.new(client) }

    context 'when missing id' do
      let(:update) { subject.update(nil, :params) }
      it('returns missing argument error') do
        expect { update }.to raise_error(FinAppsCore::MissingArgumentsError)
      end
    end

    context 'when missing params' do
      let(:update) { subject.update(:id, nil) }
      it('returns missing argument error') do
        expect { update }.to raise_error(FinAppsCore::MissingArgumentsError)
      end
    end

    context 'when valid id and params are provided' do
      let(:update) { subject.update('valid_id', accounts: 'valid_account') } # how to stub params
      let(:results) { update[RESULTS] }
      let(:error_messages) { update[ERROR_MESSAGES] }

      it { expect { update }.not_to raise_error }
      it('results is nil') { expect(results).to be_nil }
      it('error_messages array is empty') { expect(error_messages).to eq([]) }
    end

    context 'when invalid id is provided' do
      let(:update) { subject.update('invalid_id', :params) }
      let(:results) { update[RESULTS] }
      let(:error_messages) { update[ERROR_MESSAGES] }

      it { expect { update }.not_to raise_error }
      it('results is nil') { expect(results).to be_nil }
      it('error messages array is populated') do
        expect(error_messages.first.downcase).to eq('resource not found')
      end
    end

    context 'when invalid params are provided' do
      let(:update) { subject.update('valid_id', accounts: 'invalid_account') }
      let(:results) { update[RESULTS] }
      let(:error_messages) { update[ERROR_MESSAGES] }

      it { expect { update }.not_to raise_error }
      it('results is nil') { expect(results).to be_nil }
      it('error messages array is populated') do
        expect(error_messages.first.downcase).to eq('invalid request body')
      end
    end
  end

  describe '#destroy' do
    subject(:orders) { FinApps::REST::Orders.new(client) }

    context 'when missing id' do
      let(:destroy) { subject.destroy(nil) }
      it('returns missing argument error') do
        expect { destroy }.to raise_error(FinAppsCore::MissingArgumentsError)
      end
    end

    context 'when invalid id is provided' do
      let(:destroy) { subject.destroy(:invalid_id) }
      let(:results) { destroy[RESULTS] }
      let(:error_messages) { destroy[ERROR_MESSAGES] }

      it { expect { destroy }.not_to raise_error }
      it('results is nil') { expect(results).to be_nil }
      it('error messages array is populated') do
        expect(error_messages.first.downcase).to eq('resource not found')
      end
    end

    context 'for valid id' do
      let(:destroy) { subject.destroy(:valid_id) }
      let(:results) { destroy[RESULTS] }
      let(:error_messages) { destroy[ERROR_MESSAGES] }

      it { expect { destroy }.not_to raise_error }
      it('results is nil') { expect(results).to be_nil }
      it('error_messages array is empty') { expect(error_messages).to eq([]) }
    end
  end
end
