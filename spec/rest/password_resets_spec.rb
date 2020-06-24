# frozen_string_literal: true

RSpec.describe FinApps::REST::PasswordResets do
  include SpecHelpers::Client

  describe '#create' do
    context 'when missing id' do
      subject { described_class.new(client).create(nil) }

      it do
        expect { subject }.to raise_error(FinAppsCore::MissingArgumentsError)
      end
    end

    context 'when invalid id is provided' do
      subject do
        described_class.new(client).create(:invalid_user_id)
      end

      it { expect { subject }.not_to raise_error }
      it('results is nil') { expect(subject[0]).to be_nil }

      it('error messages array is populated') do
        expect(subject[1]).not_to be_nil
      end
    end

    context 'when valid id is provided' do
      subject do
        described_class.new(client).create(:valid_user_id)
      end

      it { expect { subject }.not_to raise_error }
      it('returns an array') { expect(subject).to be_a(Array) }

      it('performs a post and returns the response') do
        expect(subject[0]).to have_key(:token)
      end

      it('returns no error messages') { expect(subject[1]).to be_empty }
    end
  end

  describe '#update' do
    let(:valid_params) { {token: 'valid_token'} }
    let(:invalid_params) { {token: 'invalid_token'} }

    context 'when missing id' do
      subject { described_class.new(client).update(nil, :params) }

      it do
        expect { subject }.to raise_error(FinAppsCore::MissingArgumentsError)
      end
    end

    context 'when missing params' do
      subject do
        described_class.new(client).update(:valid_user_id, nil)
      end

      it do
        expect { subject }.to raise_error(FinAppsCore::MissingArgumentsError)
      end
    end

    context 'when invalid id is provided' do
      subject do
        described_class.new(client).update(
          :invalid_user_id,
          valid_params
        )
      end

      it { expect { subject }.not_to raise_error }
      it('results is nil') { expect(subject[0]).to be_nil }

      it('error messages array is populated') do
        expect(subject[1]).not_to be_nil
      end
    end

    context 'when invalid params are provided' do
      subject do
        described_class.new(client).update(
          :valid_user_id,
          invalid_params
        )
      end

      it { expect { subject }.not_to raise_error }
      it('results is nil') { expect(subject[0]).to be_nil }

      it('error messages array is populated') do
        expect(subject[1]).not_to be_nil
      end
    end

    context 'when valid params are provided' do
      subject do
        described_class.new(client).update(
          :valid_user_id,
          valid_params
        )
      end

      it { expect { subject }.not_to raise_error }
      it('returns an array') { expect(subject).to be_a(Array) }

      it('performs a post and returns the response') do
        expect(subject[0]).to have_key(:token)
      end

      it('returns no error messages') { expect(subject[1]).to be_empty }
    end
  end
end
