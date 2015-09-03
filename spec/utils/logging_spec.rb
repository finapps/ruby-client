require 'spec_helper'

RSpec.describe FinApps::Logging do

  let(:dummy_class) { Class.new { extend FinApps::Logging } }
  let(:simple_hash) { {:login => 'login', :password => 'secret'} }
  let(:deep_hash) { {:parameters => {:login => 'login', :password => 'secret'}} }
  let(:array_of_hashes) { {:parameters => [{:login => 'login', :password => 'secret'},
                                           {:login => 'login', :password => 'secret'}]} }

  it 'should redact protected keys on a simple Hash' do
    redacted = dummy_class.skip_sensitive_data simple_hash
    expect(redacted[:password]).to eq('[REDACTED]')
  end

  it 'should redact protected keys on a deep Hash' do
    redacted = dummy_class.skip_sensitive_data deep_hash
    expect(redacted[:parameters][:password]).to eq('[REDACTED]')
  end

  it 'should redact protected keys on an array of Hashes' do
    redacted = dummy_class.skip_sensitive_data array_of_hashes
    expect(redacted[:parameters][0][:password]).to eq('[REDACTED]')
    expect(redacted[:parameters][1][:password]).to eq('[REDACTED]')
  end
end


=begin
params : {:parameters => {"LOGIN1" => "MoneyMatch.site16441.1", "PASSWORD1" => "site16441.1"}}
params : {:email => "erich@example.com", :password => "[REDACTED]"}
=end