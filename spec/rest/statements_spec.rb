# frozen_string_literal: true

require 'spec_helpers/client'

RSpec.describe FinApps::REST::Statements do
  include SpecHelpers::Client
  subject { FinApps::REST::Statements.new(client) }

  describe '#show' do
    context 'when missing account_id' do
      let(:show) { subject.show(nil, 'valid_id') }
      it { expect { show }.to raise_error(FinAppsCore::MissingArgumentsError) }
    end

    context 'when missing document_id' do
      let(:show) { subject.show('valid_id', nil) }
      it { expect { show }.to raise_error(FinAppsCore::MissingArgumentsError) }
    end

    context 'when valid ids are provided' do
      let(:show) { subject.show('valid_id', 'valid_id') }
      it { expect { show }.not_to raise_error }
      it('returns an array') { expect(show).to be_a(Array) }
      it('performs a get and returns the response') do
        expect(show[RESULTS]).to respond_to(:data)
      end
      it('returns no error messages') do
        expect(show[ERROR_MESSAGES]).to be_empty
      end
    end

    context 'when invalid ids are provided' do
      let(:show) { subject.show('invalid_id', 'valid_id') }
      it { expect { show }.not_to raise_error }
      it('returns an array') { expect(show).to be_a(Array) }
      it('results is nil') { expect(show[RESULTS]).to be_nil }
      it('error messages array is populated') do
        expect(show[ERROR_MESSAGES].first.downcase).to eq('resource not found')
      end
    end
  end
end
