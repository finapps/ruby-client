module FinApps
  module REST
    class Configuration # :nodoc:
      using CoreExtensions::Integerable

      RUBY = "#{RUBY_ENGINE}/#{RUBY_PLATFORM} #{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}".freeze
      HEADERS = {
        accept:     'application/json',
        user_agent: "finapps-ruby/#{FinApps::VERSION} (#{RUBY})"
      }.freeze

      attr_reader :host, :timeout, :tenant_credentials, :user_credentials, :versioned_url

      def initialize(options)
        load options
        validate
        @versioned_url = "#{host}/v#{FinApps::REST::Defaults::API_VERSION}/"
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

      def validate
        raise MissingArgumentsError.new 'Missing tenant_credentials.' if tenant_credentials.blank?
        raise InvalidArgumentsError.new 'Invalid company_identifier.' if tenant_credentials[:identifier].blank?
        raise InvalidArgumentsError.new 'Invalid company_token.' if tenant_credentials[:token].blank?
        raise InvalidArgumentsError.new "Invalid argument. {host: #{host}}" unless valid_host?
        raise InvalidArgumentsError.new "Invalid argument. {timeout: #{timeout}}" unless timeout.integer?
      end

      def load(options)
        merged_config = FinApps::REST::Defaults::DEFAULTS.merge(options.compact)
        merged_config.each {|k, v| instance_variable_set("@#{k}", v) unless v.nil? }
      end

      def valid_host?
        host.start_with?('http://', 'https://')
      end
    end
  end
end
