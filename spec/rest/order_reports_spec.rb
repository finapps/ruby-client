# frozen_string_literal: true
RSpec.describe FinApps::REST::OrderReports do
  let(:client) { FinApps::REST::Client.new(:company_token) }
  describe '#show' do
    context 'when missing id' do
      subject { FinApps::REST::OrderReports.new(client).show(nil, :pdf) }
      it { expect { subject }.to raise_error(FinAppsCore::MissingArgumentsError) }
    end

    context 'when missing format' do
      subject { FinApps::REST::OrderReports.new(client).show(:valid_id, nil) }
      it { expect { subject }.to raise_error(FinAppsCore::MissingArgumentsError) }
    end

    context 'when invalid format is provided' do
      subject { FinApps::REST::OrderReports.new(client).show(:valid_id, :xml) }
      it { expect { subject }.to raise_error(FinAppsCore::InvalidArgumentsError) }
    end

    context 'when valid params are provided' do
      subject { FinApps::REST::OrderReports.new(client).show(:valid_id, :json) }

      it { expect { subject }.not_to raise_error }
      it('performs a get and returns the response') { expect(subject[0]).to respond_to(:days_requested) }
      it('returns no error messages') { expect(subject[1]).to be_empty }
    end

    context 'when invalid id is provided' do
      subject { FinApps::REST::OrderReports.new(client).show(:invalid_id, :json) }

      it { expect { subject }.not_to raise_error }
      it('results is nil') { expect(subject[0]).to be_nil }
      it('error messages array is populated') { expect(subject[1].first.downcase).to eq('resource not found') }
    end
  end
end
