# frozen_string_literal: true

RSpec.describe FinApps::REST::Client do
  describe '#new' do
    it 'raises for missing company_token' do
      expect { FinApps::REST::Client.new nil }.to raise_error(FinAppsCore::MissingArgumentsError)
    end
  end

  context 'an instance of Client' do
    subject { FinApps::REST::Client.new(:company_token) }

    FinApps::REST::Client::RESOURCES.each do |method|
      it("responds to #{method}") { expect(subject).to respond_to(method) }

      it "memoizes the result of #{method}" do
        first = subject.send(method)
        second = subject.send(method)
        expect(first.object_id).to eq(second.object_id)
      end
    end

    describe '#alert_definitions' do
      it { expect(subject.alert_definitions).to be_an_instance_of(FinApps::REST::AlertDefinitions) }
    end

    describe '#alert_occurrences' do
      it { expect(subject.alert_occurrences).to be_an_instance_of(FinApps::REST::AlertOccurrences) }
    end

    describe '#version' do
      it { expect(subject.version).to be_an_instance_of(FinApps::REST::Version) }
    end

    describe '#consumers' do
      it { expect(subject.consumers).to be_an_instance_of(FinApps::REST::Consumers) }
    end

    describe '#plaid_webhooks' do
      it do
        expect(subject.plaid_webhooks).to be_an_instance_of FinApps::REST::PlaidWebhooks
      end
    end

    describe '#sessions' do
      it { expect(subject.sessions).to be_an_instance_of(FinApps::REST::Sessions) }
    end

    describe '#order_assignments' do
      it { expect(subject.order_assignments).to be_an_instance_of(FinApps::REST::OrderAssignments) }
    end

    describe '#order_statuses' do
      it { expect(subject.order_notifications).to be_an_instance_of(FinApps::REST::OrderNotifications) }
    end

    describe '#order_statuses' do
      it { expect(subject.order_statuses).to be_an_instance_of(FinApps::REST::OrderStatuses) }
    end

    describe '#order_refreshes' do
      it { expect(subject.order_refreshes).to be_an_instance_of(FinApps::REST::OrderRefreshes) }
    end

    describe '#order_reports' do
      it { expect(subject.order_reports).to be_an_instance_of(FinApps::REST::OrderReports) }
    end

    describe '#order_tokens' do
      it { expect(subject.order_tokens).to be_an_instance_of(FinApps::REST::OrderTokens) }
    end

    describe '#orders' do
      it { expect(subject.orders).to be_an_instance_of(FinApps::REST::Orders) }
    end

    describe '#password_resets' do
      it { expect(subject.password_resets).to be_an_instance_of(FinApps::REST::PasswordResets) }
    end

    describe '#operators_password_resets' do
      it { expect(subject.operators_password_resets).to be_an_instance_of(FinApps::REST::OperatorsPasswordResets) }
    end

    describe '#operators' do
      it { expect(subject.operators).to be_an_instance_of(FinApps::REST::Operators) }
    end

    describe '#products' do
      it { expect(subject.products).to be_an_instance_of(FinApps::REST::Products) }
    end

    describe '#portfolios' do
      it { expect(subject.portfolios).to be_an_instance_of(FinApps::REST::Portfolios) }
    end

    describe '#portfolios_alerts' do
      it { expect(subject.portfolios_alerts).to be_an_instance_of(FinApps::REST::PortfoliosAlerts) }
    end

    describe '#portfolios_available_consumers' do
      it {
        expect(subject.portfolios_available_consumers).to be_an_instance_of(FinApps::REST::PortfoliosAvailableConsumers)
      }
    end

    describe '#portfolios_consumers' do
      it { expect(subject.portfolios_consumers).to be_an_instance_of(FinApps::REST::PortfoliosConsumers) }
    end

    describe '#consumers_portfolios' do
      it { expect(subject.consumers_portfolios).to be_an_instance_of(FinApps::REST::ConsumersPortfolios) }
    end

    describe '#portfolio_reports' do
      it { expect(subject.portfolio_reports).to be_an_instance_of(FinApps::REST::PortfolioReports) }
    end

    describe '#tenant_settings' do
      it { expect(subject.tenant_settings).to be_an_instance_of(FinApps::REST::TenantSettings) }
    end

    describe '#tenant_app_settings' do
      it { expect(subject.tenant_app_settings).to be_an_instance_of(FinApps::REST::TenantAppSettings) }
    end

    describe '#plaid_webhooks' do
      it { expect(subject.plaid_webhooks).to be_an_instance_of(FinApps::REST::PlaidWebhooks) }
    end
  end
end
