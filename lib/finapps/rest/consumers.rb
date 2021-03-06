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
        fail FinAppsCore::InvalidArgumentsError, 'Invalid argument: params' unless params.is_a? Hash

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
        return {} unless params[:searchTerm]

        search_query(params[:searchTerm])
      end

      def search_query(term)
        query = with_space_search(term).concat(name_search(term))
        {
          '$or': query
        }
      end

      def with_space_search(term)
        [
          {external_id: term},
          {email: term},
          {first_name: term},
          {last_name: term}
        ]
      end

      def name_search(term)
        search_arr = []
        if /\s/.match?(term)
          term.split.each do |t|
            search_arr.append(first_name: t)
            search_arr.append(last_name: t)
          end
        end
        search_arr
      end
    end
  end
end
