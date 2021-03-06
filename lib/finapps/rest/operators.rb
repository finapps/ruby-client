# frozen_string_literal: true

require_relative '../utils/query_builder'

module FinApps
  module REST
    class Operators < FinAppsCore::REST::Resources
      include FinApps::Utils::QueryBuilder

      def list(params = nil)
        return super if params.nil?
        fail FinAppsCore::InvalidArgumentsError, 'Invalid argument: params' unless params.is_a? Hash

        super build_query_path(end_point, params)
      end

      def show(id)
        not_blank(id, :operator_id)

        super id
      end

      def create(params, path = nil)
        not_blank(params, :params)
        super params, path
      end

      def update(id, params)
        not_blank(id, :operator_id)
        not_blank(params, :params)

        path = "#{end_point}/#{ERB::Util.url_encode(id)}"
        super params, path
      end

      def update_password(params)
        # update password for current operator, need authorization session in header
        not_blank(params, :params)
        fail FinAppsCore::InvalidArgumentsError, 'Invalid argument: params.' unless validates params

        path = "#{end_point}/password/change"

        create params, path
      end

      def destroy(id)
        not_blank(id, :operator_id)
        super id
      end

      private

      def validates(params)
        params.key?(:password) && params[:password] &&
          params.key?(:password_confirm) &&
          params[:password_confirm]
      end

      def build_filter(params)
        filter = {}
        filter.merge!(search_query(params[:searchTerm])) if params[:searchTerm]
        filter.merge!(role_query(params[:role])) if params[:role]
        filter
      end

      def search_query(term)
        {last_name: term}
      end

      def role_query(role)
        if role.is_a?(Array)
          {role: {'$in': role.map(&:to_i)}}
        else
          {role: role.to_i}
        end
      end
    end
  end
end
