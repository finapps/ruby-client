# frozen_string_literal: true
module FinApps
  module REST
    class Consumers < FinAppsCore::REST::Resources # :nodoc:
      using ObjectExtensions
      using StringExtensions

      # @param [String] public_id
      # @return [FinApps::REST::User, Array<String>]
      def show(public_id)
        not_blank(public_id, :public_id)
        super public_id
      end

      # @param [Hash] params
      # @return [Array<String>]
      def update(public_id, params)
        not_blank(public_id, :public_id)
        not_blank(params, :params)

        path = "#{end_point}/#{ERB::Util.url_encode(public_id)}#{'/password' if password_update?(params)}"
        super params, path
      end

      def destroy(public_id)
        not_blank(public_id, :public_id)
        super public_id
      end

      private

      def password_update?(params)
        params.key?(:password) && params.key?(:password_confirm)
      end
    end
  end
end
