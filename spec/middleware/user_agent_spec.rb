# frozen_string_literal: true
RSpec.describe FinApps::Middleware::UserAgent do
  let(:fake_app) { proc {|env| env } }
  describe '#call' do
    subject { FinApps::Middleware::UserAgent.new(fake_app) }
    env = {request_headers: {}}

    it('generates a UserAgent header') do
      expect(subject.call(env)[:request_headers][FinApps::Middleware::UserAgent::KEY]).to start_with('finapps-ruby')
    end
  end
end
