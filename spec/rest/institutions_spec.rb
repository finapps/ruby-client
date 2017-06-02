# frozen_string_literal: true
require 'spec_helpers/client'
RSpec.describe FinApps::REST::Institutions do
  include SpecHelpers::Client
  subject(:institutions) { FinApps::REST::Institutions.new(client) }

  describe '#list' do
    context 'when search_term is missing' do
      let(:list) { subject.list(nil) }
      it { expect { list }.to raise_error(FinAppsCore::MissingArgumentsError) }
    end

    context 'when proper search_term is provided' do
      let(:list) { subject.list(:search_term) }

      it { expect { list }.not_to raise_error }
      it('returns an array') { expect(list).to be_a(Array) }
      it('performs a get and returns institution array') { expect(list[0]).to be_a(Array) }
      it('returns no error messages') { expect(list[1]).to be_empty }
    end
  end

  describe '#show' do
    context 'when id is missing' do
      it { expect { subject.show('') }.to raise_error(FinAppsCore::MissingArgumentsError) }
    end

    context 'when proper routing_number is provided' do
      # An ABA routing transit number (ABA RTN) is a nine digit code
      let(:show) { subject.show('999999999') }

      it { expect { show }.not_to raise_error }
      it('returns no error messages') { expect(show[ERROR_MESSAGES]).to be_empty }
      it('returns a hash on the results') { expect(show[RESULTS]).to be_a(Hash) }
      it('includes a base_url on the results') { expect(show[RESULTS]).to respond_to(:base_url) }
      it('includes a display_name on the results') { expect(show[RESULTS]).to respond_to(:display_name) }
      it('includes a site_id on the results') { expect(show[RESULTS]).to respond_to(:site_id) }
      it('includes a org_display_name on the results') { expect(show[RESULTS]).to respond_to(:org_display_name) }
    end


    context 'when proper site_id is provided' do
      # A site_id has less than 9 digits
      let(:show) { subject.show('5') }

      it { expect { show }.not_to raise_error }
      it('returns no error messages') { expect(show[ERROR_MESSAGES]).to be_empty }
      it('returns a hash on the results') { expect(show[RESULTS]).to be_a(Hash) }
      it('includes a base_url on the results') { expect(show[RESULTS]).to respond_to(:base_url) }
      it('includes a display_name on the results') { expect(show[RESULTS]).to respond_to(:display_name) }
      it('includes a site_id on the results') { expect(show[RESULTS]).to respond_to(:site_id) }
      it('includes a org_display_name on the results') { expect(show[RESULTS]).to respond_to(:org_display_name) }
    end
  end
end
