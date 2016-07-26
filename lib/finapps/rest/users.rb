# frozen_string_literal: true
module FinApps
  module REST
    class Users < FinApps::REST::Resources # :nodoc:
      require 'erb'

      using ObjectExtensions
      using StringExtensions

      # @param [String] public_id
      # @return [FinApps::REST::User, Array<String>]
      def show(public_id)
        raise MissingArgumentsError.new 'Missing argument: public_id.' if public_id.blank?
        super public_id
      end

      # @param [Hash] params
      # @return [Array<String>]
      def update(public_id, params)
        raise MissingArgumentsError.new 'Missing argument: public_id.' if public_id.blank?
        raise MissingArgumentsError.new 'Missing argument: params.' if params.blank?

        path = "#{end_point}/#{ERB::Util.url_encode(public_id)}#{'/password' if password_update?(params)}"
        super params, path
      end

      private

      def password_update?(params)
        params.key?(:password) && params.key?(:password_confirm)
      end
    end
  end
end
