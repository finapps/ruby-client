module FinApps
  module REST
    class Client
      include FinApps::REST::Defaults
      include FinApps::Logging
      include FinApps::REST::Connection

      attr_reader :connection, :users, :institutions, :user_institutions, :accounts, :transactions, :categories, :rule_sets

      # @param [String] company_identifier
      # @param [String] company_token
      # @param [Hash] options
      # @return [FinApps::REST::Client]
      def initialize(company_identifier, company_token, options = {})
        logger.debug "##{__method__.to_s} => Started"

        @config = DEFAULTS.merge! options
        if @config[:logger_tag].present?
          Logging.tag= @config[:logger_tag]
          logger.info "##{__method__.to_s} => Custom tag for logs: #{@config[:logger_tag]}"
        end

        set_up_logger_level @config[:log_level]
        logger.info "##{__method__.to_s} => Current logger level: #{SEVERITY_LABEL[logger.level]}"

        @company_credentials = {:company_identifier => company_identifier,
                                :company_token => company_token}
        @connection = set_up_connection(@company_credentials, @config)
        logger.debug "##{__method__.to_s} => Connection initialized"

        set_up_resources
        logger.debug "##{__method__.to_s} => All resources initialized"

        logger.debug "##{__method__.to_s} => Completed"
      end

      # Performs HTTP GET, POST, UPDATE and DELETE requests.
      # You shouldn't need to use this method directly, but it can be useful for debugging.
      # Returns a hash obtained from parsing the JSON object in the response body.
      #
      # @param [String] path
      # @param [String] method
      # @param [Proc] proc
      # @return [Hash,Array<String>]
      def send(path, method, params = {}, &proc)
        logger.debug "##{__method__.to_s} => Started"
        raise MissingArgumentsError.new 'Missing argument: method.' if method.blank?
        result, error_messages = nil, nil

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
              raise StandardError "Method not supported: #{method}."
          end

          if response.present?
            result = block_given? ? proc.call(response) : response.body
            logger.debug "##{__method__.to_s} => parsed result: #{result.pretty_inspect}"
          else
            logger.error "##{__method__.to_s} => Null response found. Unable to process it."
          end


        rescue FinApps::REST::Error => error
          error_messages = error.error_messages
        rescue Faraday::ParsingError => error
          error_messages = []
          error_messages << 'Unable to parse the server response.'
          logger.error "##{__method__.to_s} => Faraday::ParsingError, #{error.to_s}"
        rescue Exception => error
          error_messages = []
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
        response = @connection.get do |req|
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

        logger.debug "##{__method__.to_s} => POST path:#{path} params:#{skip_sensitive_data(params)}"
        response = @connection.post do |req|
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
        response = @connection.put do |req|
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
        response = @connection.delete do |req|
          req.url path
          req.body = params
        end

        logger.debug "##{__method__.to_s} => Completed"
        response
      end

      def set_up_resources
        @users ||= FinApps::REST::Users.new self
        @institutions ||= FinApps::REST::Institutions.new self
        @user_institutions ||= FinApps::REST::UserInstitutions.new self
        @transactions ||= FinApps::REST::Transactions.new self
        @categories ||= FinApps::REST::Categories.new self
        @rule_sets ||= FinApps::REST::Relevance::Rulesets.new self
      end

    end
  end
end
