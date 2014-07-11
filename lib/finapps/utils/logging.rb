module FinApps
  module Logging

    SEVERITY_LABEL = %w(DEBUG INFO WARN ERROR FATAL UNKNOWN)
    PROTECTED_KEYS = [:password, :password_confirm]

    def logger=(logger)
      @logger = logger
    end

    # noinspection SpellCheckingInspection
    def logger
<<<<<<< HEAD

      @logger ||= begin
        require 'logger' unless defined?(::Logger)
        ::Logger.new(STDOUT).tap do |log|
          log.progname = "#{self.class.to_s}"
          log.formatter = proc do |severity, time, progname, msg|
            "[%s#%d] %5s -- %s: %s\n" % [format_datetime(time), $$, severity, progname, msg2str(msg)]
          end
        end
=======
      @logger ||= ::Logger.new(STDOUT).tap do |log|
        log.progname = "#{self.class.to_s} "
        log.formatter = proc do |severity, time, progname, msg|
          format % [format_datetime(time), $$, severity, progname, msg2str(msg)]
        end
        log.debug "##{__method__.to_s} => Logger instance created"
>>>>>>> c8eb56c73da0329b3834b9f7f3c985dfbb503a0b
      end

    end

    def set_up_logger_level(logger_level)
      unless logger_level.blank? || @logger.level == logger_level
        @logger.info "##{__method__.to_s} => Setting logger level to #{SEVERITY_LABEL[logger_level]}"
        @logger.level = logger_level
      end
    end

<<<<<<< HEAD
    # @param [Hash] hash
    def skip_sensitive_data(hash)
      hash.update(hash) { |key, v1| (PROTECTED_KEYS.include? key) ? '[REDACTED]' : v1 } if hash.is_a? Hash
      hash
    end

    private
=======
    private
    def format
      "[%s#%d] %5s -- %s%s\n"
    end

>>>>>>> c8eb56c73da0329b3834b9f7f3c985dfbb503a0b
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
<<<<<<< HEAD

=======
>>>>>>> c8eb56c73da0329b3834b9f7f3c985dfbb503a0b
  end
end