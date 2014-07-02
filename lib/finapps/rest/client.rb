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

        config = DEFAULTS.merge! options
        logger.info "FinApps::REST::Client#initialize => updating log_level from #{logger.level} to #{config[:log_level]}"
        logger.level = config[:log_level]

        @connection = set_up_connection({:company_identifier => company_identifier.trim,
                                         :company_token => company_token.trim,
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

        logger.debug 'FinApps::REST::Client#post => Completed'
        return response, error_messages
      end

      private

      def set_up_resources
        @users ||= FinApps::REST::Users.new self
      end

    end
  end
end
