# frozen_string_literal: true

require_relative '../utils/query_builder'

module FinApps
  module REST
    class Consumers < FinAppsCore::REST::Resources # :nodoc:
      include FinApps::Utils::QueryBuilder
      # @param [String] public_id
      # @return [FinApps::REST::User, Array<String>]
      def create(params)
        not_blank(params, :params)
        super params
      end

      def list(params = nil)
        return super if params.nil?
        raise FinAppsCore::InvalidArgumentsError, 'Invalid argument: params' unless params.is_a? Hash

        super build_query_path(end_point, params)
      end

      def show(public_id)
        not_blank(public_id, :public_id)
        super public_id
      end

      # @param [Hash] params
      # @return [Array<String>]
      def update(public_id, params)
        not_blank(public_id, :public_id)
        not_blank(params, :params)

        path =
          "#{end_point}/#{ERB::Util.url_encode(public_id)}#{'/password' if password_update?(params)}"
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

      def build_filter(params)
        search_query(params[:searchTerm]) if params[:searchTerm]
      end

      def search_query(term)
        {
          "$or": [
            { "email": term },
            { "first_name": term },
            { "last_name": term }
          ]
        }
      end
    end
  end
end
