# frozen_string_literal: true
require_relative '../utils/query_builder'

module FinApps
  module REST
    class Orders < FinAppsCore::REST::Resources # :nodoc:
      include FinApps::Utils::QueryBuilder

      def show(id)
        not_blank(id, :id)
        super
      end

      def create(params)
        not_blank(params, :params)
        super params
      end

      # GET /v2/list/orders?page=1&requested=25&sort=-date
      # :page - page number requested
      # :requested - number of results per page requested
      # :sort - sort order
      # :filter - mongo object to filter
      #     descending - append "-" before option for descending sort
      def list(params=nil) # params hash with optional keys [:page, :sort, :requested]
        return super if params.nil?
        raise FinAppsCore::InvalidArgumentsError.new 'Invalid argument: params' unless params.is_a? Hash
        super build_query_path(end_point, params)
      end

      def update(id, params)
        not_blank(id, :id)
        not_blank(params, :params)
        # Params array need matching Institution ids & Account ids
        # Validations to check each Institution id has at least one account id
        # Validations to check at least 1 Institution id or 1 account "params.length >= 1"

        path = "#{end_point}/#{ERB::Util.url_encode(id)}"

        super params, path
      end

      def destroy(id)
        not_blank(id, :id)

        path = "#{end_point}/#{ERB::Util.url_encode(id)}/cancel"
        update nil, path
      end
    end
  end
end
