# frozen_string_literal: true
RSpec.describe FinApps::REST::Orders do
  describe '#show' do
    let(:client) { FinApps::REST::Client.new(:company_identifier, :company_token) }

    context 'when missing params' do
      subject { FinApps::REST::Orders.new(client).show(nil) }
      it { expect { subject }.to raise_error(FinApps::MissingArgumentsError) }
    end

    context 'when valid params are provided' do
      subject { FinApps::REST::Orders.new(client).show(:id) }

      it { expect { subject }.not_to raise_error }
      it('returns an array') { expect(subject).to be_a(Array) }
      it('performs a post and returns the response') { expect(subject[0]).to respond_to(:public_id) }
      it('returns no error messages') { expect(subject[1]).to be_empty }
    end
  end
end
