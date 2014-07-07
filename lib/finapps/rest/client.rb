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
        logger.debug 'FinApps::REST::Client#initialize => Started'

        @config = DEFAULTS.merge! options

        set_up_logger_level @config[:log_level]

        @company_credentials = {:company_identifier => company_identifier, :company_token => company_token}
        @connection = set_up_connection(@company_credentials, @config)
        logger.debug 'FinApps::REST::Client#initialize => Connection object initialized'

        set_up_resources
        logger.debug 'FinApps::REST::Client#initialize => Resource objects initialized'

        logger.debug 'FinApps::REST::Client#initialize => Completed'
      end

      # Performs an HTTP GET request. You shouldn't need to use this method directly,
      # but it can be useful for debugging. Returns a hash obtained from parsing
      # the JSON object in the response body.
      #
      # @param [String] path
      # @param [Proc] proc
      # @return [Hash,Array<String>]
      def get(path, &proc)
        logger.debug 'FinApps::REST::Client#post => Started'

        response, result, error_messages = nil, nil, nil

        begin
          logger.debug "FinApps::REST::Client#get => GET path:#{path}"
          response = @connection.get do |req|
            req.url path
          end
          if response.present?
            logger.debug "FinApps::REST::Client#post => response: #{response.pretty_inspect}"
            if block_given?
              result = proc.call(response)
              logger.debug "FinApps::REST::Client#post => result: #{result.pretty_inspect}" if result.present?
            end
          end
        rescue FinApps::REST::Error => error
          error_messages = error.error_messages
          logger.debug "FinApps::REST::Client#get => error_messages: #{error_messages.pretty_inspect}" if error_messages.present?
        end

        logger.debug 'FinApps::REST::Client#get => Completed'
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
        logger.debug 'FinApps::REST::Client#post => Started'

        response, result, error_messages = nil, nil, nil

        begin
          logger.debug "FinApps::REST::Client#post => POST path:#{path} params:#{params.reject { |k, _| PROTECTED_KEYS.include? k }}"
          response = @connection.post do |req|
            req.url path
            req.body = params
          end
          if response.present?
            logger.debug "FinApps::REST::Client#post => response: #{response.pretty_inspect}"
            if block_given?
              result = proc.call(response)
              logger.debug "FinApps::REST::Client#post => result: #{result.pretty_inspect}" if result.present?
            end
          end

        rescue FinApps::REST::Error => error
          error_messages = error.error_messages
          logger.debug "FinApps::REST::Client#post => error_messages: #{error_messages.pretty_inspect}" if error_messages.present?
        end

        logger.debug 'FinApps::REST::Client#post => Completed'
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
        logger.debug 'FinApps::REST::Client#delete => Started'

        response, result, error_messages = nil, nil, nil

        begin
          logger.debug "FinApps::REST::Client#delete => POST path:#{path} params:#{params.reject { |k, _| PROTECTED_KEYS.include? k }}"
          response = @connection.delete do |req|
            req.url path
            req.body = params
          end
          if response.present?
            logger.debug "FinApps::REST::Client#delete => response: #{response.pretty_inspect}"
            if block_given?
              result = proc.call(response)
              logger.debug "FinApps::REST::Client#delete => result: #{result.pretty_inspect}" if result.present?
            end
          end

        rescue FinApps::REST::Error => error
          error_messages = error.error_messages
          logger.debug "FinApps::REST::Client#delete => error_messages: #{error_messages.pretty_inspect}" if error_messages.present?
        end

        logger.debug 'FinApps::REST::Client#delete => Completed'
        return result, error_messages
      end

      # @param [String] user_identifier
      # @param [String] user_token
      def user_credentials!(user_identifier, user_token)
        logger.debug 'FinApps::REST::Client#user_credentials! => Started'

        {:user_identifier => user_identifier, :user_token => user_token}.validate_required_strings!
        logger.debug 'FinApps::REST::Client#user_credentials! => credentials format validated'

        @config[:user_identifier] = user_identifier
        @config[:user_token] = user_token
        @connection = set_up_connection(@company_credentials, @config)

        logger.debug 'FinApps::REST::Client#user_credentials! => Completed'
      end

      private

      def set_up_resources
        @users ||= FinApps::REST::Users.new self
        @institutions ||= FinApps::REST::Institutions.new self
      end

    end
  end
end
