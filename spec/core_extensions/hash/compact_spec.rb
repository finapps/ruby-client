# frozen_string_literal: true
class RefinedHash < Hash
  using HashExtensions
  def compacted
    compact
  end

  def compacted!
    compact!
  end
end

RSpec.describe HashExtensions do
  let(:hash) do
    RefinedHash.new
  end

  before(:each) do
    hash[:a] = true
    hash[:b] = false
    hash[:c] = nil
  end

  describe '#compact' do
    it 'returns a hash with non nil values' do
      expect(hash.compacted).to eq(a: true, b: false)
      expect(hash).to eq(a: true, b: false, c: nil)
    end
  end
  describe '#compact!' do
    it 'replaces current hash with non nil values' do
      hash[:a] = true
      hash[:b] = false
      hash[:c] = nil
      expect(hash.compacted!).to eq(a: true, b: false)
      expect(hash).to eq(a: true, b: false)
    end
  end
end
