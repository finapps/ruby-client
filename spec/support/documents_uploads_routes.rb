# frozen_string_literal: true

module Fake
  module DocumentsUploadsRoutes
    class << self
      def included(base)
        base.get("/#{base.version}/consumers/:consumer_id/documents/:doc_id?thumbnail=false") do
          pdf_response 'signed_document.pdf'
        end
        destroy_routes(base)
        destroy_by_consumer_routes(base)
        super
      end

      def destroy_routes(base)
        base.delete("/#{base.version}/documents/orders/valid_order_id/valid_doc_id") { status 204 }
        base.delete("/#{base.version}/documents/orders/valid_order_id/invalid_doc_id") do
          json_response 404, 'resource_not_found.json'
        end
        base.delete("/#{base.version}/documents/orders/invalid_order_id/valid_doc_id") do
          json_response 404, 'resource_not_found.json'
        end
      end

      def destroy_by_consumer_routes(base)
        base.delete("/#{base.version}/consumers/valid_consumer_id/documents/valid_document_id") { status 204 }
        base.delete("/#{base.version}/consumers/invalid_consumer_id/documents/invalid_document_id") do
          json_response 404, 'resource_not_found.json'
        end
        base.delete("/#{base.version}/consumers/invalid_consumer_id/documents/valid_document_id") do
          json_response 404, 'resource_not_found.json'
        end
        base.delete("/#{base.version}/consumers/valid_consumer_id/documents/invalid_document_id") do
          json_response 404, 'resource_not_found.json'
        end
      end
    end
  end
end
