require 'rspec'
require 'finapps'

module FinApps

  RSpec.describe FinApps::REST::Client do

    describe '#new' do

      context 'when company_identifier is NOT provided' do
        it { expect { FinApps::REST::Client.new nil, :company_token }.to raise_error(FinApps::REST::MissingArgumentsError) }
      end

      context 'when company_token is NOT provided' do
        it { expect { FinApps::REST::Client.new :company_identifier, nil }.to raise_error(FinApps::REST::MissingArgumentsError) }
      end

      context 'when company_identifier is not string or symbol' do
        it { expect { FinApps::REST::Client.new 1, :company_token }.to raise_error(FinApps::REST::InvalidArgumentsError) }
      end

      context 'when company_token is not string or symbol' do
        it { expect { FinApps::REST::Client.new :company_token, 1 }.to raise_error(FinApps::REST::InvalidArgumentsError) }
      end

    end


    context 'when Client initialized' do

      let(:client) { FinApps::REST::Client.new(:company_identifier, :company_token) }

      [:send, :connection, :users, :institutions, :user_institutions, :transactions,
       :categories, :budget_models, :budget_calculation, :budgets, :cashflows, :alert,
       :alert_definition, :alert_preferences, :alert_settings, :rule_sets, :user_credentials!].each do |method|
        it "responds to #{method}" do
          expect(client).to respond_to(method)
        end
      end

      describe '#users' do
        it 'returns a Users object' do
          expect(client.users).to be_an_instance_of(FinApps::REST::Users)
        end
      end

      describe '#users' do
        it 'returns a Users object' do
          expect(client.users).to be_an_instance_of(FinApps::REST::Users)
        end
      end

      describe '#institutions' do
        it 'returns an Institutions object' do
          expect(client.institutions).to be_an_instance_of(FinApps::REST::Institutions)
        end
      end

      describe '#user_institutions' do
        it 'returns a UserInstitutions object' do
          expect(client.user_institutions).to be_an_instance_of(FinApps::REST::UserInstitutions)
        end
      end

      describe '#transactions' do
        it 'returns a Transactions object' do
          expect(client.transactions).to be_an_instance_of(FinApps::REST::Transactions)
        end
      end

      describe '#connection' do
        it 'looks like Faraday connection' do
          expect(client.connection).to respond_to(:run_request)
        end
        it 'memoizes the connection' do
          c1, c2 = client.connection, client.connection
          expect(c1.object_id).to eq(c2.object_id)
        end
      end

    end
  end
end
