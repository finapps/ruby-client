# frozen_string_literal: true

RSpec.describe FinApps::REST::PasswordResets do
  include SpecHelpers::Client

  describe '#create' do
    context 'when missing id' do
      subject(:create) { described_class.new(client).create(nil) }

      it do
        expect { create }.to raise_error(FinAppsCore::MissingArgumentsError)
      end
    end

    context 'when invalid id is provided' do
      subject(:create) do
        described_class.new(client).create(:invalid_user_id)
      end

      it { expect { create }.not_to raise_error }
      it('results is nil') { expect(create[0]).to be_nil }

      it('error messages array is populated') do
        expect(create[1]).not_to be_nil
      end
    end

    context 'when valid id is provided' do
      subject(:create) do
        described_class.new(client).create(:valid_user_id)
      end

      it { expect { create }.not_to raise_error }
      it('returns an array') { expect(create).to be_a(Array) }

      it('performs a post and returns the response') do
        expect(create[0]).to have_key(:token)
      end

      it('returns no error messages') { expect(create[1]).to be_empty }
    end
  end

  describe '#update' do
    let(:valid_params) { {token: 'valid_token'} }
    let(:invalid_params) { {token: 'invalid_token'} }

    context 'when missing id' do
      subject(:update) { described_class.new(client).update(nil, :params) }

      it do
        expect { update }.to raise_error(FinAppsCore::MissingArgumentsError)
      end
    end

    context 'when missing params' do
      subject(:update) do
        described_class.new(client).update(:valid_user_id, nil)
      end

      it do
        expect { update }.to raise_error(FinAppsCore::MissingArgumentsError)
      end
    end

    context 'when invalid id is provided' do
      subject(:update) do
        described_class.new(client).update(
          :invalid_user_id,
          valid_params
        )
      end

      it { expect { update }.not_to raise_error }
      it('results is nil') { expect(update[0]).to be_nil }

      it('error messages array is populated') do
        expect(update[1]).not_to be_nil
      end
    end

    context 'when invalid params are provided' do
      subject(:update) do
        described_class.new(client).update(
          :valid_user_id,
          invalid_params
        )
      end

      it { expect { update }.not_to raise_error }
      it('results is nil') { expect(update[0]).to be_nil }

      it('error messages array is populated') do
        expect(update[1]).not_to be_nil
      end
    end

    context 'when valid params are provided' do
      subject(:update) do
        described_class.new(client).update(
          :valid_user_id,
          valid_params
        )
      end

      it { expect { update }.not_to raise_error }
      it('returns an array') { expect(update).to be_a(Array) }

      it('performs a post and returns the response') do
        expect(update[0]).to have_key(:token)
      end

      it('returns no error messages') { expect(update[1]).to be_empty }
    end
  end
end
