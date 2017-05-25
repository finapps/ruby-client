# frozen_string_literal: true
module FinApps
  module REST
    class OrderNotifications < FinAppsCore::REST::Resources
      def update(id)
        not_blank(id, :id)

        path = "orders/#{ERB::Util.url_encode(id)}/notify"
        super nil, path
      end
    end
  end
end
