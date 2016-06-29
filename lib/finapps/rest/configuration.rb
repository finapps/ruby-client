module FinApps
  module REST
    class Configuration # :nodoc:
      include FinApps::HashConstructable

      using CoreExtensions::Integerable

      RUBY = "#{RUBY_ENGINE}/#{RUBY_PLATFORM} #{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}".freeze
      HEADERS = {
        accept:     'application/json',
        user_agent: "finapps-ruby/#{FinApps::VERSION} (#{RUBY})"
      }.freeze

      attr_accessor :host, :timeout, :tenant_credentials, :user_credentials, :url,
                    :proxy_addr, :proxy_port, :proxy_user, :proxy_pass,
                    :retry_limit, :log_level

      def initialize(options)
        super(options, FinApps::REST::Defaults::DEFAULTS)
        validate
        @url = "#{host}/v#{FinApps::REST::Defaults::API_VERSION}/"
      end

      def connection_options
        {url:     url,
         request: {open_timeout: timeout, timeout: timeout},
         headers: {accept: HEADERS[:accept], user_agent: HEADERS[:user_agent]}}
      end

      def valid_user_credentials?
        user_credentials.present? && user_credentials[:identifier].present? && user_credentials[:token].present?
      end

      private

      def validate
        raise FinApps::MissingArgumentsError.new 'Missing tenant_credentials.' unless valid_tenant_credentials?
        raise FinApps::InvalidArgumentsError.new "Invalid argument. {host: #{host}}" unless valid_host?
        raise FinApps::InvalidArgumentsError.new "Invalid argument. {timeout: #{timeout}}" unless timeout.integer?
      end

      def valid_tenant_credentials?
        tenant_credentials.present? &&
          tenant_credentials.is_a?(Hash) &&
          %i(identifier token).all? {|x| tenant_credentials.key? x } &&
          tenant_credentials.values.all?(&:present?)
      end

      def valid_host?
        host.start_with?('http://', 'https://')
      end
    end
  end
end
