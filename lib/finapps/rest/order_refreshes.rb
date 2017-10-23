# frozen_string_literal: true

module FinApps
  module REST
    class OrderRefreshes < FinAppsCore::REST::Resources
      def create(id)
        not_blank(id, :id)
        path = "orders/#{id}/refresh"
        update nil, path
      end
    end
  end
end
