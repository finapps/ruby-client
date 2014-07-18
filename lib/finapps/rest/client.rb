module FinApps
  module REST
    class Client
      include FinApps::REST::Defaults
      include FinApps::Logging
      include FinApps::REST::Connection

      attr_reader :users, :institutions

      # @param [String] company_identifier
      # @param [String] company_token
      # @param [Hash] options
      # @return [FinApps::REST::Client]
      def initialize(company_identifier, company_token, options = {})
        logger.debug "##{__method__.to_s} => Started"

        @config = DEFAULTS.merge! options
        if @config[:logger_tag].present?
          Logging.tag= @config[:logger_tag]
          logger.info "##{__method__.to_s} => Added custom tag for logger."
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

      # Performs an HTTP GET request. You shouldn't need to use this method directly,
      # but it can be useful for debugging. Returns a hash obtained from parsing
      # the JSON object in the response body.
      #
      # @param [String] path
      # @param [Proc] proc
      # @return [Hash,Array<String>]
      def get(path, &proc)
        logger.debug "##{__method__.to_s} => Started"
        raise MissingArgumentsError.new 'Missing argument: path.' if path.blank?
        response, result, error_messages = nil, nil, nil

        begin
          logger.debug "##{__method__.to_s} => GET path:#{path}"
          response = @connection.get do |req|
            req.url path
          end
          if response.present? && block_given?
            result = proc.call(response)
            logger.debug "##{__method__.to_s} => parsed result: #{result.pretty_inspect}" if result.present?

          end
        rescue FinApps::REST::Error => error
          error_messages = error.error_messages
          logger.debug "##{__method__.to_s} => Failed, error_messages: #{error_messages.pretty_inspect}" if error_messages.present?
        end

        logger.debug "##{__method__.to_s} => Completed"
        return result, error_messages
      end

      # Performs an HTTP POST request. You shouldn't need to use this method directly,
      # but it can be useful for debugging. Returns a hash obtained from parsing
      # the JSON object in the response body.
      #
      # @param [String] path
      # @param [Hash] params
      # @param [Proc] proc
      # @return [Hash,Array<String>]
      def post(path, params = {}, &proc)
        logger.debug "##{__method__.to_s} => Started"
        raise MissingArgumentsError.new 'Missing argument: path.' if path.blank?
        response, result, error_messages = nil, nil, nil

        begin
          logger.debug "##{__method__.to_s} => POST path:#{path} params:#{skip_sensitive_data(params)}"
          response = @connection.post do |req|
            req.url path
            req.body = params
          end
          if response.present? && block_given?
            result = proc.call(response)
            logger.debug "##{__method__.to_s} => parsed result: #{result.pretty_inspect}" if result.present?
          end

        rescue FinApps::REST::Error => error
          error_messages = error.error_messages
          logger.debug "##{__method__.to_s} => Failed, error_messages: #{error_messages.pretty_inspect}" if error_messages.present?
        end

        logger.debug "##{__method__.to_s} => Completed"
        return result, error_messages
      end

      # Performs an HTTP DELETE request. You shouldn't need to use this method directly,
      # but it can be useful for debugging. Returns a hash obtained from parsing
      # the JSON object in the response body.
      #
      # @param [String] path
      # @param [Hash] params
      # @param [Proc] proc
      # @return [Hash,Array<String>]
      def delete(path, params = {}, &proc)
        logger.debug "##{__method__.to_s} => Started"
        raise MissingArgumentsError.new 'Missing argument: path.' if path.blank?
        response, result, error_messages = nil, nil, nil

        begin
          logger.debug "##{__method__.to_s} => DELETE path:#{path} params:#{skip_sensitive_data(params)}"
          response = @connection.delete do |req|
            req.url path
            req.body = params
          end
          if response.present? && block_given?
            result = proc.call(response)
            logger.debug "##{__method__.to_s} => parsed result: #{result.pretty_inspect}" if result.present?
          end

        rescue FinApps::REST::Error => error
          error_messages = error.error_messages
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

      def set_up_resources
        @users ||= FinApps::REST::Users.new self
        @institutions ||= FinApps::REST::Institutions.new self
      end

    end
  end
end
