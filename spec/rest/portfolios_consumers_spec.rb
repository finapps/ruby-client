# frozen_string_literal: true

require 'spec_helpers/client'

RSpec.describe FinApps::REST::PortfoliosConsumers do
  include SpecHelpers::Client
  subject { FinApps::REST::PortfoliosConsumers.new(client) }

  describe '#list' do
    let(:list) { subject.list(portfolio_id) }
    let(:results) { list[RESULTS] }
    let(:errors) { list[ERROR_MESSAGES] }

    context 'when missing id' do
      let(:portfolio_id) { nil }

      it { expect { list }.to raise_error(FinAppsCore::MissingArgumentsError) }
    end

    context 'when valid id is provided' do
      let(:portfolio_id) { 'valid_id' }

      it { expect { list }.not_to raise_error }
      it('returns an array') { expect(list).to be_a(Array) }
      it('performs a get and returns the response') { expect(results).to respond_to(:records) }
      it('returns no error messages') { expect(errors).to be_empty }
    end

    context 'when invalid id is provided' do
      let(:portfolio_id) { 'invalid_id' }

      it { expect { list }.not_to raise_error }
      it('results is nil') { expect(results).to be_nil }
      it('error messages array is populated') do
        expect(errors.first.downcase).to eq('resource not found')
      end
    end
  end

  describe '#create' do
    let(:create) { subject.create(portfolio_id, params) }
    let(:results) { create[RESULTS] }
    let(:errors) { create[ERROR_MESSAGES] }

    context 'when missing portfolio_id' do
      let(:portfolio_id) { nil }
      let(:params) { 'valid_id' }

      it { expect { create }.to raise_error(FinAppsCore::MissingArgumentsError) }
    end

    context 'when missing params' do
      let(:portfolio_id) { 'valid_id' }
      let(:params) { nil }

      it { expect { create }.to raise_error(FinAppsCore::MissingArgumentsError) }
    end

    xcontext 'for bulk subscribe' do
      context 'when valid id and params are provided' do
        let(:portfolio_id) { 'valid_id' }
        let(:params) { [portfolio_id] }

        it { expect { create }.not_to raise_error }
        it('returns an array') { expect(create).to be_a(Array) }
        it('results is nil') { expect(results).to be_nil }
        it('returns no error messages') { expect(errors).to be_empty }
        it('builds correct url') do
          create
          url = "#{FinAppsCore::REST::Defaults::DEFAULTS[:host]}/v3/portfolios/#{portfolio_id}/consumers/#{params}"
          expect(WebMock).to have_requested(:post, url)
        end
      end

      context 'when invalid id and params are provided' do
        let(:portfolio_id) { 'invalid_id' }
        let(:params) { portfolio_id }

        it { expect { create }.not_to raise_error }
        it('results is nil') { expect(results).to be_nil }
        it('error messages array is populated') do
          expect(errors.first.downcase).to eq('consumer not eligible, no completed orders.')
        end
      end
    end

    context 'for single subscribe' do
      context 'when valid ids are provided' do
        let(:portfolio_id) { 'valid_id' }
        let(:params) { portfolio_id }

        it { expect { create }.not_to raise_error }
        it('returns an array') { expect(create).to be_a(Array) }
        it('results is nil') { expect(results).to be_nil }
        it('returns no error messages') { expect(errors).to be_empty }
        it('builds correct url') do
          create
          url = "#{FinAppsCore::REST::Defaults::DEFAULTS[:host]}/v3/portfolios/#{portfolio_id}/consumers/#{params}"
          expect(WebMock).to have_requested(:post, url)
        end
      end

      context 'when invalid ids are provided' do
        let(:portfolio_id) { 'invalid_id' }
        let(:params) { portfolio_id }

        it { expect { create }.not_to raise_error }
        it('results is nil') { expect(results).to be_nil }
        it('error messages array is populated') do
          expect(errors.first.downcase).to eq('consumer not eligible, no completed orders.')
        end
      end
    end
  end


  describe '#destroy' do
    let(:destroy) { subject.destroy(portfolio_id, consumer_id) }
    let(:results) { destroy[RESULTS] }
    let(:errors) { destroy[ERROR_MESSAGES] }

    context 'when missing portfolio_id' do
      let(:portfolio_id) { nil }
      let(:consumer_id) { 'valid_id' }

      it { expect { destroy }.to raise_error(FinAppsCore::MissingArgumentsError) }
    end

    context 'when missing consumer_id' do
      let(:portfolio_id) { 'valid_id' }
      let(:consumer_id) { nil }

      it { expect { destroy }.to raise_error(FinAppsCore::MissingArgumentsError) }
    end

    context 'when valid ids are provided' do
      let(:portfolio_id) { 'valid_id' }
      let(:consumer_id) { portfolio_id }

      it { expect { destroy }.not_to raise_error }
      it('returns an array') { expect(destroy).to be_a(Array) }
      it('results is nil') { expect(results).to be_nil }
      it('returns no error messages') { expect(errors).to be_empty }
    end

    context 'when invalid ids are provided' do
      let(:portfolio_id) { 'invalid_id' }
      let(:consumer_id) { portfolio_id }

      it { expect { destroy }.not_to raise_error }
      it('results is nil') { expect(results).to be_nil }
      it('error messages array is populated') do
        expect(errors.first.downcase).to eq('resource not found')
      end
    end
  end
end
