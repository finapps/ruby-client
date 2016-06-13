module FinApps
  module REST
    class Client
      include FinApps::REST::Defaults
      include FinApps::Logging
      include FinApps::REST::Connection

      # @param [String] company_identifier
      # @param [String] company_token
      # @param [Hash] options
      # @return [FinApps::REST::Client]
      def initialize(company_identifier, company_token, options = {})
        logger.debug "##{__method__.to_s} => Started"

        @config = DEFAULTS.merge! options
        logger_config @config

        @company_credentials = {:company_identifier => company_identifier, :company_token => company_token}
        @company_credentials.validate_required_strings!

        logger.debug "##{__method__.to_s} => Completed"
      end

      def connection
        @connection ||= set_up_connection(@company_credentials, @config)
      end

      def users
        @users ||= FinApps::REST::Users.new self
      end

      def institutions
        @institutions ||= FinApps::REST::Institutions.new self
      end

      def user_institutions
        @user_institutions ||= FinApps::REST::UserInstitutions.new self
      end

      def transactions
        @transactions ||= FinApps::REST::Transactions.new self
      end

      def categories
        @categories ||= FinApps::REST::Categories.new self
      end

      def budget_models
        @budget_models ||= FinApps::REST::BudgetModels.new self
      end

      def budget_calculation
        @budget_calculation ||= FinApps::REST::BudgetCalculation.new self
      end

      def budgets
        @budgets ||= FinApps::REST::Budgets.new self
      end

      def cashflows
        @cashflows ||= FinApps::REST::Cashflows.new self
      end

      def alert
        @alert ||= FinApps::REST::Alert.new self
      end

      def alert_definition
        @alert_definition ||= FinApps::REST::AlertDefinition.new self
      end

      def alert_settings
        @alert_settings ||= FinApps::REST::AlertSettings.new self
      end

      def alert_preferences
        @alert_preferences ||= FinApps::REST::AlertPreferences.new self
      end

      def rule_sets
        @rule_sets ||= FinApps::REST::Relevance::Rulesets.new self
      end

      # Performs HTTP GET, POST, UPDATE and DELETE requests.
      # You shouldn't need to use this method directly, but it can be useful for debugging.
      # Returns a hash obtained from parsing the JSON object in the response body.
      #
      # @param [String] path
      # @param [String] method
      # @param [Proc] proc
      # @return [Hash,Array<String>]
      def send_request(path, method, params = {}, &proc)
        logger.debug "##{__method__.to_s} => Started"

        raise FinApps::REST::MissingArgumentsError.new 'Missing argument: path.' if path.blank?
        raise FinApps::REST::MissingArgumentsError.new 'Missing argument: method.' if method.blank?

        result, error_messages = nil, []

        begin
          case method
            when :get
              response = get(path)
            when :post
              response = post(path, params)
            when :put
              response = put(path, params)
            when :delete
              response = delete(path, params)
            else
              raise FinApps::REST::InvalidArgumentsError.new "Method not supported: #{method}."
          end

          if response.present?
            result = block_given? ? proc.call(response) : response.body
          else
            logger.error "##{__method__.to_s} => Null response found. Unable to process it."
          end

        rescue FinApps::REST::InvalidArgumentsError => error
          raise error
        rescue FinApps::REST::Error => error
          error_messages = error.error_messages
        rescue Faraday::ParsingError => error
          error_messages << 'Unable to parse the server response.'
          logger.error "##{__method__.to_s} => Faraday::ParsingError, #{error.to_s}"
        rescue Exception => error
          error_messages << 'Unexpected error.'
          logger.fatal "##{__method__.to_s} => Exception, #{error.to_s}"
          logger.fatal error
        ensure
          logger.debug "##{__method__.to_s} => Failed, error_messages: #{error_messages.pretty_inspect}" if error_messages.present?
        end

        logger.debug "##{__method__.to_s} => Completed"
        return result, error_messages
      end

      # @param [String] user_identifier
      # @param [String] user_token
      def user_credentials!(user_identifier, user_token)
        logger.debug "##{__method__.to_s} => Started"

        {:user_identifier => user_identifier, :user_token => user_token}.validate_required_strings!
        logger.debug "##{__method__.to_s} => Credentials passed validation. Attempting to set user credentials on current connection."

        @config[:user_identifier] = user_identifier
        @config[:user_token] = user_token
        @connection = set_up_connection(@company_credentials, @config)

        logger.debug "##{__method__.to_s} => Completed"
      end

      private

      # Performs an HTTP GET request.
      # Returns a hash obtained from parsing
      # the JSON object in the response body.
      #
      # @param [String] path
      # @return [Hash,Array<String>]
      def get(path)
        logger.debug "##{__method__.to_s} => Started"
        raise MissingArgumentsError.new 'Missing argument: path.' if path.blank?

        logger.debug "##{__method__.to_s} => GET path:#{path}"
        response = connection.get do |req|
          req.url path
        end

        logger.debug "##{__method__.to_s} => Completed"
        response
      end

      # Performs an HTTP POST request.
      # Returns a hash obtained from parsing
      # the JSON object in the response body.
      #
      # @param [String] path
      # @param [Hash] params
      # @return [Hash,Array<String>]
      def post(path, params = {})
        logger.debug "##{__method__.to_s} => Started"
        raise MissingArgumentsError.new 'Missing argument: path.' if path.blank?

        logger.debug "##{__method__.to_s} => POST path:#{path} params:#{skip_sensitive_data params }"
        response = connection.post do |req|
          req.url path
          req.body = params
        end

        logger.debug "##{__method__.to_s} => Completed"
        response
      end

      # Performs an HTTP PUT request.
      # Returns a hash obtained from parsing
      # the JSON object in the response body.
      #
      # @param [String] path
      # @param [Hash] params
      # @return [Hash,Array<String>]
      def put(path, params = {})
        logger.debug "##{__method__.to_s} => Started"
        raise MissingArgumentsError.new 'Missing argument: path.' if path.blank?

        logger.debug "##{__method__.to_s} => PUT path:#{path} params:#{skip_sensitive_data(params)}"
        response = connection.put do |req|
          req.url path
          req.body = params
        end

        logger.debug "##{__method__.to_s} => Completed"
        response
      end

      # Performs an HTTP DELETE request.
      # Returns a hash obtained from parsing
      # the JSON object in the response body.
      #
      # @param [String] path
      # @param [Hash] params
      # @return [Hash,Array<String>]
      def delete(path, params = {})
        logger.debug "##{__method__.to_s} => Started"
        raise MissingArgumentsError.new 'Missing argument: path.' if path.blank?

        logger.debug "##{__method__.to_s} => DELETE path:#{path} params:#{skip_sensitive_data(params)}"
        response = connection.delete do |req|
          req.url path
          req.body = params
        end

        logger.debug "##{__method__.to_s} => Completed"
        response
      end

    end
  end
end
