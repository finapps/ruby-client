# frozen_string_literal: true

require 'digest'

RSpec.describe FinApps::REST::Locations do
  include SpecHelpers::Client

  describe '#list' do
    subject(:list) { described_class.new(client).list filter }

    let(:filter) { nil }

    it_behaves_like 'an API request'
    it_behaves_like 'a successful request'
    it { expect(list[RESULTS]).to all(have_key(:name)) }
    it { expect(list[RESULTS]).to all(have_key(:state)) }

    context 'when the JMESPath filter is invalid' do
      let(:filter) { 'invalid' }

      it_behaves_like 'a failed request'
    end
  end

  describe '#create' do
    subject(:create) { described_class.new(client).create(params) }

    let(:params) { {name: 'Quick Mart Urgent Care', state: {code: 'MD'}} }

    it_behaves_like 'an API request'
    it_behaves_like 'a successful request'
    it { expect(create[RESULTS]).to be_nil }
  end

  RSpec.shared_examples 'a request to a not found resource' do
    it_behaves_like 'a failed request'
    it('returns a 404 error') do
      expect(subject[ERROR_MESSAGES].first)
        .to(eq('the server responded with status 404'))
    end
  end

  describe '#show' do
    subject(:show) { described_class.new(client).show(key) }

    let(:key) { Digest::SHA256.hexdigest('Quick Mart Urgent CareMD,MD') }

    it_behaves_like 'an API request'
    it_behaves_like 'a successful request'
    it { expect(show[RESULTS]).to have_key(:name) }
    it { expect(show[RESULTS]).to have_key(:state) }

    context 'when key is not a valid SHA256' do
      let(:key) { 'invalid_SHA256' }

      it_behaves_like 'a failed request'
    end

    context 'when key does not match any location' do
      let(:key) { 'not_found' }

      it_behaves_like 'a failed request'
      it_behaves_like 'a request to a not found resource'
    end
  end

  describe '#update' do
    subject(:update) { described_class.new(client).update(key, params) }

    let(:key) { Digest::SHA256.hexdigest('Quick Mart Urgent CareMD,MD') }
    let(:params) { {name: 'Quick Mart Non-Urgent Care', state: {code: 'MD'}} }

    it_behaves_like 'an API request'
    it_behaves_like 'a successful request'
    it { expect(update[RESULTS]).to be_nil }

    context 'when key is not a valid SHA256' do
      let(:key) { 'invalid_SHA256' }

      it_behaves_like 'a failed request'
    end

    context 'when key does not match any location' do
      let(:key) { 'not_found' }

      it_behaves_like 'a failed request'
      it_behaves_like 'a request to a not found resource'
    end
  end

  describe '#destroy' do
    subject(:destroy) { described_class.new(client).destroy(key) }

    let(:key) { Digest::SHA256.hexdigest('Quick Mart Urgent CareMD,MD') }

    it_behaves_like 'an API request'
    it_behaves_like 'a successful request'
    it { expect(destroy[RESULTS]).to be_nil }

    context 'when key is not a valid SHA256' do
      let(:key) { 'invalid_SHA256' }

      it_behaves_like 'a failed request'
    end

    context 'when key does not match any location' do
      let(:key) { 'not_found' }

      it_behaves_like 'a failed request'
      it_behaves_like 'a request to a not found resource'
    end
  end
end