module FinApps
  module Logging
    SEVERITY_LABEL = %w(DEBUG INFO WARN ERROR FATAL UNKNOWN)

    def logger=(logger)
      @logger = logger
    end

    # noinspection SpellCheckingInspection
    def logger
      @logger ||= ::Logger.new(STDOUT).tap do |log|
        log.progname = "#{self.class.to_s} "
        log.formatter = proc do |severity, time, progname, msg|
          format % [format_datetime(time), $$, severity, progname, msg2str(msg)]
        end
        log.debug "##{__method__.to_s} => Logger instance created"
      end
    end

    def set_up_logger_level(logger_level)
      unless @logger.level == logger_level
        @logger.info "##{__method__.to_s} => Setting logger level to #{SEVERITY_LABEL[logger_level]}"
        @logger.level = logger_level
      end
    end

    private
    def format
      "[%s#%d] %5s -- %s%s\n"
    end

    def format_datetime(time)
      time.strftime('%Y-%m-%dT%H:%M:%S.') << '%06d ' % time.usec
    end

    def msg2str(msg)
      case msg
        when ::String
          msg
        when ::Exception
          "#{ msg.message } (#{ msg.class })\n" << (msg.backtrace || []).join("\n")
        else
          msg.inspect
      end
    end
  end
end