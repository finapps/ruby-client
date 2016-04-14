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
      it { expect { FinApps::REST::Client.new :company_identifier, 1 }.to raise_error(FinApps::REST::InvalidArgumentsError) }
    end

    context 'when options are not provided' do
      it { expect { FinApps::REST::Client.new :company_identifier, :company_token }.not_to raise_error }
    end

  end

  context 'after initialized' do

    let(:client) { FinApps::REST::Client.new(:company_identifier, :company_token) }

    [:send_request, :connection, :users, :institutions, :user_institutions, :transactions,
     :categories, :budget_models, :budget_calculation, :budgets, :cashflows, :alert,
     :alert_definition, :alert_preferences, :alert_settings, :rule_sets, :user_credentials!].each do |method|
      it "responds to #{method}" do
        expect(client).to respond_to(method)
      end
    end

    describe '#users' do
      it { expect(client.users).to be_an_instance_of(FinApps::REST::Users) }
    end

    describe '#institutions' do
      it { expect(client.institutions).to be_an_instance_of(FinApps::REST::Institutions) }
    end

    describe '#user_institutions' do
      it { expect(client.user_institutions).to be_an_instance_of(FinApps::REST::UserInstitutions) }
    end

    describe '#categories' do
      it { expect(client.categories).to be_an_instance_of(FinApps::REST::Categories) }
    end

    describe '#budget_models' do
      it { expect(client.budget_models).to be_an_instance_of(FinApps::REST::BudgetModels) }
    end

    describe '#budget_calculation' do
      it { expect(client.budget_calculation).to be_an_instance_of(FinApps::REST::BudgetCalculation) }
    end

    describe '#budgets' do
      it { expect(client.budgets).to be_an_instance_of(FinApps::REST::Budgets) }
    end

    describe '#cashflows' do
      it { expect(client.cashflows).to be_an_instance_of(FinApps::REST::Cashflows) }
    end

    describe '#alert' do
      it { expect(client.alert).to be_an_instance_of(FinApps::REST::Alert) }
    end

    describe '#alert_definition' do
      it { expect(client.alert_definition).to be_an_instance_of(FinApps::REST::AlertDefinition) }
    end

    describe '#alert_preferences' do
      it { expect(client.alert_preferences).to be_an_instance_of(FinApps::REST::AlertPreferences) }
    end

    describe '#alert_settings' do
      it { expect(client.alert_settings).to be_an_instance_of(FinApps::REST::AlertSettings) }
    end

    describe '#rule_sets' do
      it { expect(client.rule_sets).to be_an_instance_of(FinApps::REST::Relevance::Rulesets) }
    end

    describe '#connection' do
      it { expect(client.connection).to be_an_instance_of(Faraday::Connection) }
    end

    [:connection, :users, :institutions, :user_institutions, :transactions,
     :categories, :budget_models, :budget_calculation, :budgets, :cashflows, :alert,
     :alert_definition, :alert_preferences, :alert_settings, :rule_sets].each do |method|
      it "memoizes the result of #{method}" do
        first, second = client.send(method), client.send(method)
        expect(first.object_id).to eq(second.object_id)
      end
    end

    describe '#send_request' do

      context 'when path is NOT provided' do
        it { expect { client.send_request(nil, :post) }.to raise_error(FinApps::REST::MissingArgumentsError) }
      end

      context 'when method is NOT provided' do
        it { expect { client.send_request(:path, nil) }.to raise_error(FinApps::REST::MissingArgumentsError) }
      end

      context 'when method is NOT supported' do
        it { expect { client.send_request(:path, :unsupported_method) }.to raise_error(FinApps::REST::InvalidArgumentsError) }
      end

    end

  end

end

