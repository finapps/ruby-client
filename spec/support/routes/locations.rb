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
        base.delete("/#{base.version}/locations/:key") do
          return status(404) if params[:key] == 'not_found'
          return status(400) unless sha256?(params[:key])

          status 204
        end
      end

      def put_routes(base)
        base.put("/#{base.version}/locations/:key") do
          return status(404) if params[:key] == 'not_found'
          return status(400) unless sha256?(params[:key])

          status 204
        end
      end

      def get_routes(base)
        base.get("/#{base.version}/locations") do
          return status(400) if params[:filter] == 'invalid'

          json_response 200, 'locations/get_locations.json'
        end
        base.get("/#{base.version}/locations/:key") do
          return status(404) if params[:key] == 'not_found'
          return status(400) unless sha256?(params[:key])

          json_response 200, 'locations/get_location.json'
        end
      end
    end

    def sha256?(key)
      key.length == 64 && key.match(/^[0-9a-f]+$/)
    end
  end
end
