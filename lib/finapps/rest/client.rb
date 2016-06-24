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

      # Performs HTTP GET, POST, UPDATE and DELETE requests.
      # You shouldn't need to use this method directly, but it can be useful for debugging.
      # Returns a hash obtained from parsing the JSON object in the response body.
      #
      # @param [String] path
      # @param [String] method
      # @param [Hash] params
      # @return [Hash,Array<String>]
      def send_request(path, method, params={})
        raise FinApps::REST::MissingArgumentsError.new 'Missing argument: path.' if path.blank?
        raise FinApps::REST::MissingArgumentsError.new 'Missing argument: method.' if method.blank?

        result = nil
        response, error_messages = execute_request(method, params, path)
        if response.present?
          result = block_given? ? yield(response) : response.body
        else
          logger.error "##{__method__} => Null response found. Unable to process it."
        end

        [result, error_messages]
      end

      # @param [String] user_identifier
      # @param [String] user_token
      def user_credentials!(user_identifier, user_token)
        raise FinApps::REST::MissingArgumentsError.new 'Invalid user_identifier.' if user_identifier.blank?
        raise FinApps::REST::MissingArgumentsError.new 'Invalid user_token.' if user_token.blank?

        @config[:user_credentials] = {identifier: user_identifier, token: user_token}
        @connection = faraday_connection(url:     config.versioned_url,
                                         request: {open_timeout: config.timeout, timeout: config.timeout},
                                         headers: {accept: HEADERS[:accept], user_agent: HEADERS[:user_agent]})
      end
    end
  end
end
