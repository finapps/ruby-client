RSpec.describe FinApps::REST::Orders do
  describe '#create' do
    let(:client) { FinApps::REST::Client.new :company_identifier, :company_token }
    let(:valid_attributes) { {order_token: 'token'} }

    subject { FinApps::REST::Orders.new(client) }
    it 'raises for missing params' do
      expect { subject.create(nil) }.to raise_error(FinApps::MissingArgumentsError)
    end

    # it 'raises for missing params' do
    #   expect { subject.create(valid_attributes) }.to raise_error(FinApps::MissingArgumentsError)
    # end
  end
end
