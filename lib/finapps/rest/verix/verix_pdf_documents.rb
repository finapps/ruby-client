# frozen_string_literal: true

module FinApps
  module REST
    class VerixPdfDocuments < FinAppsCore::REST::Resources # :nodoc:
      def show(record_id, provider_id)
        not_blank(record_id, :record_id)
        not_blank(provider_id, :provider_id)
        path =
          "v/record/#{ERB::Util.url_encode(record_id)}/file/#{ERB::Util.url_encode(provider_id)}"
        super(nil, path)
      end
    end
  end
end
