module FinApps
  module Logging

    def logger=(logger)
      @logger = logger
    end

    def logger
      @logger ||= ::Logger.new(STDOUT).tap do |log|
        log.progname = 'finapps'
        log.debug 'FinApps::Logging#logger => Logger instance created'
      end
    end

  end
end