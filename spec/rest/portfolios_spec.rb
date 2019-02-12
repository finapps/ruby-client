require 'spec_helpers/client'

RSpec.describe FinApps::REST::Portfolios do
  include SpecHelpers::Client
  subject { FinApps::REST::Portfolios.new(client) }

  describe '#list' do
    let(:list) { subject.list(params) }
    let(:results) { list[RESULTS] }
    let(:errors) { list[ERROR_MESSAGES] }

    context 'when missing params' do
      let(:params) { nil }

      it { expect { list }.not_to raise_error }
    end
  end

  describe '#show' do

  end

  describe '#create' do

  end

  describe '#update' do

  end

  describe '#destroy' do

  end

end