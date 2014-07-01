require File.expand_path(File.dirname(__FILE__) + '/error_messages.rb')
module FinApps
  module REST

    class Users
      include ErrorMessages

      # @param [FinApps::REST::Client] client
      # @return [FinApps::REST::Users]
      def initialize(client)
        @client = client
      end

      # @param [Hash] params
      # @return [FinApps::REST::User]
      def create(params = {})
        raise "Can't create a resource without a REST Client" unless @client

        begin
          response = @client.post 'users/new', params
          parse_to_user(response)
        rescue StandardError => error
          User.new nil, nil, parse_to_error_messages(error)
        end

      end

      # @param [Hash] params
      # @return [FinApps::REST::User]
      def login(params = {})
        raise "Can't login without a REST Client" unless @client

        begin
          response = @client.post 'users/login', params
          parse_to_user(response)
        rescue StandardError => error
          User.new nil, nil, parse_to_error_messages(error)
        end
      end

      private
      def parse_to_user(response)
        if response.respond_to? :body
          rashie = response.body
          user = User.new(rashie.public_id, rashie.token)
          user.email = rashie.email if rashie.respond_to? :email
          user.first_name = rashie.first_name if rashie.respond_to? :first_name
          user.last_name = rashie.last_name if rashie.respond_to? :last_name
          user.postal_code = rashie.postal_code if rashie.respond_to? :postal_code
          user
        end
      end

    end

    class User < Base
      attr_accessor :email, :first_name, :last_name, :postal_code
      attr_reader :public_id, :token

      def initialize(public_id=nil, token=nil, error_messages=nil)
        @public_id = public_id
        @token = token
        super(error_messages)
      end
    end

  end
end