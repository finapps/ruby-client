module FinApps
  module Logging
    SEVERITY_LABEL = %w(DEBUG INFO WARN ERROR FATAL UNKNOWN)

    def logger=(logger)
      @logger = logger
    end

    def logger
      @logger ||= ::Logger.new(STDOUT).tap do |log|
        log.progname = "#{self.class.to_s}"
        log.debug "##{__method__.to_s} => Logger instance created"
      end
    end

    def set_up_logger_level(logger_level)
      unless @logger.level == logger_level
        @logger.info "##{__method__.to_s} => Setting logger level to #{SEVERITY_LABEL[logger_level]}"
        @logger.level = logger_level
      end
    end

  end
end