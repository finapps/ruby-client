# frozen_string_literal: true

require_relative '../utils/query_builder'

module FinApps
  module REST
    class Screenings < FinAppsCore::REST::Resources # :nodoc:
      include FinApps::Utils::QueryBuilder

      def show(id)
        not_blank(id, :session_id)

        path = "#{end_point}/#{ERB::Util.url_encode(id)}/resume"
        super(nil, path)
      end

      def tenant_schemas
        path = 'schemas'
        send_request path, :get
      end

      def last(consumer_id)
        not_blank(consumer_id, :consumer_id)

        path = "#{end_point}/#{ERB::Util.url_encode(consumer_id)}/consumer"
        send_request_for_id path, :get, nil
      end

      def create(params)
        not_blank(params, :params)
        super params
      end

      def list(params = nil)
        return super if params.nil?
        fail FinAppsCore::InvalidArgumentsError, 'Invalid argument: params' unless params.is_a? Hash

        super build_query_path(end_point, params)
      end

      def update(id, params)
        not_blank(id, :session_id)
        not_blank(params, :params)

        path = "#{end_point}/#{ERB::Util.url_encode(id)}"
        super params, path
      end

      def destroy(id)
        not_blank(id, :session_id)

        super
      end

      private

      def build_filter(params)
        search_query(params[:searchTerm])
      end

      def search_query(term)
        return {} unless term

        query = search_query_object(term)
        {'$or': query}
      end

      def search_query_object(term)
        [
          {'consumer.public_id': term},
          {'consumer.email': term}
        ]
      end
    end
  end
end
