module FinApps
  module REST
    class Client < BaseClient # :nodoc:
      include FinApps::REST::Defaults

      # @param [String] company_identifier
      # @param [String] company_token
      # @param [Hash] options
      # @return [FinApps::REST::Client]
      def initialize(company_identifier, company_token, logger=nil, options={})
        raise FinApps::REST::MissingArgumentsError.new 'Invalid company_identifier.' if company_identifier.blank?
        raise FinApps::REST::MissingArgumentsError.new 'Invalid company_token.' if company_token.blank?

        merged_options = FinApps::REST::Defaults::DEFAULTS.merge options
        merged_options[:tenant_credentials] = {identifier: company_identifier, token: company_token}

        super(merged_options, logger)
      end

      def users
        @users ||= FinApps::REST::Users.new self
      end

      # # @param [String] user_identifier
      # # @param [String] user_token
      # def user_credentials!(user_identifier, user_token)
      #   raise FinApps::REST::MissingArgumentsError.new 'Invalid user_identifier.' if user_identifier.blank?
      #   raise FinApps::REST::MissingArgumentsError.new 'Invalid user_token.' if user_token.blank?
      #
      #   @config[:user_credentials] = {identifier: user_identifier, token: user_token}
      #   @connection = faraday_connection(url:     config.versioned_url,
      #                                    request: {open_timeout: config.timeout, timeout: config.timeout},
      #                                    headers: {accept: HEADERS[:accept], user_agent: HEADERS[:user_agent]})
      # end
    end
  end
end
