module FinApps
  module REST
    # Represents the client configuration options
    class Configuration # :nodoc:
      using ObjectExtensions
      using HashExtensions

      RUBY = "#{RUBY_ENGINE}/#{RUBY_PLATFORM} #{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}".freeze
      HEADERS = {
        accept:     'application/json',
        user_agent: "finapps-ruby/#{FinApps::VERSION} (#{RUBY})"
      }.freeze

      attr_accessor :host, :timeout, :tenant_credentials, :user_credentials, :url,
                    :proxy_addr, :proxy_port, :proxy_user, :proxy_pass,
                    :retry_limit, :log_level

      def initialize(options={})
        FinApps::REST::Defaults::DEFAULTS.merge(options.compact).each {|k, v| public_send("#{k}=", v) }

        validate
        @url = "#{host}/v#{FinApps::REST::Defaults::API_VERSION}/"
      end

      def connection_options
        {url:     url,
         request: {open_timeout: timeout, timeout: timeout},
         headers: {accept: HEADERS[:accept], user_agent: HEADERS[:user_agent]}}
      end

      def valid_user_credentials?
        valid_credentials? user_credentials
      end

      private

      def validate
        raise FinApps::MissingArgumentsError.new 'Missing tenant_credentials.' unless valid_tenant_credentials?
        raise FinApps::InvalidArgumentsError.new "Invalid argument. {host: #{host}}" unless valid_host?
        raise FinApps::InvalidArgumentsError.new "Invalid argument. {timeout: #{timeout}}" unless timeout.integer?
      end

      def valid_tenant_credentials?
        valid_credentials? tenant_credentials
      end

      def valid_credentials?(h)
        h.is_a?(Hash) && %i(identifier token).all? {|x| h.key? x } && h.values.all? {|v| !v.nil? && v != '' }
      end

      def valid_host?
        host.start_with?('http://', 'https://')
      end
    end
  end
end
