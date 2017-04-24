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
      it "responds to #{method}" do
        expect(subject).to respond_to(method)
      end
    end

    describe '#version' do
      it { expect(subject.version).to be_an_instance_of(FinApps::REST::Version) }
    end

    describe '#consumers' do
      it { expect(subject.consumers).to be_an_instance_of(FinApps::REST::Consumers) }
    end

    describe '#sessions' do
      it { expect(subject.sessions).to be_an_instance_of(FinApps::REST::Sessions) }
    end

    describe '#order_statuses' do
      it { expect(subject.order_statuses).to be_an_instance_of(FinApps::REST::OrderStatuses) }
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

    describe '#institutions' do
      it { expect(subject.institutions).to be_an_instance_of(FinApps::REST::Institutions) }
    end

    describe '#institutions_forms' do
      it { expect(subject.institutions_forms).to be_an_instance_of(FinApps::REST::InstitutionsForms) }
    end

    describe '#user_institutions_statuses' do
      it { expect(subject.user_institutions_statuses).to be_an_instance_of(FinApps::REST::UserInstitutionsStatuses) }
    end

    describe '#user_institutions' do
      it { expect(subject.user_institutions).to be_an_instance_of(FinApps::REST::UserInstitutions) }
    end

    describe '#user_institutions_forms' do
      it { expect(subject.user_institutions_forms).to be_an_instance_of(FinApps::REST::UserInstitutionsForms) }
    end

    describe '#password_resets' do
      it { expect(subject.password_resets).to be_an_instance_of(FinApps::REST::PasswordResets) }
    end

    describe '#password_resets' do
      it { expect(subject.operators).to be_an_instance_of(FinApps::REST::Operators) }
    end

    FinApps::REST::Client::RESOURCES.each do |method|
      it "memoizes the result of #{method}" do
        first = subject.send(method)
        second = subject.send(method)
        expect(first.object_id).to eq(second.object_id)
      end
    end
  end
end
