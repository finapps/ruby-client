# frozen_string_literal: true

module FinApps
  module Utils
    module QueryBuilder
      def build_query_path(root_url, params)
        filter_obj = build_filter(params)
        page = "page=#{params[:page].to_i}" if params[:page]
        requested = "requested=#{params[:requested].to_i}" if params[:requested]
        sort = "sort=#{ERB::Util.url_encode(params[:sort])}" if params[:sort]
        filter = "filter=#{ERB::Util.url_encode(filter_obj.to_json)}" unless filter_obj.empty?
        query_join(root_url, [page, requested, sort, filter])
      end

      private

      def query_join(root_url, params_array)
        query_string = params_array.compact.join('&')
        [root_url, query_string].reject(&:empty?).join('?')
      end

      def build_filter(_params)
        # stub, to be overwritten by classes that include this module
        {}
      end
    end
  end
end
