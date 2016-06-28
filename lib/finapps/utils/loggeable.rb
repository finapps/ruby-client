module FinApps
  module Utils
    # Adds logging capabilities when included into other classes
    module Loggeable
      def logger
        @logger ||= begin
          require 'logger'
          ::Logger.new(STDOUT)
        end
      end
    end
  end
end
