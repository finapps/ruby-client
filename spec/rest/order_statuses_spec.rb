# frozen_string_literal: true
RSpec.describe FinApps::REST::OrderStatuses do
  let(:client) { FinApps::REST::Client.new(:company_identifier, :company_token) }
  describe '#show' do
    context 'when missing id' do
      subject { FinApps::REST::OrderStatuses.new(client).show(nil) }
      it { expect { subject }.to raise_error(FinAppsCore::MissingArgumentsError) }
    end

    context 'when valid id is provided' do
      subject { FinApps::REST::OrderStatuses.new(client).show(:valid_id) }

      it { expect { subject }.not_to raise_error }
      it('performs a get and returns the response') { expect(subject[0]).to respond_to(:status) }
      it('returns no error messages') { expect(subject[1]).to be_empty }
    end

    context 'when invalid id is provided' do
      subject { FinApps::REST::OrderStatuses.new(client).show(:invalid_id) }

      it { expect { subject }.not_to raise_error }
      it('results is nil') { expect(subject[0]).to be_nil }
      it('error messages array is populated') { expect(subject[1].first.downcase).to eq('resource not found') }
    end
  end
end
