RSpec.describe FinApps::REST::Users do

  context 'after initialized' do
    let(:users) { FinApps::REST::Users.new(FinApps::REST::Client.new(:id, :token)) }

    [:show, :create, :update, :update_password, :login, :delete].each do |method|
      it "responds to #{method}" do
        expect(users).to respond_to(method)
      end
    end

    describe '#show' do

      context 'when public_id is NOT provided' do
        it { expect { users.show(nil) }.to raise_error(FinApps::REST::MissingArgumentsError) }
      end

      it { expect(users.show(1)[0]).to be_an_instance_of(FinApps::REST::User) }

    end

  end

end