# frozen_string_literal: true

RSpec.shared_examples 'an API request' do |_parameter|
  it { expect { subject }.not_to raise_error }

  it('returns an array') { expect(subject).to be_a(Array) }
end

RSpec.shared_examples 'a successful request' do |_parameter|
  it('returns no error messages') do
    expect(subject[ERROR_MESSAGES]).to be_empty
  end
end

RSpec.shared_examples 'a request that raises an error' do |parameter|
  it do
    expect { subject }.to raise_error(
      parameter || FinAppsCore::MissingArgumentsError
    )
  end
end

RSpec.shared_examples 'a GET index request' do
  it { expect(results).to have_key(:records) }

  it('returns an array of records') do
    expect(results[:records]).to be_a(Array)
  end
end
