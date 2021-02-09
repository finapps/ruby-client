# frozen_string_literal: true

require_relative '../utils/query_builder'

module FinApps
  module REST
    class DocumentsOrders < FinAppsCore::REST::Resources
      include FinApps::Utils::QueryBuilder

      def list(params = nil)
        path = 'documents/orders'
        return super(path) if params.nil?
        fail FinAppsCore::InvalidArgumentsError, 'Invalid argument: params' unless params.is_a? Hash

        super build_query_path(path, params)
      end

      def show(id)
        not_blank(id, :order_id)

        if matches_token_format?(id)
          show_by_token id
        else
          show_by_id id
        end
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
        super(nil, "documents/orders/#{id}")
      end

      def show_signing_url(order_id, signature_id)
        not_blank(order_id, :order_id)
        not_blank(signature_id, :signature_id)
        path = "documents/orders/#{order_id}/sign_url/#{signature_id}"
        send_request path, :get
      end

      private

      def show_by_id(id)
        path = "documents/orders/#{id}"
        send_request path, :get
      end

      def show_by_token(jwt)
        path = "documents/retrieve_order?token=#{jwt}"
        send_request path, :get
      end

      def matches_token_format?(str)
        str.match(/^.+\..+\..+$/)
      end

      def build_filter(params)
        search_query(params[:searchTerm])
          .merge(consumer_query(params[:consumer]))
          .merge(tag_query(params[:tag]))
          .merge(status_query(params[:status]))
      end

      def search_query(term)
        return {} unless term

        query = with_space_search(term).concat(name_search(term))
        {"$or": query}
      end

      def name_search(term)
        search_arr = []
        if /\s/.match?(term)
          term.split.each do |t|
            search_arr.append("applicant.first_name": t)
            search_arr.append("applicant.last_name": t)
          end
        end
        search_arr
      end

      def with_space_search(term)
        [{"applicant.email": term},
         {"applicant.first_name": term},
         {"applicant.last_name": term},
         {"applicant.external_id": term},
         {
           reference_no: {
             "$regex": "^#{term}", "$options": 'i'
           }
         }]
      end

      def tag_query(tag)
        return {} unless tag

        {tag: tag.empty? ? nil : tag}
      end

      def status_query(status)
        return {} unless status

        {status: status}
      end

      def consumer_query(consumer)
        return {} unless consumer

        {consumer_id: consumer.empty? ? nil : consumer}
      end
    end
  end
end
