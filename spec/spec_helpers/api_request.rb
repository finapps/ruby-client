# frozen_string_literal: true

RSpec.shared_examples 'an API request' do
  it { expect { subject }.not_to raise_error }
  it('returns an array') { expect(subject).to be_a(Array) }
end

RSpec.shared_examples 'a successful request' do
  it('returns no error messages') do
    expect(subject[ERROR_MESSAGES]).to be_empty
  end
end

RSpec.shared_examples 'a failed request' do
  it { expect(subject[RESULTS]).to be_nil }
  it { expect(subject[ERROR_MESSAGES]).not_to be_empty }
end

RSpec.shared_examples 'a request that raises an error' do |err|
  err = FinAppsCore::MissingArgumentsError if err.nil?
  it { expect { subject }.to raise_error(err) }
end

RSpec.shared_examples 'a GET index request' do
  it { expect(subject[RESULTS]).to have_key(:records) }

  it('returns an array of records') do
    expect(subject[RESULTS][:records]).to be_a(Array)
  end
end
