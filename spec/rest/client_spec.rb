require 'rspec'
require 'finapps'

module FinApps

  describe FinApps::REST::Client do

    before do
      @client = FinApps::REST::Client.new :company_identifier, :company_token
    end

    describe '#new' do
      context 'when company credentials are NOT provided' do
        it 'should raise a MissingArgumentsError exception' do
          expect { FinApps::REST::Client.new nil, nil }.to raise_error(FinApps::REST::MissingArgumentsError)
        end
      end

      context 'when company credentials are of invalid type' do
        it 'should raise an InvalidArgumentsError exception' do
          expect{FinApps::REST::Client.new 1, 2}.to raise_error(FinApps::REST::InvalidArgumentsError)
        end
      end

      context 'when company credentials are provided' do
        it 'returns a client object' do
          expect(@client).to be_an_instance_of(FinApps::REST::Client)
        end
      end
    end

    describe '#get' do
      it 'responds to get' do
        expect(@client).to respond_to(:get)
      end
    end

    describe '#post' do
      it 'responds to post' do
        expect(@client).to respond_to(:post)
      end
    end

    describe '.users' do
      it 'returns a Users object' do
        expect(@client.users).to be_an_instance_of(FinApps::REST::Users)
      end
    end

    describe '#connection' do
      it 'looks like Faraday connection' do
        expect(@client.send(:connection)).to respond_to(:run_request)
      end
      it 'memoizes the connection' do
        c1, c2 = @client.send(:connection), @client.send(:connection)
        expect(c1.object_id).to eq(c2.object_id)
      end
    end

  end
end