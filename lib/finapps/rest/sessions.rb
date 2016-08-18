# frozen_string_literal: true
module FinApps
  module REST
    class Sessions < FinApps::REST::Resources # :nodoc:

      using ObjectExtensions
      using StringExtensions

      # @param [Hash] params
      # @return [Array<String>]
      def create(params)
        raise InvalidArgumentsError.new 'Invalid argument: params.' unless validates params

        super params, 'login'
      end

      private

      def validates(params)
        params.key?(:email) && params[:email].present? && params.key?(:password) && params[:password].present?
      end
    end
  end
end
