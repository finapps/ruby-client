# frozen_string_literal: true

require 'digest'

RSpec.describe FinApps::REST::Locations do
  include SpecHelpers::Client

  let(:id) { :id }

  params = {name: 'Quick Mart Non-Urgent Care', state: {code: 'MD'}}

  RSpec::Matchers.define :have_keys do |*keys|
    match {|actual| keys.all? {|key| actual.key? key } }
  end

  RSpec.shared_examples 'a request to a not found resource' do
    it_behaves_like 'a failed request'
    it('returns a 404 error') do
      expect(subject[ERROR_MESSAGES].first)
        .to(eq('the server responded with status 404'))
    end
  end

  RSpec.shared_examples 'a successful request returning an empty body' do
    it_behaves_like 'an API request'
    it_behaves_like 'a successful request'
    it { expect(subject[RESULTS]).to be_nil }
  end

  describe '#list' do
    subject(:list) { described_class.new(client).list filter }

    let(:filter) { nil }

    it_behaves_like 'an API request'
    it_behaves_like 'a successful request'
    it { expect(list[RESULTS]).to all(have_keys(:id, :name, :state)) }

    context 'when the JMESPath filter is invalid' do
      let(:filter) { 'invalid' }

      it_behaves_like 'a failed request'
    end
  end

  describe '#show' do
    subject(:show) { described_class.new(client).show(id) }

    context 'when the location exists' do
      it_behaves_like 'an API request'
      it_behaves_like 'a successful request'
      it { expect(show[RESULTS]).to have_keys(:id, :name, :state) }
    end

    context 'when id does not match any location' do
      let(:id) { 'not_found' }

      it_behaves_like 'a request to a not found resource'
    end
  end

  describe '#create' do
    subject(:create) { described_class.new(client).create(params) }

    it_behaves_like 'a successful request returning an empty body'
  end

  describe '#update' do
    subject(:update) { described_class.new(client).update(id, params) }

    context 'when the location exists' do
      it_behaves_like 'a successful request returning an empty body'
    end

    context 'when id does not match any location' do
      let(:id) { 'not_found' }

      it_behaves_like 'a request to a not found resource'
    end
  end

  describe '#destroy' do
    subject(:destroy) { described_class.new(client).destroy(id) }

    context 'when the location exists' do
      it_behaves_like 'a successful request returning an empty body'
    end

    context 'when id does not match any location' do
      let(:id) { 'not_found' }

      it_behaves_like 'a request to a not found resource'
    end
  end
end
