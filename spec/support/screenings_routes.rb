# frozen_string_literal: true

module Fake
  module ScreeningsRoutes
    class << self
      def included(base)
        list_routes base
        resume_routes base
        update_routes base
        destroy_routes base
        create_routes base

        super
      end

      def list_routes(base)
        base.get("/#{base.version}/screenings") do
          json_response 200, 'screening_list.json'
        end
      end

      def resume_routes(base)
        base.get("/#{base.version}/screenings/invalid_id/resume") do
          json_response 404, 'resource_not_found.json'
        end
        base.get("/#{base.version}/screenings/valid_id/resume") do
          json_response 200, 'screening.json'
        end
      end

      def update_routes(base)
        base.put("/#{base.version}/screenings/invalid_id") do
          json_response 404, 'resource_not_found.json'
        end
        base.put("/#{base.version}/screenings/valid_id") do
          request.body.rewind
          request_payload = JSON.parse request.body.read
          if request_payload['question_id'] == 'invalid'
            json_response 400, 'screening_invalid_update.json'
          else
            json_response 200, 'screening.json'
          end
        end
      end

      def create_routes(base)
        base.post("/#{base.version}/screenings") do
          request.body.rewind
          request_payload = JSON.parse request.body.read
          if request_payload.key? 'email'
            json_response 201, 'screening.json'
          else
            json_response 400, 'invalid_request_body.json'
          end
        end
      end

      def destroy_routes(base)
        base.delete("/#{base.version}/screenings/:session_id") do
          if params[:session_id] == 'valid_id'
            status 200
          else
            json_response 404, 'resource_not_found.json'
          end
        end
      end
    end
  end
end
