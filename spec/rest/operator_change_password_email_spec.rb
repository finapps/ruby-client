# frozen_string_literal: true

require 'spec_helpers/client'

RSpec.describe FinApps::REST::OperatorChangePasswordEmail do
  context 'when initialized with valid FinApps::Client object' do
    include SpecHelpers::Client
    subject(:operators_change_password_email) do
      described_class.new(client)
    end

    describe '#create' do
      let(:results) { create[0] }
      let(:error_messages) { create[1] }

      context 'when missing params' do
        let(:create) { subject.create(nil) }

        it do
          expect { create }.to raise_error(FinAppsCore::MissingArgumentsError)
        end
      end

      context 'with valid params' do
        let(:create) { subject.create(email: 'valid email') }

        it('doesn\'t raise an error') { expect { create }.not_to raise_error }
        it('doesn\'t have a response') { expect(results).to be_nil }
        it('returns no error messages') { expect(error_messages).to be_empty }
      end
    end
  end
end
