module FinApps
  module REST
    class Client < BaseClient # :nodoc:
      using ObjectExtensions
      using StringExtensions

      include FinApps::REST::Defaults

      # @param [String] tenant_identifier
      # @param [String] tenant_token
      # @param [Hash] options
      # @return [FinApps::REST::Client]
      def initialize(tenant_identifier, tenant_token, logger=nil, options={})
        raise FinApps::MissingArgumentsError.new 'Invalid company_identifier.' if tenant_identifier.blank?
        raise FinApps::MissingArgumentsError.new 'Invalid company_token.' if tenant_token.blank?

        merged_options = FinApps::REST::Defaults::DEFAULTS.merge(options.merge(tenant_identifier: tenant_identifier,
                                                                               tenant_token: tenant_token))
        super(merged_options, logger)
      end

      def users
        @users ||= FinApps::REST::Users.new self
      end

      def orders
        @orders ||= FinApps::REST::Orders.new self
      end
    end
  end
end
