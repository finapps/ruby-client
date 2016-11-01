RSpec.describe FinApps::REST::Orders do
  let(:client) { FinApps::REST::Client.new(:company_identifier, :company_token) }

  describe 'timeout' do
    subject { FinApps::REST::Orders.new(client).show(:timeout) }
    it { expect { subject }.to raise_error(FinApps::ApiSessionTimeoutError) }
  end

end