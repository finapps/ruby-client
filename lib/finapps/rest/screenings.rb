# frozen_string_literal: true

require 'date'
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
        term_filter(params[:searchTerm])
          .merge(operator_filter(params[:operatorID]))
          .merge(date_range_filter(params[:fromDate], params[:toDate]))
          .merge(progress_filter(params[:progress]))
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
          {'consumer.external_id': term},
          {'operator.first_name': term},
          {'operator.last_name': term}
        ]
      end

      def split_term_array(term)
        return [] unless space?(term)

        arr = []
        term.split.each do |t|
          arr.append('consumer.first_name': t)
          arr.append('consumer.last_name': t)
          arr.append('operator.first_name': t)
          arr.append('operator.last_name': t)
        end

        arr
      end

      def operator_filter(operator_id)
        return {} unless operator_id 
        
        {'operator_id': operator_id}
      end

      def date_range_filter(from_date, to_date)
        return {} unless from_date || to_date

        {'*date_created': from_filter(from_date).merge(to_filter(to_date))}
      end

      def from_filter(from_date)
        return {} unless from_date

        {'$gte': from_date}
      end

      def to_filter(to_date)
        return {} unless to_date

        {'$lt': to_date}
      end

      def progress_filter(progress)
        return {} unless progress

        {progress: Integer(progress)}
      end

      def space?(string)
        /\s/.match?(string)
      end
    end
  end
end
