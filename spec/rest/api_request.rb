# frozen_string_literal: true

RSpec.shared_examples 'an API request' do |_parameter|
  it do
    expect do
      # noinspection RubyBlockToMethodReference
      subject
    end.not_to raise_error
  end

  it('returns an array') { expect(subject).to be_a(Array) }
end

RSpec.shared_examples 'a successful request' do |_parameter|
  it('returns no error messages') do
    expect(subject[ERROR_MESSAGES]).to be_empty
  end
end
