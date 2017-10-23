module FinApps
  module REST
    class OrderRefreshes < FinAppsCore::REST::Resources
      def create(id)
        path = "orders/#{id}/refresh"
        update nil, path
      end
    end
  end
end