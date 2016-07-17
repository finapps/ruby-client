# frozen_string_literal: true
class TestClass
  using ObjectExtensions

  def is_integer?(object)
    object.integer?
  end
end

RSpec.describe ObjectExtensions do
  describe '#integer?' do
    it('returns true for integers') { expect(TestClass.new.is_integer?(1 + rand(10))).to eq(true) }
  end
  describe '#integer?' do
    it('returns false for non integers') { expect(TestClass.new.is_integer?(rand)).to eq(false) }
  end
end
