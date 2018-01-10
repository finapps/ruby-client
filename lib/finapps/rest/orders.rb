# frozen_string_literal: true
require 'json'
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
        super build_query_path(end_point, set_filter(params))
      end

      def update(id, params, path=nil)
        return super nil, path if path
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
        update nil, nil, path
      end

      private

      def set_filter(params)
        params[:filter] = build_filter(params)
        params
      end

      def build_filter(params)
        filter = {}
        filter.merge!(search_query(params[:searchTerm])) if params[:searchTerm]
        filter.merge!(status_query(params[:status])) if params[:status]
        filter.merge!(assignment_query(params[:assignment])) if params.key?(:assignment) # assignment can be nil
        filter
      end

      def search_query(term)
        {
            "$or": [{
                        "public_id": {
                            "$regex": "^#{term}",
                            "$options": "i"
                        }
                    }, {
                        "applicant.last_name": {
                            "$regex": term,
                            "$options": "i"
                        }
                    }, {
                        "assignment.last_name": {
                            "$regex": term,
                            "$options": "i"
                        }
                    }, {
                        "requestor.reference_no": {
                            "$regex": "^#{term}",
                            "$options": "i"
                        }
                    }]
        }
      end

      def status_query(status)
        status.is_a?(Array) ? {"status": {"$in": status.map(&:to_i)}} : {"status": status.to_i}
      end

      def assignment_query(assignment)
        {"assignment.operator_id": assignment}
      end
    end
  end
end
