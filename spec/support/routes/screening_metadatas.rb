# frozen_string_literal: true

module Fake
  module ScreeningMetadatasRoutes
    class << self
      def included(base)
        get_routes base
        post_routes base
        destroy_routes base

        super
      end

      def post_routes(base)
        base.post("/#{base.version}/screenings/:session_id/meta") do
          if params[:session_id] == 'session_id'
            status 204
          else
            json_response 404, 'screening_metadatas/not_found.json'
          end
        end
      end

      def destroy_routes(base)
        base.delete("/#{base.version}/screenings/:session_id/meta/:key") do
          if params[:session_id] == 'session_id'
            status 204
          else
            json_response 404, 'screening_metadatas/not_found.json'
          end
        end
      end

      def get_routes(base)
        base.get("/#{base.version}/screenings/:session_id/meta/:key") do
          if params[:session_id] == 'session_id'
            json_response 200, 'screening_metadatas/show.json'
          else
            json_response 404, 'screening_metadatas/not_found.json'
          end
        end
      end
    end
  end
end
