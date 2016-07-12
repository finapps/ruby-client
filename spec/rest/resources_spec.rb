RSpec.describe FinApps::REST::Resources do

  describe '#new' do
    subject { FinApps::REST::Resources.new(nil) }
    it { expect { subject }.to raise_error(FinApps::MissingArgumentsError, 'Missing argument: client.') }
  end


end
