# frozen_string_literal: true
module FinApps
  module REST
    class OrderAssignments < FinAppsCore::REST::Resources
      def update(id, orders_array)
        not_blank(id, :operator_id)
        not_blank(orders_array, :params)
        raise FinAppsCore::InvalidArgumentsError.new 'Invalid argument: params' unless orders_array.is_a? Array

        path = "operators/#{ERB::Util.url_encode(id)}/assign"
        super orders_array, path
      end
    end
  end
end
