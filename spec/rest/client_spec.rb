RSpec.describe FinApps::REST::Client do
  describe '#new' do
    it 'raises for missing company_identifier' do
      expect { FinApps::REST::Client.new nil, :company_token }.to raise_error(FinApps::MissingArgumentsError)
    end

    it 'raises for missing company_token' do
      expect { FinApps::REST::Client.new :company_identifier, nil }
        .to raise_error(FinApps::MissingArgumentsError)
    end
  end

  describe '#connection' do
  end

  describe '#user_credentials!' do
  end

  describe '#send_request' do
  end

  context 'an instance of Client' do
    subject { FinApps::REST::Client.new(:company_identifier, :company_token) }

    %i(connection send_request users).each do |method|
      it "responds to #{method}" do
        expect(subject).to respond_to(method)
      end
    end
  end
end
