# frozen_string_literal: true
using ObjectExtensions
using StringExtensions

module FinApps
  module REST
    class Sessions < FinAppsCore::REST::Resources # :nodoc:
      # @param [Hash] params
      # @return [Array<String>]
      def create(params)
        raise FinAppsCore::InvalidArgumentsError.new 'Invalid argument: params.' unless validates params

        super params, 'login'
      end

      private

      def validates(params)
        params.key?(:email) && params[:email].present? && params.key?(:password) && params[:password].present?
      end
    end
  end
end
