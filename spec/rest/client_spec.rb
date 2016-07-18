# frozen_string_literal: true
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

    %i(users orders).each do |method|
      it "responds to #{method}" do
        expect(subject).to respond_to(method)
      end
    end

    describe '#users' do
      it { expect(subject.users).to be_an_instance_of(FinApps::REST::Users) }
    end

    describe '#orders' do
      it { expect(subject.orders).to be_an_instance_of(FinApps::REST::Orders) }
    end

    # [:users, :institutions, :user_institutions, :transactions, :categories,
    # :budget_models, :budget_calculation, :budgets, :cashflows,
    # :alert, :alert_definition, :alert_preferences, :alert_settings, :rule_sets]
    %i(users orders).each do |method|
      it "memoizes the result of #{method}" do
        first = subject.send(method)
        second = subject.send(method)
        expect(first.object_id).to eq(second.object_id)
      end
    end
  end
end
