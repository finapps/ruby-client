RSpec.describe FinApps::REST::Client do
  describe '#new' do
    it 'raises for missing company_identifier' do
      expect { FinApps::REST::Client.new nil, :company_token }
          .to raise_error(FinApps::REST::MissingArgumentsError)
    end

    it 'raises for missing company_token' do
      expect { FinApps::REST::Client.new :company_identifier, nil }
          .to raise_error(FinApps::REST::MissingArgumentsError)
    end

    it 'assigns @config' do

    end


    it 'assigns @logger' do

    end
  end

  describe '#connection' do

  end

  describe '#user_credentials!' do

  end

  describe '#send_request' do

  end
end