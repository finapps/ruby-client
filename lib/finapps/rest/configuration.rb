module FinApps
  module REST
    class Configuration # :nodoc:
      attr_reader :host, :timeout, :tenant_credentials, :user_credentials, :versioned_url

      def initialize(config)
        merged_config = FinApps::REST::Defaults::DEFAULTS.merge(config.compact)
        merged_config.each {|k, v| instance_variable_set("@#{k}", v) unless v.nil? }

        raise InvalidArgumentsError.new "Invalid argument. {host: #{host}}" unless valid_host?
        raise InvalidArgumentsError.new "Invalid argument. {timeout: #{timeout}}" unless valid_timeout?

        @versioned_url = "#{host}/v#{FinApps::REST::Defaults::API_VERSION}"
      end

      def valid_user_credentials?
        user_credentials.present? && user_credentials[:identifier].present? && user_credentials[:token].present?
      end

      private

      def valid_host?
        host.start_with?('http://', 'https://')
      end

      def valid_timeout?
        Integer timeout
      rescue
        false
      end
    end
  end
end
