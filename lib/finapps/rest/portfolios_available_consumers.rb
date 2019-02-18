# frozen_string_literal: true

module FinApps
  module REST
    class PortfoliosAvailableConsumers < FinAppsCore::REST::Resources
      include FinApps::Utils::QueryBuilder

      def list(portfolio_id, params = nil)
        not_blank(portfolio_id, :portfolio_id)

        path = "portfolios/#{ERB::Util.url_encode(portfolio_id)}/consumers/available"
        return super path if params.nil?

        raise FinAppsCore::InvalidArgumentsError, 'Invalid argument: params' unless params.is_a? Hash

        super build_query_path(path, params)
      end
    end
  end
end
