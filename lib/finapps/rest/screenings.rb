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
        term = params[:searchTerm]
        progress = params[:progress]
        term_filter(term).merge(progress_filter(progress))
      end

      def term_filter(term)
        return {} unless term

        {'$or': term_array(term) + split_term_array(term)}
      end

      def term_array(term)
        [
          {'consumer.public_id': term},
          {'consumer.email': term},
          {'consumer.first_name': term},
          {'consumer.last_name': term},
          {'consumer.external_id': term}
        ]
      end

      def split_term_array(term)
        return [] unless has_space?(term)

        arr = []
        term.split.each do |t|
          arr.append('consumer.first_name': t)
          arr.append('consumer.last_name': t)
        end

        arr
      end

      def progress_filter(progress)
        return {} unless progress

        {progress: progress}
      end

      def has_space?(string)
        /\s/.match?(string)
      end
    end
  end
end
