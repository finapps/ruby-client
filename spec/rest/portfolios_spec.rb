# frozen_string_literal: true

require 'spec_helpers/client'

RSpec.describe FinApps::REST::Portfolios do
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
          "#{versioned_api_path}/portfolios?page=2&requested=25&sort=-created_date"
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

      it { expect { show }.not_to raise_error }
      it('returns an array') { expect(show).to be_a(Array) }

      it('performs a get and returns the response') do
        expect(results).to have_key(:_id)
        expect(results).to have_key(:product)
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

  describe '#create' do
    let(:create) { subject.create(params) }
    let(:results) { create[RESULTS] }
    let(:errors) { create[ERROR_MESSAGES] }

    context 'when missing params' do
      let(:params) { nil }

      it do
        expect { create }.to raise_error(FinAppsCore::MissingArgumentsError)
      end
    end

    context 'when valid params are provided' do
      let(:params) do
        {
          name: 'Account Checks',
          description: 'Some Check Stuff',
          product: 'valid'
        }
      end

      it { expect { create }.not_to raise_error }
      it('returns an array') { expect(create).to be_a(Array) }

      it('performs a get and returns the response') do
        expect(results).to have_key(:_id)
        expect(results).to have_key(:product)
      end

      it('returns no error messages') { expect(errors).to be_empty }
    end

    context 'when invalid params are provided' do
      let(:params) do
        {
          name: 'Account Checks',
          description: 'Some Check Stuff',
          product: 'invalid'
        }
      end

      it { expect { create }.not_to raise_error }
      it('results is nil') { expect(results).to be_nil }

      it('error messages array is populated') do
        expect(errors.first.downcase).to eq('invalid request body')
      end
    end
  end

  describe '#update' do
    let(:update) { subject.update(id, params) }
    let(:results) { update[RESULTS] }
    let(:errors) { update[ERROR_MESSAGES] }

    context 'when missing id' do
      let(:id) { nil }
      let(:params) { {fake: 'data'} }

      it do
        expect { update }.to raise_error(FinAppsCore::MissingArgumentsError)
      end
    end

    context 'when missing params' do
      let(:id) { 'valid_id' }
      let(:params) { nil }

      it do
        expect { update }.to raise_error(FinAppsCore::MissingArgumentsError)
      end
    end

    context 'when invalid id or params are provided' do
      let(:id) { 'invalid_id' }
      let(:params) { {fake: 'data'} }

      it { expect { update }.not_to raise_error }
      it('results is nil') { expect(results).to be_nil }

      it('error messages array is populated') do
        expect(errors.first.downcase).to eq('resource not found')
      end
    end

    context 'when valid id and params are provided' do
      let(:id) { 'valid_id' }
      let(:params) { {fake: 'data'} }

      it { expect { update }.not_to raise_error }
      it('returns an array') { expect(update).to be_a(Array) }

      it('performs a get and returns the response') do
        expect(results).to have_key(:_id)
        expect(results).to have_key(:product)
      end

      it('returns no error messages') { expect(errors).to be_empty }
    end
  end

  describe '#destroy' do
    let(:destroy) { subject.destroy(id) }
    let(:results) { destroy[RESULTS] }
    let(:errors) { destroy[ERROR_MESSAGES] }

    context 'when missing id' do
      let(:id) { nil }

      it do
        expect { destroy }.to raise_error(FinAppsCore::MissingArgumentsError)
      end
    end

    context 'when invalid id is provided' do
      let(:id) { 'invalid_id' }

      it { expect { destroy }.not_to raise_error }
      it('results is nil') { expect(results).to be_nil }

      it('error messages array is populated') do
        expect(errors.first.downcase).to eq('resource not found')
      end
    end

    context 'when valid id is provided' do
      let(:id) { 'valid_id' }

      it { expect { destroy }.not_to raise_error }
      it('results is nil') { expect(results).to be_nil }
      it('error messages array is empty') { expect(errors).to be_empty }
    end
  end
end
