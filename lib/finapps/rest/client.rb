module FinApps
  module REST
    class Client
      include FinApps::REST::Defaults
      include FinApps::Logging
      include FinApps::REST::Connection

      attr_reader :users

      # @param [String] company_identifier
      # @param [String] company_token
      # @param [Hash] options
      # @return [FinApps::REST::Client]
      def initialize(company_identifier, company_token, options = {})
        logger.debug 'FinApps::REST::Client#initialize => Started'

        config = DEFAULTS.merge! options

        set_up_logger_level config[:log_level]

        @connection = set_up_connection({:company_identifier => company_identifier,
                                         :company_token => company_token,
                                         :config => config})
        set_up_resources

        logger.debug 'FinApps::REST::Client#initialize => Completed'
      end

      # Performs an HTTP GET request
      #
      # @param [String] path
      def get(path)
        logger.debug 'FinApps::REST::Client#post => Started'
        response, error_messages = nil, nil
        begin
          logger.debug "FinApps::REST::Client#get => GET path:#{path}"
          response = @connection.get do |req|
            req.url path
          end
        rescue FinApps::REST::Error => error
          error_messages = error.error_messages
        end

        logger.debug "FinApps::REST::Client#get => response: #{response.pretty_inspect}" if response.present?
        logger.debug "FinApps::REST::Client#get => error_messages: #{error_messages.pretty_inspect}" if error_messages.present?

        logger.debug 'FinApps::REST::Client#get => Completed'
        return response, error_messages
      end

      # Performs an HTTP POST request
      #
      # @param [String] path
      # @param [Hash] params
      # @return [Faraday::Response,Array]
      def post(path, params = {})
        logger.debug 'FinApps::REST::Client#post => Started'
        response, error_messages = nil, nil

        begin
          logger.debug "FinApps::REST::Client#post => POST path:#{path} params:#{params.reject { |k, _| PROTECTED_KEYS.include? k }}"
          response = @connection.post do |req|
            req.url path
            req.body = params
          end
        rescue FinApps::REST::Error => error
          error_messages = error.error_messages
        end

        logger.debug "FinApps::REST::Client#post => response: #{response.pretty_inspect}" if response.present?
        logger.debug "FinApps::REST::Client#post => error_messages: #{error_messages.pretty_inspect}" if error_messages.present?

        logger.debug 'FinApps::REST::Client#post => Completed'
        return response, error_messages
      end

      private

      def set_up_resources
        logger.debug 'FinApps::REST::Client#set_up_resources => Started'
        @users ||= FinApps::REST::Users.new self
        logger.debug 'FinApps::REST::Client#set_up_resources => Completed'
      end

    end
  end
end
