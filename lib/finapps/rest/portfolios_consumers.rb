# frozen_string_literal: true

module FinApps
  module REST
    class PortfoliosConsumers < FinAppsCore::REST::Resources
      include FinApps::Utils::QueryBuilder

      def list(portfolio_id, params = nil)
        not_blank(portfolio_id, :portfolio_id)

        path = build_path(portfolio_id)
        return super path if params.nil?

        raise FinAppsCore::InvalidArgumentsError, 'Invalid argument: params' unless params.is_a? Hash

        super build_query_path(path, params)
      end

      def create(portfolio_id, params)
        not_blank(portfolio_id, :portfolio_id)
        not_blank(params, :params)

        return super nil, build_path(portfolio_id, params) if params.is_a?(String) # Single Consumer Subscribe

        # Array Consumer Subscribe
        super params, build_path(portfolio_id)
      end

      def destroy(portfolio_id, consumer_id)
        not_blank(portfolio_id, :portfolio_id)
        not_blank(consumer_id, :consumer_id)

        # Single Consumer Unsubscribe Only
        super nil, build_path(portfolio_id, consumer_id)
      end

      private

      def build_path(portfolio_id, consumer_id = nil)
        consumer_path = consumer_id ? "consumers/#{ERB::Util.url_encode(consumer_id)}" : 'consumers'
        "portfolios/#{ERB::Util.url_encode(portfolio_id)}/" + consumer_path
      end
    end
  end
end
