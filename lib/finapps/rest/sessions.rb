# frozen_string_literal: true

module FinApps
  module REST
    class Sessions < FinAppsCore::REST::Resources # :nodoc:
      LOGOUT = 'logout'
      # @param [Hash] params
      # @return [Array<String>]
      def create(params, path=nil)
        return super nil, path if path == LOGOUT
        raise FinAppsCore::InvalidArgumentsError.new 'Invalid argument: params.' unless validates params
        path ||= 'login'

        super params, path
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
