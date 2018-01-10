# frozen_string_literal: true

require 'spec_helpers/client'

RSpec.describe FinApps::REST::Operators, 'initialized with valid FinApps::Client object' do
  include SpecHelpers::Client
  subject(:operators) { FinApps::REST::Operators.new(client) }

  describe '#list' do
    let(:list) { subject.list(params) }
    let(:results) { list[0] }
    let(:error_messages) { list[1] }

    context 'when missing params' do
      let(:params) { nil }
      it { expect { list }.not_to raise_error }
      it('performs a get and returns the response') { expect(results).to respond_to(:records) }
      it('returns an array of records') { expect(results.records).to be_a(Array) }
      it('returns no error messages') { expect(error_messages).to be_empty }
    end

    context 'when invalid params are provided' do
      let(:params) { ['invalid array'] }

      it { expect { list }.to raise_error(FinAppsCore::InvalidArgumentsError) }
    end

    context 'when including valid params' do
      let(:params) { {page: 2, sort: 'date_created', requested: 25, searchTerm: 'term', role: 2} }

      it { expect { list }.not_to raise_error }
      it('performs a get and returns the response') { expect(results).to respond_to(:records) }
      it('returns an array of records') { expect(results.records).to be_a(Array) }
      it('returns no error messages') { expect(error_messages).to be_empty }
      it 'builds query and sends proper request' do
        list
        url = "#{FinAppsCore::REST::Defaults::DEFAULTS[:host]}/v2/operators?filter=%7B%22last_name%22:%7B%22$regex" +
            "%22:%22term%22,%22$options%22:%22i%22%7D,%22role%22:2%7D&page=2&requested=25&sort=date_created"
        expect(WebMock).to have_requested(:get, url)
      end
    end
  end

  describe '#show' do
    let(:results) { show[0] }
    let(:error_messages) { show[1] }

    context 'when missing id' do
      let(:show) { subject.show(nil) }

      it { expect { show }.to raise_error(FinAppsCore::MissingArgumentsError) }
    end

    context 'for invalid id' do
      let(:show) { subject.show(:invalid_id) }

      it { expect { show }.not_to raise_error }
      it('results is nil') { expect(results).to be_nil }
      it('error messages array is populated') do
        expect(error_messages.first.downcase).to eq('resource not found')
      end
    end

    context 'for valid id' do
      let(:show) { subject.show(:valid_id) }

      it { expect { show }.not_to raise_error }
      it('returns an array') { expect(show).to be_a(Array) }
      it('performs a get and returns the response') { expect(results).to respond_to(:public_id) }
      it('returns no error messages') { expect(error_messages).to be_empty }
    end
  end

  describe '#create' do
    let(:results) { create[0] }
    let(:error_messages) { create[1] }

    context 'when missing params' do
      let(:create) { subject.create(nil) }

      it { expect { create }.to raise_error(FinAppsCore::MissingArgumentsError) }
    end

    context 'when invalid params are provided' do
      let(:create) { subject.create(params: 'invalid') }

      it { expect { create }.not_to raise_error }
      it('results is nil') { expect(results).to be_nil }
      it('error messages array is populated') do
        expect(error_messages.first.downcase).to eq('invalid request body')
      end
    end

    context 'when valid params are provided' do
      let(:create) { subject.create(params: 'valid') }

      it { expect { create }.not_to raise_error }
      it('returns an array') { expect(create).to be_a(Array) }
      it('performs a post and returns the response') do
        expect(results).to respond_to(:public_id)
        expect(results).to respond_to(:role)
      end
      it('returns no error messages') { expect(error_messages).to be_empty }
    end
  end

  describe '#update' do
    let(:results) { update[0] }
    let(:error_messages) { update[1] }

    context 'when missing id' do
      let(:update) { subject.update(nil, params: 'params') }

      it { expect { update }.to raise_error(FinAppsCore::MissingArgumentsError) }
    end

    context 'when missing params' do
      let(:update) { subject.update(:valid_id, nil) }

      it { expect { update }.to raise_error(FinAppsCore::MissingArgumentsError) }
    end

    context 'with invalid params' do
      let(:update) { subject.update(:invalid_id, params: 'params') }

      it { expect { update }.not_to raise_error }
      it('results is nil') { expect(results).to be_nil }
      it('error messages array is populated') do
        expect(error_messages.first.downcase).to eq('resource not found')
      end
    end

    context 'with valid params' do
      let(:update) { subject.update(:valid_id, params: 'valid params') }

      it { expect { update }.not_to raise_error }
      it('returns an array') { expect(update).to be_a(Array) }
      it('performs a put and returns the response') do
        expect(results).to respond_to(:email)
        expect(results).to respond_to(:role)
      end
      it('returns no error messages') { expect(error_messages).to be_empty }
    end
  end

  describe '#update_password' do
    let(:results) { update_password[0] }
    let(:error_messages) { update_password[1] }

    context 'when missing params' do
      let(:update_password) { subject.update_password(nil) }

      it { expect { update_password }.to raise_error(FinAppsCore::MissingArgumentsError) }
    end

    context 'with invalid params' do
      let(:update_password) { subject.update_password(password: 'invalid') }

      it { expect { update_password }.to raise_error(FinAppsCore::InvalidArgumentsError) }
    end

    context 'with valid params' do
      let(:valid_params) { {password: 'valid password', password_confirm: 'valid_password'} }
      let(:update_password) { subject.update_password(valid_params) }

      it { expect { update_password }.not_to raise_error }
      it('returns an array') { expect(update_password).to be_a(Array) }
      it('performs a post and returns the response') do
        expect(results).to respond_to(:public_id)
        expect(results).to respond_to(:role)
      end
      it('returns no error messages') { expect(error_messages).to be_empty }
    end
  end

  describe '#destroy' do
    let(:results) { destroy[0] }
    let(:error_messages) { destroy[1] }

    context 'when missing id' do
      let(:destroy) { subject.destroy(nil) }

      it { expect { destroy }.to raise_error(FinAppsCore::MissingArgumentsError) }
    end

    context 'for invalid id' do
      let(:destroy) { subject.destroy(:invalid_id) }

      it { expect { destroy }.not_to raise_error }
      it('results is nil') { expect(results).to be_nil }
      it('error messages array is populated') do
        expect(error_messages.first.downcase).to eq('resource not found')
      end
    end

    context 'for valid id' do
      let(:destroy) { subject.destroy(:valid_id) }

      it { expect { destroy }.not_to raise_error }
      it('results is nil') { expect(results).to be_nil }
      it('error_messages array is empty') { expect(error_messages).to eq([]) }
    end
  end
end
