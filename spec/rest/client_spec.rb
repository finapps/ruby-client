RSpec.describe FinApps::REST::Client do
  describe '#new' do
    it 'raises for missing company_identifier' do
      expect { FinApps::REST::Client.new nil, :company_token }.to raise_error(FinApps::MissingArgumentsError)
    end

    it 'raises for missing company_token' do
      expect { FinApps::REST::Client.new :company_identifier, nil }.to raise_error(FinApps::MissingArgumentsError)
    end
  end

  context 'an instance of Client' do
    subject { FinApps::REST::Client.new(:company_identifier, :company_token) }

    %i(users).each do |method|
      it "responds to #{method}" do
        expect(subject).to respond_to(method)
      end
    end

    describe '#users' do
      it { expect(subject.users).to be_an_instance_of(FinApps::REST::Users) }
    end
  end
end
