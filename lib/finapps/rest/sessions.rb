# frozen_string_literal: true

module FinApps
  module REST
    class Sessions < FinAppsCore::REST::Resources # :nodoc:
      CONSUMER_LOGIN = 'login'
      LOGOUT = 'logout'

      def create(params, path = nil)
        return super nil, path if path == LOGOUT
        fail FinAppsCore::InvalidArgumentsError, 'Invalid argument: params.' unless validates params

        path ||= CONSUMER_LOGIN

        begin
          super params, path
        rescue FinAppsCore::ApiUnauthenticatedError
          (
            [
              nil,
              [
                "Invalid #{path == CONSUMER_LOGIN ? 'Consumer' : 'Operator'} Identifier or Credentials"
              ]
            ]
          )
        end
      end

      def destroy
        create nil, LOGOUT
      end

      private

      def validates(params)
        params.key?(:email) && params[:email] && params.key?(:password) &&
          params[:password]
      end
    end
  end
end
