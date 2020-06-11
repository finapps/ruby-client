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

      def show_signing_url(order_id, signature_id)
        not_blank(order_id, :order_id)
        not_blank(signature_id, :signature_id)
        path = "documents/orders/#{order_id}/sign_url/#{signature_id}"
        send_request path, :get
      end

      private

      def build_filter(params)
        search_query(params[:searchTerm]).merge(consumer_query(params[:consumer])).merge(tag_query(params[:tag]))
      end

      def search_query(term)
        if term
          query = email_search(term).concat(name_search(term)).concat(reference_no_search(term))
          {
            "$or": query
          }
        else
          {}
        end
      end

      def name_search(term)
        search_arr = []
        term.split.each { |t| search_arr.append({ "applicant.first_name": t }, "applicant.last_name": t) }
        search_arr
      end

      def email_search(term)
        [
          { "applicant.email": term }
        ]
      end

      def reference_no_search(term)
        [
          {
            "reference_no": {
              "$regex": "^#{term}", "$options": 'i'
            }
          }
        ]
      end

      def tag_query(tag)
        if tag
          { "tag": tag.empty? ? nil : tag }
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
