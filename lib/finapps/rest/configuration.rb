# frozen_string_literal: true
module FinApps
  module REST
    # Represents the client configuration options
    class Configuration # :nodoc:
      using ObjectExtensions
      using HashExtensions

      attr_accessor :host,
                    :tenant_identifier, :tenant_token,
                    :user_identifier, :user_token,
                    :proxy, :timeout, :retry_limit, :log_level

      def initialize(options={})
        FinApps::REST::Defaults::DEFAULTS.merge(options.compact).each {|key, value| public_send("#{key}=", value) }
        raise FinApps::InvalidArgumentsError.new "Invalid argument. {host: #{host}}" unless valid_host?
        raise FinApps::InvalidArgumentsError.new "Invalid argument. {timeout: #{timeout}}" unless timeout.integer?
      end

      private

      def valid_host?
        host.start_with?('http://', 'https://')
      end
    end
  end
end
