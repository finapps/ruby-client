# frozen_string_literal: true

module FinApps
  module REST
    class Sessions < FinAppsCore::REST::Resources # :nodoc:
      # @param [Hash] params
      # @return [Array<String>]
      def create(params, path=nil)
        raise FinAppsCore::InvalidArgumentsError.new 'Invalid argument: params.' unless validates params
        path ||= 'login'

        super params, path
      end

      private

      def validates(params)
        params.key?(:email) && params[:email] && params.key?(:password) && params[:password]
      end
    end
  end
end
