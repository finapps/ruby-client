# frozen_string_literal: true
module FinApps
  module REST
    class OrderStatuses < FinAppsCore::REST::Resources # :nodoc:
      include ::FinAppsCore::Utils::Validatable
      using ObjectExtensions
      using StringExtensions

      def show(id)
        not_blank(id, :id)

        path = "orders/#{ERB::Util.url_encode(id)}/status"
        super nil, path
      end
    end
  end
end
