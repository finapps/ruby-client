# frozen_string_literal: true

module FinApps
  module Utils
    module QueryBuilder
      def build_query_path(root_url, params)
        filter_obj = build_filter(params)
        page = "page=#{params[:page]}" if params[:page]
        requested = "requested=#{params[:requested]}" if params[:requested]
        sort = "sort=#{ERB::Util.url_encode(params[:sort])}" if params[:sort]
        filter = "filter=#{ERB::Util.url_encode(filter_obj.to_json)}" if filter_obj && !filter_obj.empty?
        query_join(root_url, [page, requested, sort, filter])
      end

      private

      def query_join(root_url, params_array)
        query_string = params_array.compact.join('&')
        !query_string.empty? ? [root_url, query_string].join('?') : nil
      end
    end
  end
end
