# frozen_string_literal: true

require 'spec_helpers/client'

RSpec.describe FinApps::REST::PortfoliosAlerts do
  include SpecHelpers::Client
  subject { FinApps::REST::PortfoliosAlerts.new(client) }

  describe '#list' do
    let(:list) { subject.list(id) }
    let(:results) { list[RESULTS] }
    let(:errors) { list[ERROR_MESSAGES] }

    context 'when missing id' do
      let(:id) { nil }

      it { expect { list }.to raise_error(FinAppsCore::MissingArgumentsError) }
    end

    context 'when valid id is provided' do
      let(:id) { 'valid_id' }

      it { expect { list }.not_to raise_error }
      it('returns an array') { expect(list).to be_a(Array) }
      it('performs a get and returns array of alert definitions') do
        expect(results).to be_a(Array)
        expect(results.first).to respond_to(:_id)
        expect(results.first).to respond_to(:rule_name)
      end
      it('returns no error messages') { expect(errors).to be_empty }
    end

    context 'when invalid id is provided' do
      let(:id) { 'invalid_id' }

      it { expect { list }.not_to raise_error }
      it('results is nil') { expect(results).to be_nil }
      it('error messages array is populated') do
        expect(errors.first.downcase).to eq('resource not found')
      end
    end
  end

  describe '#create' do
    let(:create) { subject.create(portfolio_id, alert_id) }
    let(:results) { create[RESULTS] }
    let(:errors) { create[ERROR_MESSAGES] }

    context 'when missing portfolio_id' do
      let(:portfolio_id) { nil }
      let(:alert_id) { 'valid_id' }

      it { expect { create }.to raise_error(FinAppsCore::MissingArgumentsError) }
    end

    context 'when missing alert_id' do
      let(:portfolio_id) { 'valid_id' }
      let(:alert_id) { nil }

      it { expect { create }.to raise_error(FinAppsCore::MissingArgumentsError) }
    end

    context 'when valid ids are provided' do
      let(:portfolio_id) { 'valid_id' }
      let(:alert_id) { portfolio_id }

      it { expect { create }.not_to raise_error(FinAppsCore::MissingArgumentsError) }
      it('returns an array') { expect(create).to be_a(Array) }
      it('results is nil') { expect(results).to be_nil }
      it('returns no error messages') { expect(errors).to be_empty }
    end

    context 'when invalid ids are provided' do
      let(:portfolio_id) { 'invalid_id' }
      let(:alert_id) { portfolio_id }

      it { expect { create }.not_to raise_error(FinAppsCore::MissingArgumentsError) }
      it('results is nil') { expect(results).to be_nil }
      it('error messages array is populated') do
        expect(errors.first.downcase).to eq('resource not found')
      end
    end
  end

  describe '#destroy' do
    let(:destroy) { subject.destroy(portfolio_id, alert_id) }
    let(:results) { destroy[RESULTS] }
    let(:errors) { destroy[ERROR_MESSAGES] }

    context 'when missing portfolio_id' do
      let(:portfolio_id) { nil }
      let(:alert_id) { 'valid_id' }

      it { expect { destroy }.to raise_error(FinAppsCore::MissingArgumentsError) }
    end

    context 'when missing alert_id' do
      let(:portfolio_id) { 'valid_id' }
      let(:alert_id) { nil }

      it { expect { destroy }.to raise_error(FinAppsCore::MissingArgumentsError) }
    end

    context 'when valid ids are provided' do
      let(:portfolio_id) { 'valid_id' }
      let(:alert_id) { portfolio_id }

      it { expect { destroy }.not_to raise_error(FinAppsCore::MissingArgumentsError) }
      it('returns an array') { expect(destroy).to be_a(Array) }
      it('results is nil') { expect(results).to be_nil }
      it('returns no error messages') { expect(errors).to be_empty }
    end

    context 'when invalid ids are provided' do
      let(:portfolio_id) { 'invalid_id' }
      let(:alert_id) { portfolio_id }

      it { expect { destroy }.not_to raise_error(FinAppsCore::MissingArgumentsError) }
      it('results is nil') { expect(results).to be_nil }
      it('error messages array is populated') do
        expect(errors.first.downcase).to eq('resource not found')
      end
    end
  end
end
