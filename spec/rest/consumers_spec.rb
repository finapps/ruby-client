# frozen_string_literal: true

require 'spec_helpers/client'
RSpec.describe FinApps::REST::Consumers,
               'initialized with valid FinApps::Client object' do
  include SpecHelpers::Client
  subject(:users) { described_class.new(client) }

  missing_public_id = ': public_id'

  describe '#create' do
    let(:results) { create[0] }
    let(:error_messages) { create[1] }

    context 'when missing params' do
      it do
        expect { users.create(nil) }.to raise_error(
          FinAppsCore::MissingArgumentsError
        )
      end
    end

    context 'with valid params' do
      let(:create) { subject.create(email: 'email', password: 'password') }

      it { expect { create }.not_to raise_error }
      it('results is a Hash') { expect(results).to be_a(Hash) }

      it('performs a post and returns the response') do
        expect(results).to have_key(:public_id)
      end

      it('error_messages array is empty') { expect(error_messages).to eq([]) }
    end

    context 'with invalid params' do
      let(:create) { subject.create(email: 'email') }

      it { expect { create }.not_to raise_error }
      it('results is nil') { expect(results).to be_nil }

      it('error messages array is populated') do
        expect(error_messages.first.downcase).to eq('invalid request body')
      end
    end
  end

  describe '#list' do
    let(:list) { subject.list(params) }
    let(:results) { list[0] }
    let(:error_messages) { list[1] }

    context 'when missing params' do
      let(:params) { nil }

      it { expect { list }.not_to raise_error }

      it('performs a get and returns the response') do
        expect(results).to have_key(:records)
      end

      it('returns an array of records') { expect(results[:records]).to be_a(Array) }
      it('returns no error messages') { expect(error_messages).to be_empty }
    end

    context 'when invalid params are provided' do
      let(:params) { ['invalid array'] }

      it { expect { list }.to raise_error(FinAppsCore::InvalidArgumentsError) }
    end

    context 'when including valid params without searchTerm' do
      let(:params) do
        {
          page: 3,
          requested: 19
        }
      end

      it { expect { list }.not_to raise_error }
      it('returns an array') { expect(list).to be_a(Array) }

      it('performs a get and returns the response') do
        expect(results).to have_key(:records)
      end

      it('returns no error messages') do
        expect(error_messages).to be_empty
      end

      it 'builds query and sends proper request' do
        list
        url = "#{versioned_api_path}/consumers?page=3&requested=19"
        expect(WebMock).to have_requested(:get, url)
      end
    end

    context 'when including valid params with searchTerm' do
      let(:params) do
        {
          page: 2,
          sort: 'date_created',
          requested: 25,
          searchTerm: 'term'
        }
      end

      it { expect { list }.not_to raise_error }
      it('returns an array') { expect(list).to be_a(Array) }

      it('performs a get and returns the response') do
        expect(results).to have_key(:records)
      end

      it('returns no error messages') do
        expect(error_messages).to be_empty
      end

      it 'builds query and sends proper request' do
        list
        url = "#{versioned_api_path}/consumers?"\
          'filter=%7B%22$or%22:%5B%7B%22email%22:%22term%22%7D,' \
          '%7B%22first_name%22:%22term%22%7D,'\
          '%7B%22last_name%22:%22term%22%7D%5D%7D&page=2&requested=25' \
          '&sort=date_created'
        expect(WebMock).to have_requested(:get, url)
      end

      context 'when search term contains a space' do
        let(:params) do
          {
            page: 2,
            sort: 'date_created',
            requested: 25,
            searchTerm: 'Two terms'
          }
        end

        it 'treats space as start of a new query for first and last name' do
          list
          url = "#{versioned_api_path}/consumers?"\
            'filter=%7B%22$or%22:%5B%7B%22email%22:%22Two%20terms%22%7D,'\
            '%7B%22first_name%22:%22Two%20terms%22%7D,'\
            '%7B%22last_name%22:%22Two%20terms%22%7D,%7B%22first_name%22:'\
            '%22Two%22%7D,%7B%22last_name%22:%22Two%22%7D,'\
            '%7B%22first_name%22:%22terms%22%7D,%7B%22last_name%22:'\
            '%22terms%22%7D%5D%7D&page=2&requested=25&sort=date_created'
          expect(WebMock).to have_requested(:get, url)
        end
      end
    end
  end

  describe '#show' do
    context 'when missing public_id' do
      it do
        expect { users.show(nil) }.to raise_error(
          FinAppsCore::MissingArgumentsError,
          missing_public_id
        )
      end
    end

    context 'with valid public_id' do
      let(:show) { users.show(:valid_public_id) }
      let(:results) { show[0] }
      let(:error_messages) { show[1] }

      it { expect { show }.not_to raise_error }
      it('results is a Hash') { expect(results).to be_a(Hash) }

      it('performs a get and returns the response') do
        expect(results).to have_key(:public_id)
      end

      it('error_messages array is empty') { expect(error_messages).to eq([]) }
    end

    context 'with invalid token' do
      let(:show) { users.show(:invalid_public_id) }
      let(:results) { show[0] }
      let(:error_messages) { show[1] }

      it { expect { show }.not_to raise_error }
      it('results is nil') { expect(results).to be_nil }

      it('error messages array is populated') do
        expect(error_messages.first.downcase).to eq('resource not found')
      end
    end
  end

  describe '#update' do
    context 'when missing public_id' do
      it do
        expect { users.update(nil, {}) }.to raise_error(
          FinAppsCore::MissingArgumentsError,
          missing_public_id
        )
      end
    end

    context 'when updating user details' do
      context 'with valid public_id' do
        let(:update) { users.update(:valid_public_id, postal_code: '33021') }
        let(:results) { update[0] }
        let(:error_messages) { update[1] }

        it { expect { update }.not_to raise_error }
        it('results is nil') { expect(results).to be_nil }
        it('error_messages array is empty') { expect(error_messages).to eq([]) }
      end

      context 'with invalid public_id' do
        let(:update) do
          subject.update(:invalid_public_id, postal_code: '33021')
        end
        let(:results) { update[0] }
        let(:error_messages) { update[1] }

        it { expect { update }.not_to raise_error }
        it('results is nil') { expect(results).to be_nil }

        it('error messages array is populated') do
          expect(error_messages.first.downcase).to eq(
            'invalid user id specified.'
          )
        end
      end
    end

    context 'when updating password' do
      context 'with valid public_id' do
        let(:update) do
          subject.update(
            :valid_public_id,
            password: 'Aa123456!', password_confirm: 'Aa123456!'
          )
        end
        let(:results) { update[0] }
        let(:error_messages) { update[1] }

        it { expect { update }.not_to raise_error }
        it('results is a Hash') { expect(results).to be_a(Hash) }

        it('the public_id is on the results') do
          expect(results).to have_key(:public_id)
        end

        it('the new token is on the results') do
          expect(results).to have_key(:token)
        end

        it('error_messages array is empty') { expect(error_messages).to eq([]) }
      end

      context 'with invalid public_id' do
        let(:update) do
          subject.update(
            :invalid_public_id,
            password: 'Aa123456!', password_confirm: 'Aa123456!'
          )
        end
        let(:results) { update[0] }
        let(:error_messages) { update[1] }

        it { expect { update }.not_to raise_error }
        it('results is nil') { expect(results).to be_nil }

        it('error messages array is populated') do
          expect(error_messages.first.downcase).to eq('resource not found')
        end
      end
    end

    describe '#destroy' do
      context 'when missing public_id' do
        it do
          expect { users.destroy(nil) }.to raise_error(
            FinAppsCore::MissingArgumentsError,
            missing_public_id
          )
        end
      end

      context 'with valid public_id' do
        let(:destroy) { users.destroy(:valid_public_id) }
        let(:results) { destroy[0] }
        let(:error_messages) { destroy[1] }

        it { expect { destroy }.not_to raise_error }
        it('results is nil') { expect(results).to be_nil }
        it('error_messages array is empty') { expect(error_messages).to eq([]) }
      end

      context 'with invalid token' do
        let(:destroy) { subject.destroy(:invalid_public_id) }
        let(:results) { destroy[0] }
        let(:error_messages) { destroy[1] }

        it { expect { destroy }.not_to raise_error }
        it('results is nil') { expect(results).to be_nil }

        it('error messages array is populated') do
          expect(error_messages.first.downcase).to eq('resource not found')
        end
      end
    end
  end
end
