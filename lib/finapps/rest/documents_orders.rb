# frozen_string_literal: true

require_relative '../utils/query_builder'

module FinApps
  module REST
    class DocumentsOrders < FinAppsCore::REST::Resources
      include FinApps::Utils::QueryBuilder

      def list(params = nil)
        path = 'documents/orders'
        return super(path) if params.nil?
        raise FinAppsCore::InvalidArgumentsError, 'Invalid argument: params' unless params.is_a? Hash

        super build_query_path(path, params)
      end

      def show(id)
        not_blank(id, :order_id)
        super(id, "documents/orders/#{id}")
      end

      def create(params)
        not_blank(params, :params)
        super(params, 'documents/orders')
      end

      def update(id, params = nil)
        not_blank(id, :order_id)
        not_blank(params, :params)

        super(params, "documents/orders/#{id}")
      end

      def destroy(id)
        not_blank(id, :order_id)
        super(id, "documents/orders/#{id}")
      end

      private

      def build_filter(params)
        search_query(params[:searchTerm]).merge(consumer_query(params[:consumer])).merge(tag_query(params[:tag]))
      end

      def search_query(term)
        if term
          {
            "$or": [
              { "order_id": { "$regex": "^#{term}", "$options": 'i' } },
              { "applicant.last_name": term },
              {
                "reference_no": {
                  "$regex": "^#{term}", "$options": 'i'
                }
              }
            ]
          }
        else
          {}
        end
      end

      def tag_query(tag)
        if tag
          { "tag": tag }
        else
          {}
        end
      end

      def consumer_query(consumer)
        if consumer
          { "consumer_id": consumer.empty? ? nil : consumer }
        else
          {}
        end
      end
    end
  end
end
