module FinApps
  module Logging

    SEVERITY_LABEL = %w(DEBUG INFO WARN ERROR FATAL UNKNOWN)
    PROTECTED_KEYS = %w(login login1 password password1 password_confirm token)
    FORMAT = "\033[%sm[%s#%d] %5s -- %s: %s\033[0m\n"
    FORMAT_TAG = "\033[%sm[%s#%d] %5s -- %s: %s %s\033[0m\n"
    SEVERITY_COLOR_MAP = {:debug => '0', :info => '32', :warn => '33', :error => '31', :fatal => '31', :unknown => '0;37'}


    class << self;
      attr_accessor :tag, :level;
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
          log.level = Logging.level if Logging.level.present?
          log.formatter = proc do |severity, time, progname, msg|
            Logging.tag.present? ?
                FORMAT_TAG % [severity_to_color(severity), format_datetime(time), $$, severity, progname, Logging.tag.to_s, msg2str(msg)] :
                FORMAT % [severity_to_color(severity), format_datetime(time), $$, severity, progname, msg2str(msg)]

          end
        end
      end

    end

    def logger_config(config)
      Logging.tag= config[:logger_tag] if config[:logger_tag].present?
      Logging.level = config[:log_level] if config[:log_level].present?
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
        filtered_hash = hash.clone
        filtered_hash.each do |key, value|
          if PROTECTED_KEYS.include? key.to_s.downcase
            filtered_hash[key] = '[REDACTED]'
          elsif value.is_a?(Hash)
            filtered_hash[key] = self.skip_sensitive_data(value)
          elsif value.is_a?(Array)
            filtered_hash[key] = value.map { |v| v.is_a?(Hash) ? self.skip_sensitive_data(v) : v }
          end
        end

        filtered_hash
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

    def severity_to_color(severity)
      SEVERITY_COLOR_MAP[severity.downcase.to_sym]
    end

  end
end
