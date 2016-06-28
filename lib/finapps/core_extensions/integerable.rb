module CoreExtensions
  # adds an integer? method to any object when used in a class
  module Integerable
    refine Object do
      def integer?
        Integer(self)
      rescue
        false
      else
        true
      end
    end
  end
end
