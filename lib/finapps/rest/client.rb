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

        set_up_logger_level @config[:log_level]

        @company_credentials = {:company_identifier => company_identifier,
                                :company_token => company_token}
        @connection = set_up_connection(@company_credentials, @config)
<<<<<<< HEAD
        logger.debug "##{__method__.to_s} => Connection initialized"

        set_up_resources
        logger.debug "##{__method__.to_s} => All resources initialized"
=======
        logger.debug "##{__method__.to_s} => Connection object initialized"

        set_up_resources
        logger.debug "##{__method__.to_s} => Resource objects initialized"
>>>>>>> c8eb56c73da0329b3834b9f7f3c985dfbb503a0b

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

        response, result, error_messages = nil, nil, nil

        begin
          logger.debug "##{__method__.to_s} => GET path:#{path}"
<<<<<<< HEAD
          response = @connection.get { |req| req.url path }
          if response.present? && block_given?
            result = proc.call(response)
            logger.debug "##{__method__.to_s} => parsed result: #{result.pretty_inspect}" if result.present?
=======
          response = @connection.get do |req|
            req.url path
          end
          if response.present?
            logger.debug "##{__method__.to_s} => response received"
            # logger.debug "##{__method__.to_s} => response: #{response.pretty_inspect}"
            if block_given?
              result = proc.call(response)
              logger.debug "##{__method__.to_s} => parsed result: #{result.pretty_inspect}" if result.present?
            end
>>>>>>> c8eb56c73da0329b3834b9f7f3c985dfbb503a0b
          end

        rescue FinApps::REST::Error => error
          error_messages = error.error_messages
<<<<<<< HEAD
          logger.debug "##{__method__.to_s} => error_messages: #{error_messages.pretty_inspect}" if error_messages.present?
=======
          logger.debug "##{__method__.to_s} => Failed, error_messages: #{error_messages.pretty_inspect}" if error_messages.present?
>>>>>>> c8eb56c73da0329b3834b9f7f3c985dfbb503a0b
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

        response, result, error_messages = nil, nil, nil

        begin
<<<<<<< HEAD
          logger.debug "##{__method__.to_s} => POST path:#{path} params:#{skip_sensitive_data(params)}"
=======
          logger.debug "##{__method__.to_s} => POST path:#{path} params:#{params.reject { |k, _| PROTECTED_KEYS.include? k }}"
>>>>>>> c8eb56c73da0329b3834b9f7f3c985dfbb503a0b
          response = @connection.post do |req|
            req.url path
            req.body = params
          end
<<<<<<< HEAD
          if response.present? && block_given?
            result = proc.call(response)
            logger.debug "##{__method__.to_s} => parsed result: #{result.pretty_inspect}" if result.present?
=======
          if response.present?
            logger.debug "##{__method__.to_s} => response received"
            # logger.debug "##{__method__.to_s} => response: #{response.pretty_inspect}"
            if block_given?
              result = proc.call(response)
              logger.debug "##{__method__.to_s} => parsed result: #{result.pretty_inspect}" if result.present?
            end
>>>>>>> c8eb56c73da0329b3834b9f7f3c985dfbb503a0b
          end

        rescue FinApps::REST::Error => error
          error_messages = error.error_messages
<<<<<<< HEAD
          logger.debug "##{__method__.to_s} => error_messages: #{error_messages.pretty_inspect}" if error_messages.present?
=======
          logger.debug "##{__method__.to_s} => Failed, error_messages: #{error_messages.pretty_inspect}" if error_messages.present?
>>>>>>> c8eb56c73da0329b3834b9f7f3c985dfbb503a0b
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

        response, result, error_messages = nil, nil, nil

        begin
<<<<<<< HEAD
          logger.debug "##{__method__.to_s} => DELETE path:#{path} params:#{skip_sensitive_data(params)}"
=======
          logger.debug "##{__method__.to_s} => POST path:#{path} params:#{params.reject { |k, _| PROTECTED_KEYS.include? k }}"
>>>>>>> c8eb56c73da0329b3834b9f7f3c985dfbb503a0b
          response = @connection.delete do |req|
            req.url path
            req.body = params
          end
<<<<<<< HEAD
          if response.present? && block_given?
            result = proc.call(response)
            logger.debug "##{__method__.to_s} => parsed result: #{result.pretty_inspect}" if result.present?
=======
          if response.present?
            logger.debug "##{__method__.to_s} => response: #{response.pretty_inspect}"
            if block_given?
              result = proc.call(response)
              logger.debug "##{__method__.to_s} => result: #{result.pretty_inspect}" if result.present?
            end
>>>>>>> c8eb56c73da0329b3834b9f7f3c985dfbb503a0b
          end

        rescue FinApps::REST::Error => error
          error_messages = error.error_messages
<<<<<<< HEAD
          logger.debug "##{__method__.to_s} => error_messages: #{error_messages.pretty_inspect}" if error_messages.present?
=======
          logger.debug "##{__method__.to_s} => Failed, error_messages: #{error_messages.pretty_inspect}" if error_messages.present?
>>>>>>> c8eb56c73da0329b3834b9f7f3c985dfbb503a0b
        end

        logger.debug "##{__method__.to_s} => Completed"
        return result, error_messages
      end

      # @param [String] user_identifier
      # @param [String] user_token
      def user_credentials!(user_identifier, user_token)
        logger.debug "##{__method__.to_s} => Started"

        {:user_identifier => user_identifier, :user_token => user_token}.validate_required_strings!
<<<<<<< HEAD
        llogger.debug "##{__method__.to_s} => Credentials passed validation. Attempting to set user credentials on current connection."
=======
        logger.debug "##{__method__.to_s} => Credentials format validated. Attempting to set user credentials on current connection."
>>>>>>> c8eb56c73da0329b3834b9f7f3c985dfbb503a0b

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
