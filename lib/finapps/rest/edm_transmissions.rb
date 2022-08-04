# frozen_string_literal: true

module FinApps
  module REST
    class EdmTransmissions < FinAppsCore::REST::Resources # :nodoc:
      def create(order_id, params)
        not_blank(order_id, :order_id)

        path = "documents/edm/#{ERB::Util.url_encode(order_id)}/transmit"
        super(params, path)
      end

      def show(transmission_id)
        not_blank(transmission_id, :transmission_id)

        path = "documents/edm/#{ERB::Util.url_encode(transmission_id)}"
        super transmission_id, path
      end

      def show_by_order(order_id)
        not_blank(order_id, :order_id)

        path = "documents/edm/#{ERB::Util.url_encode(order_id)}/status"
        send_request_for_id path, :get, order_id
      end
    end
  end
end
