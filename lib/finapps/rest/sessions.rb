# frozen_string_literal: true

module FinApps
  module REST
    class Sessions < FinAppsCore::REST::Resources # :nodoc:
      LOGOUT = 'logout'

      def create(params, path = nil)
        return super nil, path if path == LOGOUT
        raise FinAppsCore::InvalidArgumentsError, 'Invalid argument: params.' unless validates params

        path ||= 'login'

        begin
          super params, path
        rescue FinAppsCore::ApiUnauthenticatedError
          return [nil, ['Invalid User Identifier or Credentials']]
        end
      end

      def destroy
        create nil, LOGOUT
      end

      private

      def validates(params)
        params.key?(:email) && params[:email] && params.key?(:password) && params[:password]
      end
    end
  end
end
