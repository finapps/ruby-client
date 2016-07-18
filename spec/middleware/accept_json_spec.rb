# frozen_string_literal: true
RSpec.describe FinApps::Middleware::AcceptJson do
  let(:fake_app) { proc {|env| env } }
  describe '#call' do
    subject { FinApps::Middleware::AcceptJson.new(fake_app) }
    env = {request_headers: {}}

    it('generates a UserAgent header') do
      expect(subject.call(env)[:request_headers][FinApps::Middleware::AcceptJson::KEY]).to eq('application/json')
    end
  end
end
