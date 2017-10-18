# frozen_string_literal: true

module FinApps
  module Utils
    module QueryBuilder
      def build_query_path(root_url, params)
        page = params[:page] ? "page=#{params[:page]}" : ''
        requested = params[:requested] ? "&requested=#{params[:requested]}" : ''
        sort = params[:sort] ? "&sort=#{ERB::Util.url_encode(params[:sort])}" : ''
        filter = params[:filter] ? "&filter=#{ERB::Util.url_encode(params[:filter])}" : ''
        "#{root_url}?#{page}#{requested}#{sort}#{filter}"
      end
    end
  end
end
