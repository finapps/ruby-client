# frozen_string_literal: true

module FinApps
  module REST
    class VerixDocuments < FinAppsCore::REST::Resources
      def list(record_id)
        not_blank(record_id, :record_id)
        path = "v/record/#{ERB::Util.url_encode(record_id)}/document"
        super path
      end

      def show(record_id, document_id)
        not_blank(record_id, :record_id)
        not_blank(document_id, :document_id)
        path =
          "v/record/#{ERB::Util.url_encode(record_id)}/document/#{ERB::Util.url_encode(document_id)}"
        super(nil, path)
      end
    end
  end
end
