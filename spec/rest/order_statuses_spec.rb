# frozen_string_literal: true
RSpec.describe FinApps::REST::OrderStatuses do
  include SpecHelpers::Client

  describe '#show' do
    context 'when missing id' do
      subject { FinApps::REST::OrderStatuses.new(client).show(nil) }
      it { expect { subject }.to raise_error(FinAppsCore::MissingArgumentsError) }
    end

    context 'when valid id is provided' do
      subject { FinApps::REST::OrderStatuses.new(client).show(:valid_id) }

      it { expect { subject }.not_to raise_error }
      it('performs a get and returns the response') { expect(subject[RESULTS]).to respond_to(:status) }
      it('returns no error messages') { expect(subject[ERROR_MESSAGES]).to be_empty }
    end

    context 'when invalid id is provided' do
      subject { FinApps::REST::OrderStatuses.new(client).show(:invalid_id) }

      it { expect { subject }.not_to raise_error }
      it('results is nil') { expect(subject[RESULTS]).to be_nil }
      it('error messages array is populated') do
        expect(subject[ERROR_MESSAGES].first.downcase).to eq('resource not found')
      end
    end
  end
end
