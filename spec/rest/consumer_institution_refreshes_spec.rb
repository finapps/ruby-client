# frozen_string_literal: true

require 'spec_helpers/client'

RSpec.describe FinApps::REST::ConsumerInstitutionRefreshes, 'initialized with valid FinApps::Client object' do
  include SpecHelpers::Client
  subject(:consumer_institution_refresh) { FinApps::REST::ConsumerInstitutionRefreshes.new client }

  describe '#create' do
    context 'when called' do
      let(:create) { subject.create }
      let(:results) { create[0] }
      let(:error_messages) { create[1] }

      it { expect { create }.not_to raise_error }
      it('returns an array of records') { expect(results).to be_a Array }
      it('returns no error messages') { expect(error_messages).to be_empty }
    end
  end
end
