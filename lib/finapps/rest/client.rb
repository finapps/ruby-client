# frozen_string_literal: true
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
      def initialize(tenant_identifier, tenant_token, options={}, logger=nil)
        raise FinApps::MissingArgumentsError.new 'Invalid company_identifier.' if tenant_identifier.blank?
        raise FinApps::MissingArgumentsError.new 'Invalid company_token.' if tenant_token.blank?

        merged_options = FinApps::REST::Defaults::DEFAULTS.merge(options.merge(tenant_identifier: tenant_identifier,
                                                                               tenant_token: tenant_token))
        super(merged_options, logger)
      end

      def users
        @users ||= FinApps::REST::Users.new self
      end

      def sessions
        @sessions ||= FinApps::REST::Sessions.new self
      end

      def order_tokens
        @order_tokens ||= FinApps::REST::OrderTokens.new self
      end

      def orders
        @orders ||= FinApps::REST::Orders.new self
      end

      def institutions
        @institutions ||= FinApps::REST::Institutions.new self
      end

      def institutions_forms
        @institutions_forms ||= FinApps::REST::InstitutionsForms.new self
      end

      def user_institutions_statuses
        @user_institutions_statuses ||= FinApps::REST::UserInstitutionsStatuses.new self
      end

      def user_institutions
        @user_institutions ||= FinApps::REST::UserInstitutions.new self
      end
    end
  end
end
