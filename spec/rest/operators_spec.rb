# frozen_string_literal: true

require 'spec_helpers/client'
require 'spec_helpers/api_request'

RSpec.describe FinApps::REST::Operators do
  include SpecHelpers::Client

  let(:results) { subject[RESULTS] }
  let(:error_messages) { subject[ERROR_MESSAGES] }

  describe '#list' do
    subject(:list) { described_class.new(client).list(params) }

    context 'with valid params' do
      RSpec.shared_examples 'a filtereable GET index request' do |filter|
        it_behaves_like 'an API request'
        it_behaves_like 'a successful request'
        it_behaves_like 'a GET index request'
        it 'builds query and sends proper request' do
          query_string = ("?filter=#{ERB::Util.url_encode filter.to_json}" if filter)
          url = "#{versioned_api_path}/operators#{query_string}"
          list
          expect(WebMock).to have_requested(:get, url)
        end
      end

      context 'with email searchTerm' do
        let(:params) { {searchTerm: 'term@example.com'} }

        it_behaves_like 'a filtereable GET index request', {
          '$or': [
            {email: 'term@example.com'}
          ]
        }
      end

      context 'with non email searchTerm' do
        let(:params) { {searchTerm: 'le term'} }

        it_behaves_like 'a filtereable GET index request', {
          '$or': [
            {last_name: 'le term'}
          ]
        }
      end

      context 'with valid role' do
        let(:params) { {role: 1} }

        it_behaves_like 'a filtereable GET index request', {role: {'$in': [1]}}
      end

      context 'with empty params' do
        let(:params) { nil }

        it_behaves_like 'a filtereable GET index request', nil
      end

      context 'with searchTerm, page, sort, requested and role' do
        let(:params) do
          {
            searchTerm: 't',
            page: 2,
            sort: 'date_created',
            requested: 25,
            role: 2
          }
        end

        it_behaves_like 'an API request'
        it_behaves_like 'a successful request'
        it_behaves_like 'a GET index request'
        it 'builds a full filter and query and sends the request' do
          list

          filter = {'$or': [{last_name: 't'}], role: {'$in': [2]}}
          expect(WebMock).to have_requested(:get, "#{versioned_api_path}/operators" \
                                                  "?filter=#{ERB::Util.url_encode filter.to_json}" \
                                                  '&page=2&requested=25&sort=date_created')
        end
      end
    end

    context 'with invalid role' do
      let(:params) { {role: 'ADMIN'} }

      it { expect { list }.to raise_error(ArgumentError) }
    end

    context 'with invalid params' do
      let(:params) { :anything_but_a_hash }

      it { expect { list }.to raise_error(FinAppsCore::InvalidArgumentsError) }
    end
  end

  RSpec.shared_examples 'a missing id' do
    it { expect { subject }.to raise_error(FinAppsCore::MissingArgumentsError) }
  end

  RSpec.shared_examples 'an invalid id' do
    it { expect { subject }.not_to raise_error }
    it('results is nil') { expect(results).to be_nil }

    it('error messages array is populated') do
      expect(error_messages.first.downcase).to eq('resource not found')
    end
  end

  RSpec.shared_examples 'a missing params' do
    it { expect { subject }.to raise_error(FinAppsCore::MissingArgumentsError) }
  end

  describe '#show' do
    subject(:show) { described_class.new(client).show(id) }

    context 'when missing id' do
      let(:id) { nil }

      it_behaves_like 'a missing id'
    end

    context 'with invalid id' do
      let(:id) { :invalid_id }

      it_behaves_like 'an invalid id'
    end

    context 'with valid id' do
      let(:id) { :valid_id }

      it_behaves_like 'an API request'
      it_behaves_like 'a successful request'
      it('performs a get and returns the response') do
        expect(results).to have_key(:public_id)
      end
    end
  end

  describe '#create' do
    subject(:create) { described_class.new(client).create(params) }

    context 'when missing params' do
      let(:params) { nil }

      it_behaves_like 'a missing params'
    end

    context 'when invalid params are provided' do
      let(:params) { :invalid }

      it_behaves_like 'an API request'
      it('results is nil') { expect(results).to be_nil }

      it('error messages array is populated') do
        expect(error_messages.first.downcase).to eq('invalid request body')
      end
    end

    context 'when valid params are provided' do
      let(:params) { {params: :valid} }

      it_behaves_like 'an API request'
      it_behaves_like 'a successful request'
      it { expect(results).to have_key(:public_id) }
      it { expect(results).to have_key(:role) }
    end
  end

  describe '#update' do
    subject(:update) { described_class.new(client).update(id, params) }

    context 'when missing id' do
      let(:id) { nil }
      let(:params) { {params: :valid} }

      it_behaves_like 'a missing id'
    end

    context 'when missing params' do
      let(:id) { :id }
      let(:params) { nil }

      it_behaves_like 'a missing params'
    end

    context 'with invalid id' do
      let(:id) { :invalid_id }
      let(:params) { {params: :valid} }

      it_behaves_like 'an invalid id'
    end

    context 'with valid params' do
      let(:id) { :valid_id }
      let(:params) { {params: :valid} }

      it_behaves_like 'an API request'
      it_behaves_like 'a successful request'
      it { expect(results).to have_key(:email) }
      it { expect(results).to have_key(:role) }
    end
  end

  describe '#update_password' do
    subject(:update_password) { described_class.new(client).update_password(params) }

    context 'when missing params' do
      let(:params) { nil }

      it_behaves_like 'a missing params'
    end

    context 'with invalid params' do
      let(:params) { {foo: :bar} }

      it { expect { update_password }.to raise_error(FinAppsCore::InvalidArgumentsError) }
    end

    context 'with valid params' do
      let(:params) { {password: 'valid', password_confirm: 'valid'} }

      it_behaves_like 'an API request'
      it_behaves_like 'a successful request'
      it { expect(results).to have_key(:email) }
      it { expect(results).to have_key(:role) }
    end
  end

  describe '#destroy' do
    subject(:destroy) { described_class.new(client).destroy(id) }

    context 'when missing id' do
      let(:id) { nil }

      it_behaves_like 'a missing id'
    end

    context 'with invalid id' do
      let(:id) { :invalid_id }

      it_behaves_like 'an invalid id'
    end

    context 'with valid id' do
      let(:id) { :valid_id }

      it_behaves_like 'an API request'
      it_behaves_like 'a successful request'
      it('results is nil') { expect(results).to be_nil }
    end
  end
end
