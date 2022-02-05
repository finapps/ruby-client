# frozen_string_literal: true

require 'spec_helpers/client'
require 'spec_helpers/api_request'

RSpec.describe FinApps::REST::Query::Base do
  describe '#end_point' do
    it 'starts with the word query' do
      expect(described_class.new(:client).end_point).to start_with('query')
    end
  end
end
