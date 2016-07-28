# frozen_string_literal: true
RSpec.describe FinApps::Middleware::RaiseError do
  let(:fake_app) { proc {|env| env } }
  Env = Struct.new(:status, :response_headers, :body)

  describe '#on_complete' do
    subject { FinApps::Middleware::RaiseError.new(fake_app) }

    context 'for succesful requests' do
      let(:env) { Env.new(200) }
      it { expect { subject.on_complete(env) }.not_to raise_error }
    end
    context 'for client errors' do
      let(:env) { Env.new(401, {}, '{"messages":["Invalid User Identifier or Credentials"]}') }
      error_message = 'the server responded with status 401'
      it { expect { subject.on_complete(env) }.to raise_error(Faraday::Error::ClientError, error_message) }
    end
    context 'for connection failed error' do
      let(:env) { Env.new(407) }
      error_message = '407 "Proxy Authentication Required"'
      it { expect { subject.on_complete(env) }.to raise_error(Faraday::Error::ConnectionFailed, error_message) }
    end
  end
end
