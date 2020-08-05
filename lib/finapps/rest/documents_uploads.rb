# frozen_string_literal: true

module FinApps
  module REST
    class DocumentsUploads < FinAppsCore::REST::Resources
      def show(consumer_id, doc_id, thumbnail = false)
        not_blank(consumer_id, :consumer_id)
        not_blank(doc_id, :doc_id)

        path =
          "consumers/#{ERB::Util.url_encode(consumer_id)}/"\
        "documents/#{ERB::Util.url_encode(doc_id)}?thumbnail=#{thumbnail}"
        super(nil, path)
      end

      def destroy(order_id, doc_id)
        not_blank(order_id, :order_id)
        not_blank(doc_id, :doc_id)
        super(nil, "documents/orders/#{order_id}/#{doc_id}")
      end
    end
  end
end
