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
      it('performs a get and returns the response') { expect(show[RESULTS]).to respond_to(:data) }
      it('returns no error messages') { expect(show[ERROR_MESSAGES]).to be_empty }
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