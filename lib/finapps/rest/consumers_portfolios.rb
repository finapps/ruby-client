# frozen_string_literal: true

module FinApps
  module REST
    class ConsumersPortfolios < FinAppsCore::REST::Resources
      include FinApps::Utils::QueryBuilder

      def list(id, params = nil)
        not_blank(id)

        path = "consumers/#{ERB::Util.url_encode(id)}/portfolios"
        return super path if params.nil?

        raise FinAppsCore::InvalidArgumentsError, 'Invalid argument: params' unless params.is_a? Hash

        super build_query_path(path, params)
      end
    end
  end
end
