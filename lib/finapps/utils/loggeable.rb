module FinApps
  module Utils
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
