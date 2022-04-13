# frozen_string_literal: true

module Fake
  module LocationsRoutes
    class << self
      def included(base)
        get_routes base
        post_routes base
        put_routes base
        delete_routes base

        super
      end

      def post_routes(base)
        base.post("/#{base.version}/locations") do
          status 204
        end
      end

      def delete_routes(base)
        base.delete("/#{base.version}/locations/:id") do
          return status(404) if params[:id] == 'not_found'

          status 204
        end
      end

      def put_routes(base)
        base.put("/#{base.version}/locations/:id") do
          return status(404) if params[:id] == 'not_found'

          status 204
        end
      end

      def get_routes(base)
        base.get("/#{base.version}/locations") do
          return status(400) if params[:filter] == 'invalid'

          json_response 200, 'locations/get_locations.json'
        end
        base.get("/#{base.version}/locations/:id") do
          return status(404) if params[:id] == 'not_found'

          json_response 200, 'locations/get_location.json'
        end
      end
    end
  end
end
