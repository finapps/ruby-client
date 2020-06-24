# frozen_string_literal: true

module FinApps
  module REST
    class SignedDocumentsDownloads < FinAppsCore::REST::Resources
      def show(consumer_id, signature_request_id)
        not_blank(consumer_id, :consumer_id)
        not_blank(signature_request_id, :signature_request_id)

        path =
          "consumers/#{ERB::Util.url_encode(consumer_id)}/"\
          "documents/#{ERB::Util.url_encode(signature_request_id)}"
        super(nil, path)
      end
    end
  end
end
