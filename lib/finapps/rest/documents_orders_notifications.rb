# frozen_string_literal: true

module FinApps
  module REST
    class DocumentsOrdersNotifications < FinAppsCore::REST::Resources
      def create(id)
        not_blank(id, :id)

        path = "documents/orders/#{ERB::Util.url_encode(id)}/notify"
        super nil, path
      end
    end
  end
end
