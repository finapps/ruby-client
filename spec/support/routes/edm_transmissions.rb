# frozen_string_literal: true

module Fake
  module EdmTransmissionsRoutes
    class << self
      def included(base)
        post_routes base

        super
      end

      def post_routes(base)
        base.post("/#{base.version}/documents/edm/:order_id/transmit") do
          json_response 200, 'edm_transmissions/create.json'
        end
      end
    end
  end
end
