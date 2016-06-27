module FinApps
  module REST
    class Configuration # :nodoc:
      RUBY = "#{RUBY_ENGINE}/#{RUBY_PLATFORM} #{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}".freeze
      HEADERS = {
        accept:     'application/json',
        user_agent: "finapps-ruby/#{FinApps::VERSION} (#{RUBY})"
      }.freeze

      attr_reader :host, :timeout, :tenant_credentials, :user_credentials, :versioned_url

      def initialize(config)
        merged_config = FinApps::REST::Defaults::DEFAULTS.merge(config.compact)
        merged_config.each {|k, v| instance_variable_set("@#{k}", v) unless v.nil? }

        raise MissingArgumentsError.new 'Missing tenant_credentials.' if tenant_credentials.blank?
        raise InvalidArgumentsError.new 'Invalid company_identifier.' if tenant_credentials[:identifier].blank?
        raise InvalidArgumentsError.new 'Invalid company_token.' if tenant_credentials[:token].blank?
        raise InvalidArgumentsError.new "Invalid argument. {host: #{host}}" unless valid_host?
        raise InvalidArgumentsError.new "Invalid argument. {timeout: #{timeout}}" unless valid_timeout?

        @versioned_url = "#{host}/v#{FinApps::REST::Defaults::API_VERSION}"
      end

      def connection_options
        {url:     versioned_url,
         request: {open_timeout: timeout, timeout: timeout},
         headers: {accept: HEADERS[:accept], user_agent: HEADERS[:user_agent]}}
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
