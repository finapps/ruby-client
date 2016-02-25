require 'rspec'
require 'finapps'

module FinApps

  describe FinApps::REST::Client do

    before do
      @client = FinApps::REST::Client.new :company_identifier, :company_token
    end

    it 'responds to send' do
      expect(@client).to respond_to(:send)
    end

    it 'responds to user_credentials!' do
      expect(@client).to respond_to(:user_credentials!)
    end

    it 'responds to public api methods' do
      [:alert, :alert_definition, :alert_settings, :alert_preferences,
       :budgets, :budget_calculation, :budget_models, :cashflows,
       :categories, :institutions, :transactions,
       :user_institutions, :users,
       :rule_sets].each do |method|
        expect(@client).to respond_to(method)
      end
    end

    describe '#new' do
      context 'when company credentials are NOT provided' do
        it 'should raise a MissingArgumentsError exception' do
          expect { FinApps::REST::Client.new nil, nil }.to raise_error(FinApps::REST::MissingArgumentsError)
        end
      end

      context 'when company credentials are of invalid type' do
        it 'should raise an InvalidArgumentsError exception' do
          expect { FinApps::REST::Client.new 1, 2 }.to raise_error(FinApps::REST::InvalidArgumentsError)
        end
      end

      context 'when company credentials are provided' do
        it 'returns a client object' do
          expect(@client).to be_an_instance_of(FinApps::REST::Client)
        end
      end
    end

    describe '.users' do
      it 'returns a Users object' do
        expect(@client.users).to be_an_instance_of(FinApps::REST::Users)
      end
    end

    describe '.users' do
      it 'returns a Users object' do
        expect(@client.users).to be_an_instance_of(FinApps::REST::Users)
      end
    end

    describe '.institutions' do
      it 'returns an Institutions object' do
        expect(@client.institutions).to be_an_instance_of(FinApps::REST::Institutions)
      end
    end

    describe '.user_institutions' do
      it 'returns a UserInstitutions object' do
        expect(@client.user_institutions).to be_an_instance_of(FinApps::REST::UserInstitutions)
      end
    end

    describe '.transactions' do
      it 'returns a Transactions object' do
        expect(@client.transactions).to be_an_instance_of(FinApps::REST::Transactions)
      end
    end

    describe '#connection' do
      it 'looks like Faraday connection' do
        expect(@client.connection).to respond_to(:run_request)
      end
      it 'memoizes the connection' do
        c1, c2 = @client.connection, @client.connection
        expect(c1.object_id).to eq(c2.object_id)
      end
    end

  end
end