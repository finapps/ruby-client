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

      # GET /v3/list/orders?page=1&requested=25&sort=-date
      # @param [Hash] params
      # Optional keys:
      # :page - page number requested
      # :requested - number of results per page requested
      # :sort - sort order
      # :filter - mongo object to filter
      #     descending - append "-" before option for descending sort
      #
      def list(params = nil)
        return super if params.nil?
        raise FinAppsCore::InvalidArgumentsError, 'Invalid argument: params' unless params.is_a? Hash

        super build_query_path(end_point, params)
      end

      def update(id, params = nil)
        return super params if params # create&submit

        not_blank(id, :id)
        path = "#{end_point}/#{ERB::Util.url_encode(id)}"

        super nil, path # submit
      end

      def destroy(id)
        not_blank(id, :id)
        path = "#{end_point}/#{ERB::Util.url_encode(id)}/cancel"

        send_request path, :put
      end

      private

      def build_filter(params)
        filter = {}
        filter.merge!(search_query(params[:searchTerm])) if params[:searchTerm]
        filter.merge!(status_query(params[:status])) if params[:status]
        filter.merge!(assignment_query(params[:assignment])) if params[:assignment] # assignment can be ""
        filter.merge!(relation_query(params[:relation])) if !params[:searchTerm] && !nil_or_empty?(params[:relation])
        filter
      end

      def search_query(term)
        {
          "$or": [
            { "public_id": { "$regex": "^#{term}", "$options": 'i' } },
            { "applicant.last_name": term },
            { "assignment.last_name": term },
            {
              "requestor.reference_no": {
                "$regex": "^#{term}", "$options": 'i'
              }
            }
          ]
        }
      end

      def status_query(status)
        if status.is_a?(Array)
          { "status": { "$in": status.map(&:to_i) } }
        else
          { "status": status.to_i }
        end
      end

      def assignment_query(assignment)
        { "assignment.operator_id": assignment.empty? ? nil : assignment } # translate "" to null assignment
      end

      def relation_query(relation)
        {
          "$or": [
            { "public_id": { "$in": relation } },
            { "original_order_id": { "$in": relation } }
          ]
        }
      end
    end
  end
end
