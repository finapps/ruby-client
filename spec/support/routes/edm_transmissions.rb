# frozen_string_literal: true

module Fake
  module EdmTransmissionsRoutes
    class << self
      def included(base)
        get_routes base
        post_routes base

        super
      end

      def get_routes(base)
        base.get("/#{base.version}/documents/edm/:transmission_id") do
          json_response 200, 'edm_transmissions/show.json'
        end
      end

      def post_routes(base)
        base.post("/#{base.version}/documents/edm/:order_id/transmit") do
          json_response 200, 'edm_transmissions/create.json'
        end
      end
    end
  end
end
