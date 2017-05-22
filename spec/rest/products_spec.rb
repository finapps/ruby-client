require 'spec_helpers/client'

RSpec.describe FinApps::REST::Products, 'initialized with valid FinApps::Client object' do
  include SpecHelpers::Client
  subject(:products) { FinApps::REST::Products.new(client) }

  describe '#list' do
    context 'when called' do
      let(:list) { subject.list }
      let(:results) { list[0] }
      let(:error_messages) { list[1] }

      it { expect { list }.not_to raise_error }
      it('returns an array of records') { expect(results).to be_a(Array) }
      it('returns no error messages') { expect(error_messages).to be_empty }
    end
  end
end

