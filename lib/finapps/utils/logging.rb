module FinApps
  module Logging
    SEVERITY_LABEL = %w(DEBUG INFO WARN ERROR FATAL UNKNOWN)

    def logger=(logger)
      @logger = logger
    end

    def logger
      @logger ||= ::Logger.new(STDOUT).tap do |log|
        log.progname = 'finapps'
        log.debug 'FinApps::Logging#logger => Logger instance created'
      end
    end

    def set_up_logger_level(logger_level)
      unless @logger.level == logger_level
        @logger.info "FinApps::Logging#set_up_logger_level => logger level set to #{SEVERITY_LABEL[logger_level]}"
        @logger.level = logger_level
      end
    end

  end
end