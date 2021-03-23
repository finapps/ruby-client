# frozen_string_literal: true

module Fake
  module ScreeningsRoutes
    class << self
      def included(base)
        resource = "/#{base.version}/screenings"

        list_routes base, resource
        resume_routes base, resource
        update_routes base, resource
        destroy_routes base, resource
        create_routes base, resource
      end

      def list_routes(base, resource)
        base.get(resource) { json_response 200, 'screening_list.json' }
        base.get(resource.gsub('screenings', 'schemas')) do
          json_response 200, 'screenings/tenant_schemas.json'
        end
        base.get("#{resource}/:consumer_id/consumer") do
          if params[:consumer_id] == 'invalid_consumer_id'
            json_response 404, 'session_not_found.json'
          else
            json_response 200, 'screenings/last_session.json'
          end
        end
      end

      def resume_routes(base, resource)
        base.get("#{resource}/:session_id/resume") do
          return resource_not_found if params[:session_id] == 'invalid_id'

          json_response 200, 'screening.json'
        end
      end

      def update_routes(base, resource)
        base.put("#{resource}/:session_id") do
          return resource_not_found if params[:session_id] == 'invalid_id'

          request.body.rewind
          request_payload = JSON.parse request.body.read
          if request_payload['question_id'] == 'invalid'
            json_response 400, 'screening_invalid_update.json'
          else
            json_response 200, 'screening.json'
          end
        end
      end

      def create_routes(base, resource)
        base.post(resource) do
          request.body.rewind
          request_payload = JSON.parse request.body.read
          if request_payload.key? 'email'
            json_response 201, 'screening.json'
          else
            json_response 400, 'invalid_request_body.json'
          end
        end
      end

      def destroy_routes(base, resource)
        base.delete("#{resource}/:session_id") do
          if params[:session_id] == 'valid_id'
            status 200
          else
            json_response 404, 'session_not_found.json'
          end
        end
      end
    end
  end
end
