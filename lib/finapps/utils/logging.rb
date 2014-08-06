module FinApps
  module Logging

    SEVERITY_LABEL = %w(DEBUG INFO WARN ERROR FATAL UNKNOWN)
    PROTECTED_KEYS = %w(password password_confirm user_token token)

    class << self;
      attr_accessor :tag;
    end

    def logger=(logger)
      @logger = logger
    end

    # noinspection SpellCheckingInspection
    def logger

      @logger ||= begin
        require 'logger' unless defined?(::Logger)
        ::Logger.new(STDOUT).tap do |log|
          log.progname = "#{self.class.to_s}"
          log.formatter = proc do |severity, time, progname, msg|
            Logging.tag.present? ?
                "[%s#%d] %5s -- %s: %s %s\n" % [format_datetime(time), $$, severity, progname, Logging.tag.to_s, msg2str(msg)] :
                "[%s#%d] %5s -- %s: %s\n" % [format_datetime(time), $$, severity, progname, msg2str(msg)]

          end
        end
      end

    end

    def set_up_logger_level(logger_level)
      unless logger_level.blank? || @logger.level == logger_level
        @logger.info "##{__method__.to_s} => Setting logger level to #{SEVERITY_LABEL[logger_level]}"
        @logger.level = logger_level
      end
    end

    # noinspection SpellCheckingInspection
    def set_up_logger_session_params(uuid, session_id)
      if uuid.present? || session_id.present?
        uuid ||= '-'
        session_id ||= '-'
        logger.formatter = proc do |severity, time, progname, msg|
          "[%s#%d] %5s -- %s: [#{uuid}] [#{session_id}] %s\n" % [format_datetime(time), $$, severity, progname, msg2str(msg)]
        end
      end
    end

    # @param [Hash] hash
    def skip_sensitive_data(hash)
      if hash.is_a? Hash
        redacted = hash.clone
        redacted.update(redacted) { |key, v1| (PROTECTED_KEYS.include? key.to_s.downcase) ? '[REDACTED]' : v1 }
      else
        hash
      end
    end

    private
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