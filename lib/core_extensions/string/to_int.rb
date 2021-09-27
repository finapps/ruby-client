# frozen_string_literal: true

module StringExtensions
  refine String do
    # Converts string to integer and return nil if not valid
    def to_int
      int = to_i
      int if int.to_s == self
    end
  end
end
